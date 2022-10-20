// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:chatting_app/Common/enums/chat_enums.dart';
import 'package:chatting_app/Common/errors/error.dart';
import 'package:chatting_app/modal/chat_contact_modal.dart';
import 'package:chatting_app/modal/message_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../modal/user_modal.dart';
import '../../repository/repository.dart';

final chatRepositoryProvider = Provider(
  (ref) {
    return ChatRepository(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
        ref: ref);
  },
);

class ChatRepository {
  ProviderRef ref;
  FirebaseFirestore firestore;
  FirebaseAuth auth;

  ChatRepository(
      {required this.firestore, required this.auth, required this.ref});

  void sendTextMessage(
      {required BuildContext context,
      required String receiverUserId,
      required UserModal senderUserData,
      required String text}) async {
    try {
      log(1.toString());
      DateTime time = DateTime.now();
      var receiverUserDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      UserModal receiverUserData =
          UserModal.fromMap(receiverUserDataMap.data()!);
      log(2.toString());

      saveDataToContactSubCollection(
          receiverUserData: receiverUserData,
          senderUserData: senderUserData,
          text: text,
          timeSent: time);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void saveDataToContactSubCollection({
    required UserModal senderUserData,
    required UserModal receiverUserData,
    required String text,
    required DateTime timeSent,
  }) async {
    var messageId = const Uuid().v1();

    var receiverChatContact = ChatContactModal(
        name: senderUserData.name,
        userProfile: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    log(3.toString());

    await firestore
        .collection('users')
        .doc(receiverUserData.uid)
        .collection('chats')
        .doc(senderUserData.uid)
        .set(receiverChatContact.toMap());

    var senderChatContact = ChatContactModal(
        name: receiverUserData.name,
        userProfile: receiverUserData.profilePic,
        contactId: receiverUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    log(4.toString());

    await firestore
        .collection('users')
        .doc(senderUserData.uid)
        .collection('chats')
        .doc(receiverUserData.uid)
        .set(senderChatContact.toMap());

    saveMessageToMessageSubCollection(
        senderUserName: senderUserData.name,
        receiverUserName: receiverUserData.name,
        timeSent: timeSent,
        text: text,
        receiverUserId: receiverUserData.uid,
        messageType: MessageEnum.text,
        messageId: messageId);
  }

  void saveMessageToMessageSubCollection(
      {required String senderUserName,
      required String receiverUserName,
      required String messageId,
      required DateTime timeSent,
      required String text,
      required String receiverUserId,
      required MessageEnum messageType}) async {
    log(text);
    var message = MessageModal(
        senderId: auth.currentUser!.uid,
        receiverId: receiverUserId,
        text: text,
        messageType: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false);

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
    log('5');

    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
    log('6');
  }

  void chatRestoreMethod(
      BuildContext context, String text, String receiverUserId) {
    ref.read(getCurrentUserDataProvider).whenData((value) => sendTextMessage(
        context: context,
        receiverUserId: receiverUserId,
        senderUserData: value!,
        text: text));
  }

  Stream<List<ChatContactModal>> getListOfChatContact() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModal> chats = [];
      for (var document in event.docs) {
        var chatContact = ChatContactModal.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModal.fromMap(userData.data()!);
        chats.add(ChatContactModal(
            name: user.name,
            userProfile: user.profilePic,
            contactId: user.uid,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      return chats;
    });
  }

//a
  Stream<List<MessageModal>> getAllChatsStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModal> message = [];
      for (var document in event.docs) {
        message.add(MessageModal.fromMap(document.data()));
      }
      return message;
    });
  }

  void deleteSingleUserWholeChat(String userContactId) async {
    log(userContactId);
    var fire = await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(userContactId)
        .collection('messages');

    fire.snapshots().listen((event) async {
      for (var doc in event.docs) {
        var id = MessageModal.fromMap(doc.data()).messageId;

        await fire.doc(id).delete();
      }
    });
    // await firestore
    //     .collection('users')
    //     .doc(auth.currentUser!.uid)
    //     .collection('chats')
    //     .doc(userContactId)
    //     .collection('messages')
    //     .doc()
    //     .delete();

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(userContactId)
        .delete();
  }

  void deleteSingleChat(userContactId, messageId) {
    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(userContactId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }
}
