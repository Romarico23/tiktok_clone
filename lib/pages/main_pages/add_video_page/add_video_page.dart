import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone_app/pages/main_pages/add_video_page/confirm_video_page.dart';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({super.key});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
// PICK A VIDEO
  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);

    if (video != null) {
      Get.to(
        ConfirmVideoPage(
          videoFile: File(video.path),
          videoPath: video.path,
        ),
      );
    }
  }

  // DIALOG OPTIONS
  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {
              pickVideo(ImageSource.gallery, context);
            },
            child: const Row(
              children: [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsetsDirectional.all(7),
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              pickVideo(ImageSource.camera, context);
            },
            child: const Row(
              children: [
                Icon(Icons.camera),
                Padding(
                  padding: EdgeInsetsDirectional.all(7),
                  child: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Get.back();
              // Navigator.of(context).pop();
            },
            child: const Row(
              children: [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsetsDirectional.all(7),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/upload.jpg',
            width: 260,
          ),
          Center(
            child: InkWell(
              onTap: () {
                showOptionsDialog(context);
              },
              child: Container(
                width: 190,
                height: 50,
                decoration: BoxDecoration(color: Colors.red[400]),
                child: const Center(
                  child: Text(
                    'Add Video',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
