import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:distributed_question_bank_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddQuest extends StatefulWidget {
  const AddQuest({Key? key}) : super(key: key);

  @override
  _AddQuestState createState() => _AddQuestState();
}

class _AddQuestState extends State<AddQuest> {
  String? _chosenValue, _chosenSub, _chosenans;
  TextEditingController quest = TextEditingController();
  TextEditingController ans = TextEditingController();
  TextEditingController marks = TextEditingController();
  TextEditingController keyword = TextEditingController();
  ScrollController scr = ScrollController();

//mcq

  List<Widget> _children = [];
  int _count = 0;
  // ignore: prefer_final_fields
  List<TextEditingController> _controller = [];
  // ignore: unused_field
  List<Object?> _selectedBloom = [];
  // ignore: unused_field
  List<Object?> _selectedAnswers = [];
  List<String> options = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors().secondaryColor,
      body: SafeArea(
        child: sideBar(
            context: context,
            body: SingleChildScrollView(
              controller: scr,
              child: Center(
                  child: Container(
                margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                decoration: BoxDecoration(
                    color: ThemeColors().primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width / 1.6,
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                        child: Text('Add Question', style: ThemeText().header)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Types:   ', style: ThemeText().common),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton<String>(
                            focusColor: Colors.black,
                            underline: const SizedBox(),
                            value: _chosenValue,
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
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            hint: const Text(
                              "Select Type of Question",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                _chosenValue = value!;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    if (_chosenValue == 'MCQ')
                      Column(children: mcqs(context: context))
                    else if (_chosenValue == 'MCA')
                      Column(children: mcas(context: context))
                    else if (_chosenValue == 'True or False')
                      Column(children: tof(context: context))
                    else if (_chosenValue == 'Theory')
                      Column(children: theory(context: context))
                    else if (_chosenValue == 'Fill in The Blanks')
                      Column(children: fib(context: context))
                    else
                      Container()
                  ],
                ),
              )),
            ),
            index: 2),
      ),
    );
  }

//MCQS type

  List<Widget> mcqs({required BuildContext context}) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Question:  ", style: ThemeText().common),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.8,
              child: TextFormField(
                controller: quest,
                maxLines: 5,
                decoration: ThemeText().inputfield("What is ....?"),
              ),
            )
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Options:  ", style: ThemeText().common),
          IconButton(
              onPressed: () {
                _controller.add(TextEditingController());
                _children = List.from(_children)
                  ..add(Container(
                      padding: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width / 4,
                      child: TextFormField(
                        onChanged: (v) {
                          options.clear();
                          setState(() {
                            for (var element in _controller) {
                              options.add(element.text);
                            }
                          });
                        },
                        decoration: ThemeText().inputfield("Option : $_count"),
                        controller: _controller[_count],
                      )));
                setState(() => ++_count);
              },
              icon: Icon(Icons.add_box,
                  color: ThemeColors().secondaryButtoncolor)),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _children +
                  [
                    IconButton(
                        onPressed: () {
                          if (_count > 0) {
                            setState(() {
                              _children.removeLast();
                              if (options.isNotEmpty) {
                                options.removeLast();
                              }
                              --_count;
                              _controller.removeLast();
                            });
                          }
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: ThemeColors().secondaryButtoncolor,
                        ))
                  ])
        ],
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Answer:  ',
                style: ThemeText().common,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  focusColor: Colors.black,
                  underline: const SizedBox(),
                  value: _chosenans,
                  elevation: 5,
                  style: const TextStyle(color: Colors.black),
                  iconEnabledColor: Colors.black,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: const Text(
                    "Select Answer",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _chosenans = value!;
                    });
                  },
                ),
              )
            ],
          )),
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Text(
          "Tags",
          style: TextStyle(
              color: Colors.white, fontSize: 34, fontWeight: FontWeight.w500),
        ),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Subject:   ', style: ThemeText().common),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  focusColor: Colors.black,
                  underline: const SizedBox(),
                  value: _chosenSub,
                  elevation: 5,
                  style: const TextStyle(color: Colors.black),
                  iconEnabledColor: Colors.black,
                  items: subjects.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: const Text(
                    "Select Subject",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _chosenSub = value;
                    });
                  },
                ),
              ),
            ],
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Keywords:  ', style: ThemeText().common),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: TextFormField(
                  controller: keyword,
                  decoration:
                      ThemeText().inputfield("Linked List, Data Structure..."),
                ),
              )
            ],
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Marks:  ', style: ThemeText().common),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: TextFormField(
                  controller: marks,
                  decoration: ThemeText().inputfield("1 or 2"),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                ),
              )
            ],
          )),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bloom's Taxonomy:   ",
              style: ThemeText().common,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 5,
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
                title: const Text("Select Bloom's Level"),
                selectedColor: ThemeColors().secondaryButtoncolor,
                selectedItemsTextStyle: const TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                onConfirm: (values) {
                  _selectedBloom = values.cast();
                },
              ),
            ),
          ],
        ),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 50),
          child: ElevatedButton(
              onPressed: () {
                addquest();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      ThemeColors().secondaryButtoncolor),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(20, 15, 20, 15))),
              child: Text(
                'Submit',
                style: ThemeText().common,
              ))),
    ];
  }

