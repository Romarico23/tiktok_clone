import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone_app/constant.dart';
import 'package:tiktok_clone_app/models/user.dart' as model;
import 'package:tiktok_clone_app/pages/main_page.dart';
import 'package:tiktok_clone_app/pages/login_page.dart';

class AuthController extends GetxController {
  static AuthController instanceAuth = Get.find();
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;

// PERSISTING USER STATE
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, setInitialPage);
  }

  // SET INITIAL SCREEN
  setInitialPage(User? user) {
    if (user == null) {
      {
        Get.offAll(const LoginPage());
      }
    } else {
      {
        Get.offAll(const MainPage());
      }
    }
  }

// PICK IMAGE FOR PROFILE PHOTO
  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      Get.snackbar(
        'Profile Picture',
        'You have successfully selected your profile picture!',
      );
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

// UPLOAD PROFILE PROFILE TO FIREBASE STORAGE
  Future<String> uploadToStorage(File image) async {
    Reference reference = firebaseStorage
        .ref()
        .child('Profile Pictures')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = reference.putFile(
        image,
        SettableMetadata(
          contentType: 'image/jpg',
        ));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // REGISTER THE USER
  registerUser(
    File? image,
    String username,
    String email,
    String password,
  ) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // SAVE USER TO AUTH AND FIREBASE FIRESTORE
        UserCredential credential = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        String downloadUrl = await uploadToStorage(image);

        model.User user = model.User(
            name: username,
            email: email,
            profilePhoto: downloadUrl,
            uid: credential.user!.uid);

        await firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson());

        Get.to(const MainPage());

        Get.snackbar(
          'Account Created',
          'Congratulations, your account has been created.',
        );
      } else {
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Creating Account',
        'Please enter all the fields',
      );
    }
  }

  // LOGIN USER
  loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);

        Get.snackbar(
          'Login Success',
          "You're Already Login",
        );
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Logging in',
        e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
