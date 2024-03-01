import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String profilePhoto;
  String receiverId;
  String message;
  // ignore: prefer_typing_uninitialized_variables
  final datePublished;

  Message({
    required this.senderId,
    required this.profilePhoto,
    required this.receiverId,
    required this.message,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'profilePhoto': profilePhoto,
        'receiverId': receiverId,
        'message': message,
        'datePublished': datePublished,
      };

  static Message fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Message(
      senderId: snapshot['senderId'],
      profilePhoto: snapshot['profilePhoto'],
      receiverId: snapshot['receiverId'],
      message: snapshot['message'],
      datePublished: snapshot['datePublished'],
    );
  }
}