//MCAS type

  List<Widget> mcas({
    required BuildContext context,
  }) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Question:  ", style: ThemeText().common),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.8,
              child: TextFormField(
                controller: quest,
                maxLines: 5,
                decoration: ThemeText().inputfield("What is ....?"),
              ),
            )
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Options:  ", style: ThemeText().common),
          IconButton(
              onPressed: () {
                _controller.add(TextEditingController());
                _children = List.from(_children)
                  ..add(Container(
                      padding: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width / 4,
                      child: TextFormField(
                        onChanged: (v) {
                          options.clear();
                          setState(() {
                            for (var element in _controller) {
                              options.add(element.text);
                            }
                          });
                        },
                        decoration: ThemeText().inputfield("Option : $_count"),
                        controller: _controller[_count],
                      )));
                setState(() => ++_count);
              },
              icon: Icon(Icons.add_box,
                  color: ThemeColors().secondaryButtoncolor)),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _children +
                  [
                    IconButton(
                        onPressed: () {
                          if (_count > 0) {
                            setState(() {
                              _children.removeLast();
                              if (options.isNotEmpty) {
                                options.removeLast();
                              }
                              --_count;
                              _controller.removeLast();
                            });
                          }
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: ThemeColors().secondaryButtoncolor,
                        ))
                  ])
        ],
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Answer:  ',
                style: ThemeText().common,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 5,
                child: MultiSelectDialogField(
                  chipDisplay: MultiSelectChipDisplay(),
                  buttonIcon: const Icon(Icons.arrow_drop_down),
                  items: options.map((e) => MultiSelectItem(e, e)).toList(),
                  listType: MultiSelectListType.CHIP,
                  title: const Text("Select Answers"),
                  selectedColor: ThemeColors().secondaryButtoncolor,
                  selectedItemsTextStyle: const TextStyle(color: Colors.white),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  onConfirm: (values) {
                    _selectedAnswers = values.cast();
                  },
                ),
              ),
            ],
          )),
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Text(
          "Tags",
          style: TextStyle(
              color: Colors.white, fontSize: 34, fontWeight: FontWeight.w500),
        ),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Subject:   ', style: ThemeText().common),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  focusColor: Colors.black,
                  underline: const SizedBox(),
                  value: _chosenSub,
                  elevation: 5,
                  style: const TextStyle(color: Colors.black),
                  iconEnabledColor: Colors.black,
                  items: subjects.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: const Text(
                    "Select Subject",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _chosenSub = value;
                    });
                  },
                ),
              ),
            ],
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Keywords:  ', style: ThemeText().common),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: TextFormField(
                  controller: keyword,
                  decoration:
                      ThemeText().inputfield("Linked List, Data Structure..."),
                ),
              )
            ],
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Marks:  ', style: ThemeText().common),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: TextFormField(
                  controller: marks,
                  decoration: ThemeText().inputfield("1 or 2"),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                ),
              )
            ],
          )),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bloom's Taxonomy:   ",
              style: ThemeText().common,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 5,
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
                title: const Text("Select Bloom's Level"),
                selectedColor: ThemeColors().secondaryButtoncolor,
                selectedItemsTextStyle: const TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                onConfirm: (values) {
                  _selectedBloom = values.cast();
                },
              ),
            ),
          ],
        ),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 50),
          child: ElevatedButton(
              onPressed: () {
                addquest();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      ThemeColors().secondaryButtoncolor),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(20, 15, 20, 15))),
              child: Text(
                'Submit',
                style: ThemeText().common,
              ))),
    ];
  }

