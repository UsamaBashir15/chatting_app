import 'package:chatting_app/screens/login_page.dart';
import 'package:flutter/material.dart';

import '../Common/Buttons/common_button.dart';

class TermPage extends StatelessWidget {
  const TermPage({Key? key}) : super(key: key);
  static String pageName = 'TermPage';
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: height * .05,
          ),
          SizedBox(
            height: height * .05,
            child: const Text(
              'Welcome to WhatsApp',
              style: TextStyle(
                  color: Color.fromARGB(255, 92, 170, 233),
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: height * .05,
          ),
          Image(
            image: const AssetImage('assets/images/bg.png'),
            height: height * .5,
            width: width * .8,
            color: const Color.fromARGB(255, 92, 170, 233),
          ),
          SizedBox(
            height: height * .05,
          ),
          SizedBox(
            height: height * .1,
            child: const Text(
              'Read our Privacy Policy. Tap "Agree and continue"to\naccept the Term of Service',
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.3,
                color: Color.fromARGB(255, 92, 170, 233),
              ),
            ),
          ),
          SizedBox(
            width: width * .75,
            height: height * .07,
            child: CommonButton(
              text: 'AGREE AND CONTINUE',
              onPressed: () {
                Navigator.pushNamed(context, LoginPage.pageName);
              },
              color: const Color.fromARGB(255, 92, 170, 233),
            ),
          ),
        ],
      )),
    ));
  }
}
