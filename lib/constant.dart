// FIREBASE
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone_app/controllers/auth_controller.dart';
import 'package:tiktok_clone_app/pages/main_pages/add_video_page/add_video_page.dart';
import 'package:tiktok_clone_app/pages/main_pages/chat_page/chat_page.dart';
import 'package:tiktok_clone_app/pages/main_pages/profile_page.dart';
import 'package:tiktok_clone_app/pages/main_pages/search_page.dart';
import 'package:tiktok_clone_app/pages/main_pages/video_page/video_page.dart';

List<Widget> pages() {
  return [
    const VideoPage(),
    SearchPage(),
    const AddVideoPage(),
    ChatPage(),
    ProfilePage(uid: authController.user.uid),
  ];
}

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instanceAuth;
