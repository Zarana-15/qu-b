import 'dart:js';

import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:distributed_question_bank_system/screens/add_quest.dart';
import 'package:distributed_question_bank_system/screens/home_page.dart';
import 'package:distributed_question_bank_system/screens/login.dart';
import 'package:distributed_question_bank_system/screens/search.dart';
import 'package:distributed_question_bank_system/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String title = "Qu-B";

String baseURL = 'https://qu-b.herokuapp.com';

class ThemeColors {
  Color primaryColor = const Color(0xFF28282b);

  Color secondaryColor = const Color(0xFF3b3b41);

  Color secondaryTextcolor = const Color(0xFFa2a5b9);

  Color secondaryButtoncolor = const Color(0xFF797bf2);

  Color blockViolet = const Color(0xFF8269b2);

  Color blockOrange = const Color(0xFFffa981);

  Color blockGreen = const Color(0xFF93e088);

  Color blockBlue = const Color(0xFF039be5);
}

class ThemeText {
  TextStyle header = const TextStyle(
      color: Colors.white, fontSize: 50, fontWeight: FontWeight.w700);

  TextStyle common = const TextStyle(
      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400);

  InputDecoration inputfield(String text) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: text,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}

Widget sideBar(
    {required Widget body, required int index, required BuildContext context}) {
  bool x1, x2, x3, x4, x5;
  x1 = x2 = x3 = x4 = x5 = false;
  switch (index) {
    case 1:
      x1 = true;
      x2 = x3 = x4 = x5 = false;
      break;

    case 2:
      x2 = true;
      x1 = x3 = x4 = x5 = false;
      break;

    case 3:
      x3 = true;
      x1 = x2 = x4 = x5 = false;
      break;

    case 4:
      x4 = true;
      x1 = x2 = x3 = x5 = false;
      break;
    case 5:
      x5 = true;
      x1 = x2 = x3 = x4 = false;
  }
  List<CollapsibleItem> items = [
    CollapsibleItem(
      text: 'Home',
      icon: Icons.home,
      onPressed: () async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setInt('index', 1);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
      isSelected: x1,
    ),
    CollapsibleItem(
        text: 'Add',
        icon: Icons.add,
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setInt('index', 2);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddQuest()),
          );
        },
        isSelected: x2),
    CollapsibleItem(
        text: 'Search',
        icon: Icons.search,
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setInt('index', 3);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Search()),
          );
        },
        isSelected: x3),
    CollapsibleItem(
        text: 'Settings',
        icon: Icons.settings,
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setInt('index', 4);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Setting()),
          );
        },
        isSelected: x4),
    CollapsibleItem(
        text: 'Logout',
        icon: Icons.logout,
        onPressed: () async {
          SharedPreferences prf = await SharedPreferences.getInstance();
          prf.clear();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginSignupScreen()),
              (route) => false);
        },
        isSelected: x5),
  ];

  return CollapsibleSidebar(
    items: items,
    body: body,
    title: title,
    avatarImg: const AssetImage('logo-head.png'),
    borderRadius: 0,
    fitItemsToBottom: true,
    backgroundColor: ThemeColors().primaryColor,
    sidebarBoxShadow: const [
      BoxShadow(
        color: Colors.transparent,
        blurRadius: 10,
        spreadRadius: 0.01,
        offset: Offset(3, 3),
      ),
    ],
  );
}

List<String> subjects = [
  'Advanced Database Management Systems',
  'Analysis of Algorithms',
  'Artificial Intelligence',
  'C Programming',
  'Computer Graphics',
  'Computer Networks',
  'Cryptography and System Security',
  'Data Structures',
  'Data Warehousing and Mining',
  'Database Management Systems',
  'Digital Logic & Computer Organization and Architecture',
  'Digital Signal and Image Processing',
  'Engineering Chemistry - 1',
  'Engineering Chemistry - 2',
  'Engineering Graphics',
  'Engineering Mathematics - 1',
  'Engineering Mathematics - 2',
  'Engineering Mathematics - 3',
  'Engineering Mathematics - 4',
  'Engineering Mechanics',
  'Engineering Physics - 1',
  'Engineering Physics - 2',
  'Internet of Things',
  'Internet Programming',
  'Java Programming',
  'Machine Learning',
  'Microprocessor',
  'Mobile Computing',
  'Operating System',
  'Probabilistic Graphical Models',
  'Professional Communication & Ethics - 1',
  'Professional Communication & Ethics - 2',
  'Python Programming',
  'Quantitative Analysis',
  'Software Engineering',
  'System Programming and Compiler Construction',
  'Theory of Computer Science'
];

List questIndex = [];
