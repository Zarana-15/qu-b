import 'package:distributed_question_bank_system/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:distributed_question_bank_system/constants.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var box = await Hive.openBox("isLogin");
  var index = pref.getInt('index');
  if (pref.getString('token') != null) {
    box.put('isLogin', false);
    box.put('index', index);
  } else {
    box.put('isLogin', true);
    box.put('index', index);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: const Wrapper(),
    );
  }
}
