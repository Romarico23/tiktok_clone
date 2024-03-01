import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_app/constant.dart';
import 'package:tiktok_clone_app/models/video.dart';
import 'package:tiktok_clone_app/pages/main_page.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  Future<String> uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(
      await compressVideo(videoPath),
      SettableMetadata(contentType: 'video/mp4'),
    );
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(
      await getThumbnail(videoPath),
      SettableMetadata(contentType: 'video/mp4'),
    );
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // UPLOAD VIDEO
  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      if (songName.isNotEmpty && caption.isNotEmpty && videoPath.isNotEmpty) {
        String uid = firebaseAuth.currentUser!.uid;
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(uid).get();
        var allDocs = await firestore.collection('videos').get();
        int index = allDocs.docs.length;
        String videoUrl = await uploadVideoToStorage('Video $index', videoPath);
        String thumbnail =
            await uploadImageToStorage('Video $index', videoPath);

        Video video = Video(
          username: (userDoc.data()! as Map<String, dynamic>)['name'],
          uid: uid,
          id: 'Video $index',
          likes: [],
          commentCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          thumbnail: thumbnail,
          profilePhoto:
              (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        );

        await firestore.collection('videos').doc('Video $index').set(
              video.toJson(),
            );
        Get.to(const MainPage());
        Get.snackbar(
          'Uploading Complete!',
          'Video Uploaded',
          backgroundColor: Colors.grey[800],
        );
      } else {
        Get.snackbar(
          'Error Uploading Video',
          'Please Complete The Details',
          backgroundColor: Colors.grey[800],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }
}
