import 'package:chatting_app/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerificationPage extends ConsumerWidget {
  const VerificationPage({Key? key}) : super(key: key);
  static String pageName = 'VerificationPage';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var verificationId = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 40, 70, 94),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 40, 70, 94),
          centerTitle: true,
          title: const Text('Verify your phone number'),
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
                    'We have sent an sms with code.',
                    style: TextStyle(height: 1.3, color: Colors.white
                        // color: Color.fromARGB(255, 92, 170, 233),
                        ),
                  ),
                ),
                SizedBox(
                  height: height * .1,
                ),
                forFourm(height, width, ref, context, verificationId),
                SizedBox(
                  height: height * .3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget forFourm(
      var height, var width, WidgetRef ref, context, verificationId) {
    return SizedBox(
      height: height * .32,
      width: width,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: width * .3,
              ),
              Container(
                  alignment: Alignment.center,
                  height: height * .08,
                  width: width * .4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      if (val.length == 6) {
                        ref.read(authRepositoryProvider).verifyOTP(
                            context: context,
                            verificationId: verificationId,
                            userOTP: val);
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: '-  -  -  -  -   -',
                      hintStyle: const TextStyle(fontSize: 25),
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
}
