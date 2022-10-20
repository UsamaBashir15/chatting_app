import 'dart:developer';

import 'package:chatting_app/Common/widgets/loading_widget.dart';
import 'package:chatting_app/modal/chat_contact_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Common/repository/chat_repository.dart';
import '../screens/chat_page.dart';

class Tab1 extends ConsumerWidget {
  Tab1({Key? key}) : super(key: key);
  var lastMessage = '';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Color(0xfffefefe),
      body: StreamBuilder<List<ChatContactModal>>(
          stream: ref.read(chatRepositoryProvider).getListOfChatContact(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (!(snapshot.data!.length == 0)) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var amOrPm = 'AM';

                    var checkHour = snapshot.data![index].timeSent.hour;
                    if (checkHour >= 12) {
                      amOrPm = 'PM';
                    }
                    lastMessage = snapshot.data![index].lastMessage;
                    if (snapshot.data![index].lastMessage.length >= 15) {
                      log(snapshot.data![index].lastMessage.length.toString());
                      lastMessage = snapshot.data![index].lastMessage;
                      lastMessage = lastMessage.substring(0, 15);
                    }
                    return InkWell(
                      onLongPress: () {
                        onLongPressDelete(context, ref, snapshot, index);
                      },
                      onTap: () {
                        Navigator.pushNamed(context, ChattingPage.pageName,
                            arguments: {
                              'name': snapshot.data![index].name,
                              'uid': snapshot.data![index].contactId
                            });
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data![index].userProfile)),
                        title: Text(snapshot.data![index].name),
                        subtitle: Text('$lastMessage...'),
                        trailing: Text(
                            '${snapshot.data![index].timeSent.hour.toString()}:${snapshot.data![index].timeSent.minute.toString()} $amOrPm '),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                    child: Image(image: AssetImage('assets/images/talk.png')));
              }
            } else {
              return LoadingWidget();
            }
          }),
    );
  }

  void onLongPressDelete(BuildContext context, WidgetRef ref, snapshot, index) {
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
                  ref.read(chatRepositoryProvider).deleteSingleUserWholeChat(
                      snapshot.data![index].contactId);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          );
        });
  }
}

class Tab2 extends StatelessWidget {
  const Tab2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Text(
          'Status Screen',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}

class Tab3 extends StatelessWidget {
  const Tab3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 73, 220, 190),
      body: Center(
        child: Text(
          'Calls Screen',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
