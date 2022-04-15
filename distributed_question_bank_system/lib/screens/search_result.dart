import 'package:distributed_question_bank_system/config/quest_card.dart';
import 'package:distributed_question_bank_system/constants.dart';
import 'package:distributed_question_bank_system/models/docs_creator.dart';
import 'package:distributed_question_bank_system/models/questions.dart';
import 'package:flutter/material.dart';

class SearchResult extends StatefulWidget {
  final List<Questions> data;
  const SearchResult({Key? key, required this.data}) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  var scr = ScrollController();
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
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          decoration: BoxDecoration(
                              color: ThemeColors().primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          width: MediaQuery.of(context).size.width / 1.6,
                          child: Stack(alignment: Alignment.center, children: [
                            Align(
                              alignment: const Alignment(-0.9, 0),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 35,
                                  )),
                            ),
                            Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Text('Search Results',
                                    style: ThemeText().header)),
                          ])),
                      Container(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        width: MediaQuery.of(context).size.width / 1.3,
                        //height: 800,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,

                          itemBuilder: (context, index) {
                            return QuestCard(your_quests: widget.data[index]);
                          },
                          itemCount: widget.data.length, //your_questss.length,
                        ),
                      )
                    ],
                  )),
                ),
                index: 3)));
  }
}
