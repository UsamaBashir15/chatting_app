import 'package:chatting_app/Common/repository/contact_repository.dart';
import 'package:chatting_app/Common/widgets/loading_widget.dart';
import 'package:chatting_app/screens/search_contact_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactListPage extends ConsumerWidget {
  const ContactListPage({Key? key}) : super(key: key);
  static String pageName = 'ContactListPage';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: getAppBar(context), body: getContactList(ref, context));
  }

  PreferredSizeWidget getAppBar(context) {
    return AppBar(
        // bottom: const PreferredSize(
        //   preferredSize: Size(20, 0),
        //   child: Padding(
        //     padding: EdgeInsets.only(right: 100),
        //     child: Text('322'),
        //   ),
        // ),
        // centerTitle: true,
        title: const Text('Select Contact'),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(left: 30),
            onPressed: () {
              Navigator.pushNamed(context, SelectContactScreen.pageName);
            },
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(left: 14),
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ]);
  }

  Widget getContactList(WidgetRef ref, BuildContext context) {
    return ref.watch(selectContactRepositoryFutureProvider).when(
        data: (contact) {
      return ListView.builder(
        itemCount: contact.length,
        itemBuilder: (context, index) {
          var name = contact[index].displayName;

          return InkWell(
            onTap: () {
              selectedContactMethod(context, contact[index], ref);
            },
            child: ListTile(
              title: Text(name),
            ),
          );
        },
      );
    }, error: (error, trac) {
      return const Text('');
    }, loading: () {
      return const LoadingWidget();
    });
  }

  void selectedContactMethod(
      BuildContext context, Contact selectedContact, WidgetRef ref) {
    ref
        .read(selectContactRepositoryProvider)
        .selectedContact(selectedContact, context);
  }
}
