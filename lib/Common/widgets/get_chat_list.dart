import 'package:chatting_app/Common/repository/chat_repository.dart';
import 'package:chatting_app/Common/widgets/loading_widget.dart';
import 'package:chatting_app/Common/widgets/receiver_message_card.dart';
import 'package:chatting_app/Common/widgets/sender_message_card.dart';
import 'package:chatting_app/modal/message_modal.dart';
import 'package:chatting_app/repository/repository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatListData extends ConsumerWidget {
  ChatListData({Key? key, required this.receiverUserId}) : super(key: key);
  String receiverUserId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<MessageModal>>(
      stream:
          ref.read(chatRepositoryProvider).getAllChatsStream(receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var auth = ref.read(authRepositoryProvider);
            if (snapshot.hasData) {
              var message = snapshot.data![index].text;
              var date = DateFormat.Hm().format(snapshot.data![index].timeSent);
              if (snapshot.data![index].senderId ==
                  auth.auth.currentUser!.uid) {
                var userContactId = snapshot.data![index].receiverId;
                var messageId = snapshot.data![index].messageId;
                return MyMessageCard(
                  message: message,
                  date: date,
                  messageId: messageId,
                  userContactId: userContactId,
                );
              } else {
                var userContactId = snapshot.data![index].senderId;
                var messageId = snapshot.data![index].messageId;
                return ReceiverMessageCard(
                  message: message,
                  date: date,
                  messageId: messageId,
                  userContactId: userContactId,
                );
              }
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}
