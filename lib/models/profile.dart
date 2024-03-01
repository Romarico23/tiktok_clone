import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String username;
  String uid;
  String profilePhoto;
  String likes;
  int followers;
  int following;
  bool isFollowing;
  List thumbnails;

  Profile({
    required this.username,
    required this.uid,
    required this.profilePhoto,
    required this.likes,
    required this.followers,
    required this.following,
    required this.isFollowing,
    required this.thumbnails,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        ' uid': uid,
        'profilePhoto': profilePhoto,
        'likes': likes,
        'followers': followers,
        'following': following,
        'isFollowing': isFollowing,
        'thumbnails': thumbnails,
      };

  static Profile fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Profile(
      username: snapshot['username'],
      uid: snapshot['uid'],
      profilePhoto: snapshot['profilePhoto'],
      likes: snapshot['likes'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      isFollowing: snapshot['isFollowing'],
      thumbnails: snapshot['thumbnails'],
    );
  }
}
