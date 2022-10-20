import 'package:chatting_app/screens/contacts_list_page.dart';
import 'package:chatting_app/screens/term_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main_chat_TabBar_Screens/tab_bar.dart';
import '../repository/repository.dart';

class MainChattingPage extends ConsumerStatefulWidget {
  const MainChattingPage({Key? key}) : super(key: key);
  static String pageName = 'MainChattingPage';
  @override
  ConsumerState<MainChattingPage> createState() => _MainChattingPageState();
}

class _MainChattingPageState extends ConsumerState<MainChattingPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          title: const Text('WhatsApp'),
          bottom: const TabBar(tabs: [
            Tab(
              text: 'CHATS',
            ),
            Tab(
              text: 'STATUS',
            ),
            Tab(
              text: 'CALLS',
            )
          ]),
          actions: [
            IconButton(
              onPressed: () {
                ref.read(authRepositoryProvider).auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, TermPage.pageName, (route) => false);
              },
              icon: const Icon(Icons.logout),
            ),
            const SizedBox(
              width: 15,
            )
          ],
        ),
        body: TabBarView(children: [
          Tab1(),
          const Tab2(),
          const Tab3(),
        ]),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.chat),
          onPressed: () {
            Navigator.pushNamed(context, ContactListPage.pageName);
          },
        ),
      ),
    );
  }
}
