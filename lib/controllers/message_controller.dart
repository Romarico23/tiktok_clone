import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_app/constant.dart';
import 'package:tiktok_clone_app/models/message.dart';

class MessageController extends GetxController {
  final Rx<List<Message>> _messages = Rx<List<Message>>([]);
  List<Message> get messages => _messages.value;

  String _postId = '';
  updatePostId(String id) {
    _postId = id;
    getMessage();
  }

  getMessage() async {
    List<String> ids = [
      authController.user.uid,
      _postId,
    ];
    ids.sort();
    String chatRoomId = ids.join('_');

    _messages.bindStream(
      firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('datePublished', descending: true)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<Message> returnVal = [];
          for (var element in query.docs) {
            returnVal.add(Message.fromSnap(element));
          }
          return returnVal;
        },
      ),
    );
  }

  sendMessage(String messageText) async {
    try {
      if (messageText.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(authController.user.uid)
            .get();

        Message message = Message(
          senderId: authController.user.uid,
          profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
          receiverId: _postId,
          message: messageText.trim(),
          datePublished: DateTime.now(),
        );

        List<String> ids = [
          authController.user.uid,
          _postId,
        ];
        ids.sort();
        String chatRoomId = ids.join('_');

        await firestore
            .collection('chat_rooms')
            .doc(chatRoomId)
            .collection('messages')
            .add(message.toJson());
      }
    } catch (e) {
      Get.snackbar(
        'Error While Messaging',
        e.toString(),
      );
    }
  }
}
