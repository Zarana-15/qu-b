import 'dart:convert';

import 'package:distributed_question_bank_system/config/quest_card.dart';
import 'package:distributed_question_bank_system/constants.dart';
import 'package:distributed_question_bank_system/models/questions.dart';
import 'package:distributed_question_bank_system/screens/search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? _sub, _type;
  var _marks = TextEditingController();
  var keyword = TextEditingController();
  List _bt = [];
  var scr = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors().secondaryColor,
      body: SafeArea(
        child: sideBar(
            body: SingleChildScrollView(
              controller: scr,
              child: Center(
                  child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                      decoration: BoxDecoration(
                          color: ThemeColors().primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                              child: Text('Search Questions',
                                  style: ThemeText().header)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButton<String>(
                                focusColor: Colors.black,
                                underline: const SizedBox(),
                                value: _type,
                                elevation: 5,
                                style: const TextStyle(color: Colors.black),
                                iconEnabledColor: Colors.black,
                                items: <String>[
                                  'MCQ',
                                  'MCA',
                                  'Theory',
                                  'True or False',
                                  'Fill in The Blanks'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                hint: const Text(
                                  "Type",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    _type = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Text('Types:   ', style: ThemeText().common),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: MultiSelectDialogField(
                                  chipDisplay: MultiSelectChipDisplay(),
                                  buttonIcon: const Icon(Icons.arrow_drop_down),
                                  items: [
                                    'Level 1: Remember',
                                    'Level 2: Understand',
                                    'Level 3: Apply',
                                    'Level 4: Analyze',
                                    'Level 5: Evaluate',
                                    'Level 6: Create'
                                  ].map((e) => MultiSelectItem(e, e)).toList(),
                                  listType: MultiSelectListType.CHIP,
                                  title: const Text("Bloom's Taxonomy"),
                                  buttonText: const Text("Bloom's Taxonomy",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                  selectedColor:
                                      ThemeColors().secondaryButtoncolor,
                                  selectedItemsTextStyle:
                                      const TextStyle(color: Colors.white),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  onConfirm: (values) {
                                    _bt = values.cast();
                                  },
                                ),
                              ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              //   child: Container(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 10, vertical: 0),
                              //     decoration: BoxDecoration(
                              //         color: Colors.white,
                              //         borderRadius: BorderRadius.circular(10)),
                              //     child: DropdownButton<String>(
                              //       focusColor: Colors.black,
                              //       underline: const SizedBox(),
                              //       value: _marks,
                              //       elevation: 5,
                              //       style: const TextStyle(color: Colors.black),
                              //       iconEnabledColor: Colors.black,
                              //       items: <String>[
                              //         '1',
                              //         '2',
                              //         '3',
                              //         '4',
                              //         '5',
                              //         '6',
                              //         '8',
                              //         '10',
                              //         '15',
                              //         '20'
                              //       ].map<DropdownMenuItem<String>>(
                              //           (String value) {
                              //         return DropdownMenuItem<String>(
                              //           value: value,
                              //           child: Text(
                              //             value,
                              //             style: const TextStyle(
                              //                 color: Colors.black),
                              //           ),
                              //         );
                              //       }).toList(),
                              //       hint: const Text(
                              //         "Marks",
                              //         style: TextStyle(
                              //             color: Colors.black,
                              //             fontSize: 14,
                              //             fontWeight: FontWeight.w700),
                              //       ),
                              //       onChanged: (String? value) {
                              //         setState(() {
                              //           _marks = value!;
                              //         });
                              //       },
                              //     ),
                              //   ),
                              // ),

                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width /
                                              4.5),
                                  //width: MediaQuery.of(context).size.width / 5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    focusColor: Colors.black,
                                    underline: const SizedBox(),
                                    value: _sub,
                                    elevation: 5,
                                    style: const TextStyle(color: Colors.black),
                                    iconEnabledColor: Colors.black,
                                    items: subjects
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                    hint: const Text(
                                      "Subject",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _sub = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Keywords:  ',
                                          style: ThemeText().common),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        child: TextFormField(
                                          controller: keyword,
                                          decoration: ThemeText().inputfield(
                                              "Linked List, Data Structure..."),
                                        ),
                                      )
                                    ],
                                  )),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 0, 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Marks:  ',
                                          style: ThemeText().common),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                7,
                                        child: TextFormField(
                                          controller: _marks,
                                          decoration:
                                              ThemeText().inputfield("1 or 2"),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          keyboardType: TextInputType.number,
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ThemeColors().secondaryButtoncolor),
                              ),
                              onPressed: () async {
                                if (_type != null) {
                                  var val = await searchQuestion();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SearchResult(data: val)),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("Please Select Type of Question"),
                                  ));
                                }
                              },
                              child: Text(
                                'Search',
                                style: ThemeText().common,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ),
            index: 3,
            context: context),
      ),
    );
  }

  Future<List<Questions>> searchQuestion() async {
    var type;
    switch (_type) {
      case 'MCQ':
        type = 'MCQ';
        break;
      case 'MCA':
        type = 'MCA';
        break;
      case 'Theory':
        type = 'Theory';
        break;
      case 'True or False':
        type = 'T/F';
        break;
      case 'Fill in The Blanks':
        type = 'FIB';
        break;
    }
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var token = pref.getString('token');
      var keywords = [];
      if (keyword.text.isNotEmpty) {
        keyword.text.split(',').forEach((element) {
          if (element.isNotEmpty) {
            keywords.add(element.trim());
          }
        });
      }
      var url =
          Uri.parse(baseURL + '/Search'); //'https://qu-b.herokuapp.com/Search'
      var response = await http.post(url,
          body: json.encode({
            'token': token,
            'Type': type,
            'searchby': {
              "Subject": (_sub is Null) ? [] : [_sub],
              "Marks": _marks.text.trim(),
              "Bloom’s Taxonomy": _bt,
              "Keywords": keywords
            }
          }),
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
