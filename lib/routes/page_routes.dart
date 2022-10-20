import 'package:chatting_app/screens/login_page.dart';
import 'package:chatting_app/screens/main_chatiing_page.dart';
import 'package:chatting_app/screens/search_contact_list.dart';
import 'package:chatting_app/screens/splash_page.dart';
import 'package:chatting_app/screens/term_page.dart';
import 'package:chatting_app/screens/user_information_page.dart';
import 'package:chatting_app/screens/verification_code_page.dart';
import 'package:flutter/material.dart';

import '../screens/chat_page.dart';
import '../screens/contacts_list_page.dart';

class PageRoutes {
  static Route pageRoute(RouteSettings settings) {
    if (settings.name == SplashPage.pageName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return const SplashPage();
        },
      );
    } else if (settings.name == TermPage.pageName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return const TermPage();
        },
      );
    } else if (settings.name == VerificationPage.pageName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return const VerificationPage();
        },
      );
    } else if (settings.name == MainChattingPage.pageName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return const MainChattingPage();
        },
      );
    } else if (settings.name == UserInformationPage.pageName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return const UserInformationPage();
        },
      );
    } else if (settings.name == ContactListPage.pageName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return const ContactListPage();
        },
      );
    } else if (settings.name == ChattingPage.pageName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return const ChattingPage();
        },
      );
    } else if (settings.name == SelectContactScreen.pageName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return const SelectContactScreen();
        },
      );
    } else {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return LoginPage();
        },
      );
    }
  }
}
