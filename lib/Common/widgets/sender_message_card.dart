import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/chat_repository.dart';

class MyMessageCard extends ConsumerWidget {
  final String message;
  final String date;
  final String userContactId;
  final String messageId;

  const MyMessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.userContactId,
      required this.messageId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: InkWell(
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete'),
                    content: const Text('Are You Sure?'),
                    actions: [
                      InkWell(
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text('Cancel', style: TextStyle(fontSize: 20)),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text('ok', style: TextStyle(fontSize: 20)),
                        ),
                        onTap: () {
                          ref
                              .read(chatRepositoryProvider)
                              .deleteSingleChat(userContactId, messageId);
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  );
                });
          },
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: const Color.fromARGB(255, 55, 147, 159),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.done_all,
                        size: 20,
                        color: Colors.white60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