//Tof type

  List<Widget> tof({required BuildContext context}) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Question:  ", style: ThemeText().common),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.8,
              child: TextFormField(
                controller: quest,
                maxLines: 5,
                decoration: ThemeText().inputfield("What is ....?"),
              ),
            )
          ],
        ),
      ),
      Text("Note: Options Will be True or False ", style: ThemeText().common),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Answer:  ',
                style: ThemeText().common,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  focusColor: Colors.black,
                  underline: const SizedBox(),
                  value: _chosenans,
                  elevation: 5,
                  style: const TextStyle(color: Colors.black),
                  iconEnabledColor: Colors.black,
                  items: <String>['True', 'False']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: const Text(
                    "Select Answer",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _chosenans = value!;
                    });
                  },
                ),
              )
            ],
          )),
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Text(
          "Tags",
          style: TextStyle(
              color: Colors.white, fontSize: 34, fontWeight: FontWeight.w500),
        ),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Subject:   ', style: ThemeText().common),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  focusColor: Colors.black,
                  underline: const SizedBox(),
                  value: _chosenSub,
                  elevation: 5,
                  style: const TextStyle(color: Colors.black),
                  iconEnabledColor: Colors.black,
                  items: subjects.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: const Text(
                    "Select Subject",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _chosenSub = value;
                    });
                  },
                ),
              ),
            ],
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Keywords:  ', style: ThemeText().common),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: TextFormField(
                  controller: keyword,
                  decoration:
                      ThemeText().inputfield("Linked List, Data Structure..."),
                ),
              )
            ],
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Marks:  ', style: ThemeText().common),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: TextFormField(
                  controller: marks,
                  decoration: ThemeText().inputfield("1 or 2"),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                ),
              )
            ],
          )),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bloom's Taxonomy:   ",
              style: ThemeText().common,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 5,
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
                title: const Text("Select Bloom's Level"),
                selectedColor: ThemeColors().secondaryButtoncolor,
                selectedItemsTextStyle: const TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                onConfirm: (values) {
                  _selectedBloom = values.cast();
                },
              ),
            ),
          ],
        ),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 50),
          child: ElevatedButton(
              onPressed: () {
                addquest();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      ThemeColors().secondaryButtoncolor),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(20, 15, 20, 15))),
              child: Text(
                'Submit',
                style: ThemeText().common,
              ))),
    ];
  }

//theory type

  List<Widget> theory({required BuildContext context}) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Question:  ", style: ThemeText().common),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: TextFormField(
                controller: quest,
                maxLines: 6,
                decoration: ThemeText().inputfield("What is ....?"),
              ),
            )
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Text(
          "Tags",
          style: TextStyle(
              color: Colors.white, fontSize: 34, fontWeight: FontWeight.w500),
        ),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Subject:   ', style: ThemeText().common),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  focusColor: Colors.black,
                  underline: const SizedBox(),
                  value: _chosenSub,
                  elevation: 5,
                  style: const TextStyle(color: Colors.black),
                  iconEnabledColor: Colors.black,
                  items: subjects.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: const Text(
                    "Select Subject",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _chosenSub = value;
                    });
                  },
                ),
              ),
            ],
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Keywords:  ', style: ThemeText().common),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: TextFormField(
                  controller: keyword,
                  decoration:
                      ThemeText().inputfield("Linked List, Data Structure..."),
                ),
              )
            ],
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Marks:  ', style: ThemeText().common),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: TextFormField(
                  controller: marks,
                  decoration: ThemeText().inputfield("1 or 2"),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                ),
              )
            ],
          )),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bloom's Taxonomy:   ",
              style: ThemeText().common,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 5,
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
                title: const Text("Select Bloom's Level"),
                selectedColor: ThemeColors().secondaryButtoncolor,
                selectedItemsTextStyle: const TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                onConfirm: (values) {
                  _selectedBloom = values.cast();
                },
              ),
            ),
          ],
        ),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 50),
          child: ElevatedButton(
              onPressed: () {
                addquest();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      ThemeColors().secondaryButtoncolor),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(20, 15, 20, 15))),
              child: Text(
                'Submit',
                style: ThemeText().common,
              ))),
    ];
  }

