import 'package:chatting_app/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Common/Buttons/common_button.dart';
import '../Common/errors/error.dart';

// ignore: must_be_immutable
class LoginPage extends ConsumerWidget {
  var numberController = TextEditingController();
  static String pageName = 'LoginPage';
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 40, 70, 94),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 40, 70, 94),
          centerTitle: true,
          title: const Text('Enter your phone number'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: height * .02,
                ),
                SizedBox(
                  height: height * .05,
                  child: const Text(
                    'WhatsApp will need to verify,your phone number',
                    style: TextStyle(height: 1.3, color: Colors.white
                        // color: Color.fromARGB(255, 92, 170, 233),
                        ),
                  ),
                ),
                SizedBox(
                  height: height * .1,
                ),
                forFourm(height, width),
                SizedBox(
                  height: height * .3,
                ),
                SizedBox(
                  height: height * .06,
                  width: width * .25,
                  child: CommonButton(
                    text: 'Next',
                    onPressed: () {
                      sendPhoneNumber(ref, context);
                    },
                    color: const Color.fromARGB(255, 92, 170, 233),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget forFourm(var height, var width) {
    return SizedBox(
      height: height * .32,
      width: width,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: width * .1,
              ),
              Container(
                  alignment: Alignment.center,
                  height: height * .08,
                  width: width * .8,
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: numberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      labelText: 'Number',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 108, 162, 255),
                      ),
                      hintText: 'Number With Country Code',
                      prefixIcon: const Icon(Icons.phone),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  )),
              SizedBox(
                width: width * .1,
              ),
            ],
          ),
          SizedBox(
            height: height * .03,
          ),
        ],
      ),
    );
  }

  void sendPhoneNumber(WidgetRef ref, BuildContext context) {
    String phoneNumber = numberController.text.trim();
    print(phoneNumber);
    if (phoneNumber.isNotEmpty) {
      ref
          .read(authRepositoryProvider)
          .signInWithPhoneNumber(context: context, phoneNumber: phoneNumber);
    } else {
      showSnackBar(context, 'Please fill field with number');
    }
  }
}
