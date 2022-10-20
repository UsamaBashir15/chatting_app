import 'dart:io';

import 'package:chatting_app/Common/errors/error.dart';
import 'package:chatting_app/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Common/utils/utils.dart';

class UserInformationPage extends ConsumerStatefulWidget {
  const UserInformationPage({Key? key}) : super(key: key);
  static String pageName = 'UserInformationPage';
  @override
  ConsumerState<UserInformationPage> createState() =>
      _UserInformationPageState();
}

class _UserInformationPageState extends ConsumerState<UserInformationPage> {
  var nameController = TextEditingController();
  File? image;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 70, 94),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: height * .03,
              ),
              getImageAvatar(height, width),
              forField(height, width)
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageAvatar(height, width) {
    return Stack(
      children: [
        image == null
            ? const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/profile_pic.png'))
            : CircleAvatar(radius: 60, backgroundImage: FileImage(image!)),
        Positioned(
          top: height * .1,
          left: width * .22,
          child: IconButton(
              onPressed: () async {
                image = (await pickImageFromGallery(context));
                setState(() {});
              },
              icon: const Icon(
                Icons.add_a_photo,
                color: Colors.white,
              )),
        )
      ],
    );
  }

  Widget forField(var height, var width) {
    return SizedBox(
      height: height * .32,
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: width * .07,
          ),
          Container(
              alignment: Alignment.center,
              height: height * .08,
              width: width * .77,
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  labelText: 'Name',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 108, 162, 255),
                  ),
                  hintText: 'Enter Your Name',
                  fillColor: Colors.white,
                  filled: true,
                ),
              )),
          SizedBox(
              width: width * .1,
              child: IconButton(
                onPressed: () {
                  saveUserData();
                },
                icon: const Icon(
                  Icons.check,
                  size: 30,
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }

  void saveUserData() {
    var name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref.watch(authRepositoryProvider).saveUserDataInFirebase(
          name: name, profilePicture: image, context: context);
    } else {
      showSnackBar(context, 'Enter Your Name');
    }
  }
}
