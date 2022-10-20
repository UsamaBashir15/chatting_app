import 'package:chatting_app/Common/repository/contact_repository.dart';
import 'package:chatting_app/Common/widgets/get_chat_list.dart';
import 'package:chatting_app/modal/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Common/widgets/text_field_for_chat_page.dart';

class ChattingPage extends ConsumerStatefulWidget {
  const ChattingPage({Key? key}) : super(key: key);
  static String pageName = 'ChattingPage';
  @override
  ConsumerState<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends ConsumerState<ChattingPage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var userObject =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var userName = userObject['name'];
    var uId = userObject['uid'];
    return Scaffold(
      appBar: getAppBar(userName, uId),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(255, 84, 158, 218), BlendMode.color),
                  fit: BoxFit.fitHeight,
                  image: AssetImage('assets/images/backgroundImage.png'))),
          child: Column(
            children: [
              SizedBox(
                height: height * .8,
                width: width,
                child: ChatListData(receiverUserId: uId),
              ),
              SizedBox(
                height: height * .07,
                width: width,
                child: ChatTextField(uid: uId),
              ),
              SizedBox(
                height: height * .01,
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBar(userName, uId) {
    return AppBar(
        actions: getListOfAppIcons(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName),
            StreamBuilder<UserModal>(
              stream: ref
                  .watch(selectContactRepositoryProvider)
                  .getUserInfoById(uId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      snapshot.data!.isOnline ? 'online' : '',
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          ],
        ));
  }

  List<Widget> getListOfAppIcons() {
    return [
      IconButton(
        color: Colors.white,
        padding: EdgeInsets.zero,
        onPressed: () {},
        icon: const Icon(
          Icons.video_call,
        ),
      ),
      IconButton(
        color: Colors.white,
        padding: EdgeInsets.zero,
        onPressed: () {},
        icon: const Icon(
          Icons.call,
        ),
      ),
      IconButton(
        color: Colors.white,
        padding: EdgeInsets.zero,
        onPressed: () {},
        icon: const Icon(
          Icons.more_vert,
        ),
      ),
    ];
  }
}
