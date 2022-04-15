import 'dart:convert';

import 'package:distributed_question_bank_system/constants.dart';
import 'package:distributed_question_bank_system/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:distributed_question_bank_system/config/pallette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isSignupScreen = false;
  bool isMale = true;
  bool isRememberMe = false;

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallette.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/black1.png"),
                      fit: BoxFit.fill)),
              child: Container(
                padding: const EdgeInsets.only(top: 80, left: 20),
                color: Colors.black.withOpacity(0.9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: isSignupScreen
                                ? "\n\nWelcome"
                                : "\n\nWelcome Back",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.purple[500],
                            ),
                          )
                        ],
                        text:
                            "Distributed Question Bank Management System: Qu-B ",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.purple[200],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      isSignupScreen
                          ? "Signup to Continue"
                          : "Login to Continue",
                      style: const TextStyle(
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Trick to add the shadow for the submit button
          buildBottomHalfContainer(true),
          //Main Contianer for Login and Signup
          AnimatedPositioned(
            duration: const Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            top: isSignupScreen ? 200 : 230,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              height: isSignupScreen ? 380 : 250,
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black45.withOpacity(0.9),
                        blurRadius: 15,
                        spreadRadius: 3),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isSignupScreen
                                        ? Colors.purple[300]
                                        : Pallette.textColor1),
                              ),
                              if (!isSignupScreen)
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Colors.purple[200],
                                )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "SIGNUP",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? Colors.purple[300]
                                        : Pallette.textColor1),
                              ),
                              if (isSignupScreen)
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Colors.purple[200],
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                    if (isSignupScreen) buildSignupSection(),
                    if (!isSignupScreen) buildSigninSection()
                  ],
                ),
              ),
            ),
          ),
          // Trick to add the submit button
          buildBottomHalfContainer(false),
          // Bottom buttons
        ],
      ),
    );
  }

  Container buildSigninSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextField(
              Icons.mail_outline, "test@email.com", false, true, email),
          buildTextField(Icons.lock_outline, "**********", true, false, pass),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Row(
          //       children: [
          //         Checkbox(
          //           value: isRememberMe,
          //           activeColor: Pallette.textColor2,
          //           onChanged: (value) {
          //             setState(() {
          //               isRememberMe = !isRememberMe;
          //             });
          //           },
          //         ),
          //         const Text("Remember me",
          //             style:
          //                 TextStyle(fontSize: 12, color: Pallette.textColor1))
          //       ],
          //     ),
          //     TextButton(
          //       onPressed: () {},
          //       child: const Text("Forgot Password?",
          //           style: TextStyle(fontSize: 12, color: Pallette.textColor1)),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextField(
              Icons.account_circle_outlined, "Name", false, false, name),
          buildTextField(Icons.email_rounded, "email", false, true, email),
          buildTextField(Icons.lock_outline, "password", true, false, pass),
          buildTextField(Icons.phone, "Contact Number", false, false, phone),
          // Padding(
          //   padding: const EdgeInsets.only(top: 10, left: 10),
          //   child: Row(
          //     children: [
          //       GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             isMale = true;
          //           });
          //         },
          //         child: Row(
          //           children: [
          //             Container(
          //               width: 30,
          //               height: 30,
          //               margin: const EdgeInsets.only(right: 8),
          //               decoration: BoxDecoration(
          //                   color: isMale
          //                       ? Pallette.textColor2
          //                       : Colors.transparent,
          //                   border: Border.all(
          //                       width: 1,
          //                       color: isMale
          //                           ? Colors.transparent
          //                           : Pallette.textColor1),
          //                   borderRadius: BorderRadius.circular(15)),
          //               child: Icon(
          //                 Icons.account_circle,
          //                 color: isMale ? Colors.white : Pallette.iconColor,
          //               ),
          //             ),
          //             const Text(
          //               "Male",
          //               style: TextStyle(color: Pallette.textColor1),
          //             )
          //           ],
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 30,
          //       ),
          //       GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             isMale = false;
          //           });
          //         },
          //         child: Row(
          //           children: [
          //             Container(
          //               width: 30,
          //               height: 30,
          //               margin: const EdgeInsets.only(right: 8),
          //               decoration: BoxDecoration(
          //                   color: isMale
          //                       ? Colors.transparent
          //                       : Pallette.textColor2,
          //                   border: Border.all(
          //                       width: 1,
          //                       color: isMale
          //                           ? Pallette.textColor1
          //                           : Colors.transparent),
          //                   borderRadius: BorderRadius.circular(15)),
          //               child: Icon(
          //                 Icons.account_circle,
          //                 color: isMale ? Pallette.iconColor : Colors.white,
          //               ),
          //             ),
          //             const Text(
          //               "Female",
          //               style: TextStyle(color: Pallette.textColor1),
          //             )
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          side: const BorderSide(width: 1, color: Colors.grey),
          minimumSize: const Size(145, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignupScreen ? 535 : 430,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                  )
              ]),
          child: !showShadow
              ? InkWell(
                  onTap: () async {
                    isSignupScreen ? register() : login();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.purple[300],
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1))
                        ]),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                )
              : const Center(),
        ),
      ),
    );
  }

  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      bool isEmail, TextEditingController x) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        obscureText: isPassword,
        controller: x,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Pallette.iconColor,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Pallette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Pallette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: const EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: Pallette.textColor1),
        ),
      ),
    );
  }

  void login() async {
    try {
      var url = Uri.parse(baseURL+'/Login');
      var response = await http.post(url,
          body: json.encode(
              {'email': email.text.trim(), 'password': pass.text.trim()}),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        var jsonresp = json.decode(response.body);
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('token', jsonresp['token']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        var jsonresp = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonresp['Message']),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to make request. Try Again"),
      ));
    }
  }

  void register() async {
    try {
      var url = Uri.parse(baseURL+'/Register');
      var response = await http.post(url,
          body: json.encode({
            'name': name.text.trim(),
            'email': email.text.trim(),
            'password': pass.text.trim(),
            'phone': phone.text.trim()
          }),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');
      if (response.statusCode == 201) {
        var jsonresp = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonresp['Message']),
        ));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Signup Successful. You can now login!"),
        ));
      } else {
        var jsonresp = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonresp['Message']),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to make request. Try Again"),
      ));
    }
  }
}
