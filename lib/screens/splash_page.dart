import 'dart:async';

import 'package:chatting_app/screens/term_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Common/widgets/loading_widget.dart';
import '../repository/repository.dart';
import 'main_chatiing_page.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static String pageName = 'SplashPage';

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 1),
      () {
        print('object');
        // Navigator.pushNamedAndRemoveUntil(
        //     context, MainChattingPage.pageName, (route) => false);
        ref.read(getCurrentUserDataProvider).when(data: (userData) {
          print(userData);
          if (userData == null) {
          } else {}
        }, error: (error, stac) {
          return null;
        }, loading: () {
          return const LoadingWidget();
        });
        FirebaseAuth.instance.currentUser != null
            ? Navigator.pushNamedAndRemoveUntil(
                context, MainChattingPage.pageName, (route) => false)
            : Navigator.pushNamedAndRemoveUntil(
                context, TermPage.pageName, (route) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // timerCall();
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 29, 185, 220),
      backgroundColor: const Color(0xff5dbdea),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: height * .4,
            ),
            SizedBox(
              height: height * .2,
              child:
                  const Image(image: AssetImage('assets/images/app_icon.jpg')),
            ),
            SizedBox(
              height: height * .1,
              child: const Text(
                'Chats',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  // timerCall() {
  //   timer =
  // }
}
