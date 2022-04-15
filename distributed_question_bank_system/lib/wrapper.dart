//import 'package:distributed_question_bank_system/screens/add_quest.dart';
import 'package:distributed_question_bank_system/screens/add_quest.dart';
import 'package:distributed_question_bank_system/screens/home_page.dart';
import 'package:distributed_question_bank_system/screens/login.dart';
import 'package:distributed_question_bank_system/screens/search.dart';
import 'package:distributed_question_bank_system/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('isLogin');
    var index = box.get('index');

    if (box.get('isLogin')) {
      return const LoginSignupScreen();
    } else if (index == 1) {
      return const HomePage();
    } else if (index == 2) {
      return const AddQuest();
    } else if (index == 3) {
      return const Search();
    } else if (index == 4) {
      return const Setting();
    } else {
      return const HomePage();
    }
  }
}
