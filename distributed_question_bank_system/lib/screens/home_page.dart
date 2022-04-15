import 'dart:convert';
import 'package:distributed_question_bank_system/config/quest_card.dart';
import 'package:distributed_question_bank_system/constants.dart';
import 'package:distributed_question_bank_system/models/docs_creator.dart';
import 'package:distributed_question_bank_system/models/questions.dart';
import 'package:flutter/material.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scr = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColors().secondaryColor,
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () {
              if (questIndex.isNotEmpty) {
                saveTopdf();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Please Select Questions First!'),
                ));
              }
            }),
        body: SafeArea(
            child: sideBar(
                context: context,
                body: SingleChildScrollView(
                  controller: scr,
                  child: Center(
                      child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                          decoration: BoxDecoration(
                              color: ThemeColors().primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          width: MediaQuery.of(context).size.width / 1.6,
                          child: Column(children: [
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Text('Your Questions',
                                    style: ThemeText().header)),
                          ])),
                      FutureBuilder<List<Questions>>(
                          future: getUserQuestion(),
                          builder:
                              (context, AsyncSnapshot<List<Questions>> sc) {
                            if (sc.hasData) {
                              var data = sc.data!;
                              return Container(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                width: MediaQuery.of(context).size.width / 1.3,
                                //height: 800,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,

                                  itemBuilder: (context, index) {
                                    return QuestCard(your_quests: data[index]);
                                  },
                                  itemCount: data.length, //your_questss.length,
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          })
                    ],
                  )),
                ),
                index: 1)));
  }

  Future<List<Questions>> getUserQuestion() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var token = pref.getString('token');
      var url = Uri.parse(baseURL+'/UserQuestions');
      var response = await http.post(url,
          body: json.encode({'token': token}),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      print('Response status: ${response.statusCode}');
      //print(jsonDecode(response.body)['data']);
      if (response.statusCode == 200) {
        //final zson = jsonDecode(response.body); //.cast<Map<String, dynamic>>();
        return (json.decode(response.body) as List)
            .map<Questions>((i) => Questions.fromJson(i))
            .toList();
      } else {
        var jsonresp = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonresp['Message']),
        ));
        return <Questions>[];
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to make request. Try Again"),
      ));
      return <Questions>[];
    }
  }
}
