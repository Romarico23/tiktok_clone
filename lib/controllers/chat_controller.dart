import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_app/constant.dart';
import 'package:tiktok_clone_app/models/user.dart';

class ChatController extends GetxController {
  final Rx<List<User>> _chatUsers = Rx<List<User>>([]);
  List<User> get chatUsers => _chatUsers.value;

  @override
  void onInit() {
    super.onInit();
    _chatUsers.bindStream(
      firestore.collection('users').snapshots().map(
        (QuerySnapshot query) {
          List<User> returnVal = [];
          for (var element in query.docs) {
            returnVal.add(
              User.fromSnap(element),
            );
          }
          return returnVal;
        },
      ),
    );
  }
}
