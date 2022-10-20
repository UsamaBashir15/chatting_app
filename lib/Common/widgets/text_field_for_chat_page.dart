import 'dart:developer';

import 'package:chatting_app/Common/repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repository/repository.dart';

class ChatTextField extends ConsumerStatefulWidget {
  const ChatTextField({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  ConsumerState<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends ConsumerState<ChatTextField> {
  var chatController = TextEditingController();
  var isTyping = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        SizedBox(
          width: width * .84,
          height: height * .8,
          child: TextFormField(
            maxLines: 300,
            onChanged: ((value) {
              if (value.isEmpty) {
                isTyping = false;
                setState(() {});
              } else {
                isTyping = true;
                setState(() {});
              }
            }),
            controller: chatController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 30),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              hintText: 'Message',
              prefixIcon: IconButton(
                color: Colors.grey,
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: const Icon(
                  Icons.emoji_emotions_outlined,
                ),
              ),
              suffix: IconButton(
                color: Colors.grey,
                padding: const EdgeInsets.only(left: 30),
                onPressed: () {},
                icon: const Icon(Icons.attach_file),
              ),
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.grey,
                ),
              ),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
        SizedBox(
          width: width * .005,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 1.6, right: 1.6),
          child: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 68, 146, 209),
              radius: 26,
              child: InkWell(
                onTap: () {
                  sendTextMessage();
                  chatController.text = '';
                },
                child: Icon(
                  isTyping ? Icons.send : Icons.mic,
                  color: Colors.white,
                ),
              )),
        )
      ],
    );
  }

  void sendTextMessage() {
    if (isTyping) {
      // ref
      //     .read(chatRepositoryProvider)
      //     .sendTextMessage(context: context, receiverUserId: widget.uid, senderUserData: , text: chatController.text.trim());
      //     // .chatRestoreMethod(context, chatController.text.trim(), widget.uid);

      ref.read(getCurrentUserDataProvider).whenData((value) {
        log(value.toString());
        var repo = ref.read(chatRepositoryProvider);
        return repo.sendTextMessage(
            context: context,
            receiverUserId: widget.uid,
            senderUserData: value!,
            text: chatController.text.trim());
      });
    }
  }
}
