// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:chatting_app/Common/errors/error.dart';
import 'package:chatting_app/modal/user_modal.dart';
import 'package:chatting_app/screens/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactRepositoryProvider = Provider(
  (ref) {
    return SelectContactRepository(firestore: FirebaseFirestore.instance);
  },
);
final selectContactRepositoryFutureProvider = FutureProvider(
  (ref) {
    var data = ref.watch(selectContactRepositoryProvider).getContacts();
    return data;
  },
);

class SelectContactRepository {
  FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      // showSnackBar(context, 'Not Found on this App');
    }

    return contacts;
  }

  selectedContact(Contact selectedContact, BuildContext context) async {
    bool isfound = false;
    try {
      var usersCollection = await firestore.collection('users').get();

      for (var document in usersCollection.docs) {
        var singleUser = UserModal.fromMap(document.data());
        var selectedNumber =
            selectedContact.phones[0].normalizedNumber.replaceAll(' ', '');

        if (singleUser.phoneNumber == selectedNumber) {
          isfound = true;

          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, ChattingPage.pageName, arguments: {
            'name': selectedContact.displayName,
            'uid': singleUser.uid
          });
        }
      }

      if (!isfound) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Not found this user on this App');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      // showSnackBar(context, e.toString());
    }
  }

  Stream<UserModal> getUserInfoById(String uId) {
    return firestore
        .collection('users')
        .doc(uId)
        .snapshots()
        .map((event) => UserModal.fromMap(event.data()!));
  }
}
