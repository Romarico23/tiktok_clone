import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_app/constant.dart';
import 'package:tiktok_clone_app/controllers/message_controller.dart';
import 'package:tiktok_clone_app/widgets/chat_bubble.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessagePage extends StatefulWidget {
  final String receiverName;
  final String receiverUid;
  final String receiverProfilePhoto;
  const MessagePage({
    super.key,
    required this.receiverName,
    required this.receiverUid,
    required this.receiverProfilePhoto,
  });

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController messageTextController = TextEditingController();
  MessageController messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    messageController.updatePostId(widget.receiverUid);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.grey[900],
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: NetworkImage(widget.receiverProfilePhoto),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.receiverName,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  return ListView.builder(
                    reverse: true,
                    itemCount: messageController.messages.length,
                    itemBuilder: (context, index) {
                      final message = messageController.messages[index];
                      return ListTile(
                        titleAlignment: ListTileTitleAlignment.bottom,
                        leading: message.receiverId == authController.user.uid
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  backgroundImage:
                                      NetworkImage(message.profilePhoto),
                                ),
                              )
                            : null,
                        trailing: message.receiverId != authController.user.uid
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  backgroundImage:
                                      NetworkImage(message.profilePhoto),
                                ),
                              )
                            : null,
                        title: Column(
                          crossAxisAlignment:
                              message.receiverId == authController.user.uid
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                          children: [
                            ChatBubble(
                              message: message.message,
                              color:
                                  message.receiverId == authController.user.uid
                                      ? const Color.fromARGB(255, 72, 72, 72)
                                      : Colors.blue,
                            ),
                            Text(
                              timeago.format(
                                message.datePublished.toDate(),
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: TextFormField(
                controller: messageTextController,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: 'Message',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              trailing: TextButton(
                onPressed: () {
                  messageController.sendMessage(messageTextController.text);
                  messageTextController.clear();
                },
                child: const Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
