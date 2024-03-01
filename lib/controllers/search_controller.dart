import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_app/constant.dart';
import 'package:tiktok_clone_app/models/user.dart';

class SearchedController extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);
  List<User> get searchedUsers => _searchedUsers.value;

  searchUser(String typedUser) async {
    _searchedUsers.bindStream(
      firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: typedUser)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<User> returnVal = [];
          for (var element in query.docs) {
            returnVal.add(User.fromSnap(element));
          }
          return returnVal;
        },
      ),
    );
  }
}
