// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chatting_app/Common/repository/common_firebase_storage.dart';
import 'package:chatting_app/modal/user_modal.dart';
import 'package:chatting_app/screens/main_chatiing_page.dart';
import 'package:chatting_app/screens/user_information_page.dart';
import 'package:chatting_app/screens/verification_code_page.dart';

import '../Common/errors/error.dart';

final authRepositoryProvider = Provider(
  (ref) {
    return AuthRepository(
        ref: ref,
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance);
  },
);

final getCurrentUserDataProvider = FutureProvider(
  (ref) {
    var user = ref.watch(authRepositoryProvider);
    return user.getCurrentUserData();
  },
);

class AuthRepository {
  ProviderRef ref;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.ref,
    required this.auth,
    required this.firestore,
  });

  void signInWithPhoneNumber(
      {required BuildContext context, required String phoneNumber}) {
    auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          showSnackBar(context, 'Done');
        },
        verificationFailed: (e) {
          showSnackBar(context, 'Error');
        },
        codeSent: (String verificationId, int? tokken) {
          Navigator.pushNamed(context, VerificationPage.pageName,
              arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (e) {
          showSnackBar(context, 'Time Out');
        });
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOTP}) async {
    var credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: userOTP);
    try {
      await auth.signInWithCredential(credential);
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationPage.pageName, (route) => false);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  saveUserDataInFirebase({
    required String name,
    required File? profilePicture,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      print('Heloo Bro 1');
      if (profilePicture != null) {
        String pictureUrl = await ref
            .read(commonFirebaseStorageProvider)
            .value!
            .saveFileInFirebaseStorage('profilePic/$uid', profilePicture);
        UserModal userModal = UserModal(
            uid: uid,
            name: name,
            profilePic: pictureUrl,
            isOnline: true,
            phoneNumber: auth.currentUser!.phoneNumber!,
            groupId: []);

        firestore.collection('users').doc(uid).set(userModal.toMap());
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(
            context, MainChattingPage.pageName, (route) => false);
      } else {
        showSnackBar(context, 'Select Your Image');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<UserModal?> getCurrentUserData() async {
    UserModal? user;
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    if (userData.data() != null) {
      user = UserModal.fromMap(userData.data()!);
    }
    return user;
  }
}
