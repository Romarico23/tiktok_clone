import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_app/constant.dart';
import 'package:tiktok_clone_app/models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
      firestore
          .collection('videos')
          .orderBy('id', descending: true)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<Video> returnVal = [];
          for (var element in query.docs) {
            returnVal.add(
              Video.fromSnap(element),
            );
          }
          return returnVal;
        },
      ),
    );
  }

  likeVideo(String id) async {
    DocumentSnapshot docsnap =
        await firestore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((docsnap.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }
}
