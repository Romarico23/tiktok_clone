import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_app/constant.dart';
import 'package:tiktok_clone_app/controllers/chat_controller.dart';
import 'package:tiktok_clone_app/models/user.dart';
import 'package:tiktok_clone_app/pages/main_pages/chat_page/message_page.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ListView.builder(
          itemCount: chatController.chatUsers.length,
          itemBuilder: (context, index) {
            User user = chatController.chatUsers[index];

            return user.uid != authController.user.uid
                ? InkWell(
                    onTap: () {
                      Get.to(
                        MessagePage(
                          receiverName: user.name,
                          receiverUid: user.uid,
                          receiverProfilePhoto: user.profilePhoto,
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePhoto),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Container();
          },
        );
      },
    );
  }
}
