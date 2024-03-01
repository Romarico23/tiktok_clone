import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_app/controllers/upload_video_controller.dart';
import 'package:tiktok_clone_app/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmVideoPage extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const ConfirmVideoPage({
    super.key,
    required this.videoFile,
    required this.videoPath,
  });

  @override
  State<ConfirmVideoPage> createState() => _ConfirmVideoPageState();
}

class _ConfirmVideoPageState extends State<ConfirmVideoPage> {
  late VideoPlayerController videoController;
  TextEditingController songNameController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  bool isLoading = false;

  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    setState(() {
      videoController = VideoPlayerController.file(widget.videoFile);
    });

    videoController.initialize();
    videoController.play();
    videoController.setVolume(1);
    videoController.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  uploadVideo() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                child: VideoPlayer(videoController),
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width - 20,
                      child: TextInputField(
                        controller: songNameController,
                        labelText: 'Song Name',
                        icon: Icons.music_note,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width - 20,
                      child: TextInputField(
                        controller: captionController,
                        labelText: 'Caption',
                        icon: Icons.closed_caption,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isLoading
                        ? const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Uploading...   ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 23.0,
                                  width: 23.0,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              uploadVideo();
                              setState(() {
                                isLoading = true;
                              });
                              await uploadVideoController.uploadVideo(
                                songNameController.text,
                                captionController.text,
                                widget.videoPath,
                              );
                              setState(() {
                                isLoading = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              'Share!',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