//fill in the blanks

  List<Widget> fib({required BuildContext context}) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Question:  ", style: ThemeText().common),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.8,
              child: TextFormField(
                controller: quest,
                maxLines: 5,
                decoration: ThemeText().inputfield("What is ....?"),
              ),
            )
          ],
        ),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Answer:  ',
                style: ThemeText().common,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.8,
                child: TextFormField(
                  controller: ans,
                  decoration: ThemeText().inputfield("Answer"),
                ),
              )
            ],
          )),
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Text(
          "Tags",
          style: TextStyle(
              color: Colors.white, fontSize: 34, fontWeight: FontWeight.w500),
        ),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Subject:   ', style: ThemeText().common),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  focusColor: Colors.black,
                  underline: const SizedBox(),
                  value: _chosenSub,
                  elevation: 5,
                  style: const TextStyle(color: Colors.black),
                  iconEnabledColor: Colors.black,
                  items: subjects.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: const Text(
                    "Select Subject",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _chosenSub = value;
                    });
                  },
                ),
              ),
            ],
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Keywords:  ', style: ThemeText().common),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: TextFormField(
                  controller: keyword,
                  decoration:
                      ThemeText().inputfield("Linked List, Data Structure..."),
                ),
              )
            ],
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Marks:  ', style: ThemeText().common),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: TextFormField(
                  controller: marks,
                  decoration: ThemeText().inputfield("1 or 2"),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                ),
              )
            ],
          )),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bloom's Taxonomy:   ",
              style: ThemeText().common,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 5,
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
                title: const Text("Select Bloom's Level"),
                selectedColor: ThemeColors().secondaryButtoncolor,
                selectedItemsTextStyle: const TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                onConfirm: (values) {
                  _selectedBloom = values.cast();
                },
              ),
            ),
          ],
        ),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 50),
          child: ElevatedButton(
              onPressed: () {
                addquest();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      ThemeColors().secondaryButtoncolor),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(20, 15, 20, 15))),
              child: Text(
                'Submit',
                style: ThemeText().common,
              ))),
    ];
  }

  addquest() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var token = pref.getString('token');
      //print(token);
      var url = Uri.parse(baseURL+'/Add');
      var answer;
      var type;
      var keywords = [];
      keyword.text.split(',').forEach((element) {
        keywords.add(element.trim());
      });
      switch (_chosenValue) {
        case 'MCQ':
          answer = _chosenans;
          type = 'MCQ';
          break;
        case 'MCA':
          answer = _selectedAnswers.cast<String>();
          type = 'MCA';
          break;
        case 'Theory':
          answer = '';
          type = 'Theory';
          break;
        case 'True or False':
          answer = _chosenans;
          type = 'T/F';
          break;
        case 'Fill in The Blanks':
          answer = ans.text.trim();
          type = 'FIB';
          break;
      }
      var response = await http.post(url,
          body: json.encode({
            'token': token,
            'Type': type,
            'Question': quest.text.trim(),
            'ImageQuestion': '',
            'Options': options,
            'Answers': answer,
            "Subject": _chosenSub,
            "Marks": marks.text.trim(),
            "Keywords": keywords,
            "Bloom’s Taxonomy": _selectedBloom.cast<String>()
          }),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        var jsonresp = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonresp['Message']),
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
