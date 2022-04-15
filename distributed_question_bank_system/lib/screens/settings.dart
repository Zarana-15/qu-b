import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:distributed_question_bank_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();

    TextEditingController email = TextEditingController();
    TextEditingController phone = TextEditingController();
    return Scaffold(
        backgroundColor: ThemeColors().secondaryColor,
        body: SafeArea(
            child: sideBar(
                body: Center(
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                        decoration: BoxDecoration(
                            color: ThemeColors().primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width / 1.6,
                        child: Column(children: [
                          Container(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                              child: Text('Edit Profile',
                                  style: ThemeText().header)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Name:  ", style: ThemeText().common),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: name,
                                    maxLines: 1,
                                    decoration: ThemeText().inputfield("Name"),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Email:  ", style: ThemeText().common),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: email,
                                    maxLines: 1,
                                    decoration: ThemeText().inputfield("Email"),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Phone:  ", style: ThemeText().common),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: TextFormField(
                                    controller: phone,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    maxLines: 1,
                                    decoration: ThemeText().inputfield("Phone"),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ThemeColors().secondaryButtoncolor),
                              ),
                              onPressed: () async {
                                editProfile(
                                    context: context,
                                    email: email,
                                    name: name,
                                    phone: phone);
                              },
                              child: Text(
                                'Edit',
                                style: ThemeText().common,
                              ),
                            ),
                          )
                        ]))),
                index: 4,
                context: context)));
  }

  Future<void> editProfile(
      {BuildContext? context,
      TextEditingController? email,
      TextEditingController? name,
      TextEditingController? phone}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var token = pref.getString('token');
      //print(token);
      var url = Uri.parse(baseURL + '/EditProfile');

      var response = await http.post(url,
          body: json.encode({
            'token': token,
            'email': email!.text.trim(),
            'name': name!.text.trim(),
            'phone': phone!.text.trim()
          }),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        var jsonresp = json.decode(response.body);
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('token', jsonresp['token']);
        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
          content: Text(jsonresp['Message']),
        ));
      } else {
        var jsonresp = json.decode(response.body);
        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
          content: Text(jsonresp['Message']),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(
        content: Text("Failed to make request. Try Again"),
      ));
    }
  }
}
