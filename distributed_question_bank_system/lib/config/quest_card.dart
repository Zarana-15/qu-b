import 'package:distributed_question_bank_system/constants.dart';
import 'package:distributed_question_bank_system/models/questions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestCard extends StatefulWidget {
  final Questions your_quests;
  QuestCard({required this.your_quests});
  @override
  _QuestCardState createState() => _QuestCardState();
}

class _QuestCardState extends State<QuestCard> {
  var checkVal = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      widget.your_quests.question!,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.your_quests.options!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Text(
                              "${index + 1}. " +
                                  widget.your_quests.options![index],
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 6.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.your_quests.answer!.length,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Text(
                              (index == 0)
                                  ? "Answer: " +
                                      widget.your_quests.answer![index]
                                  : widget.your_quests.answer![index],
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        Text(
                          widget.your_quests.tag!.subject!,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo[600],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, right: 10),
                          child: Text(
                            "Marks: " + widget.your_quests.tag!.marks!,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Text(
                          "Keywords: ",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          //width: MediaQuery.of(context).size.width / 2,
                          height: 20,
                          //color: Colors.blue,
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  width: 5,
                                );
                              },
                              shrinkWrap: true,
                              itemCount:
                                  widget.your_quests.tag!.keyword!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Text(
                                  widget.your_quests.tag!.keyword![index],
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Text(
                          "Bloom's Taxonomy: ",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          //width: MediaQuery.of(context).size.width / 2,
                          height: 20,
                          //color: Colors.blue,
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  width: 5,
                                );
                              },
                              shrinkWrap: true,
                              itemCount: widget.your_quests.tag!.bloom!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 2, 5, 0),
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: ThemeColors().secondaryButtoncolor,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Text(
                                    widget.your_quests.tag!.bloom![index],
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: ThemeColors().blockBlue),
                  child: Text(
                    widget.your_quests.type!,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                right: 10,
                child: Checkbox(
                    value: checkVal,
                    onChanged: (val) {
                      setState(() {
                        checkVal = val!;
                      });
                      if (val == true) {
                        if (questIndex.length < 4) {
                          questIndex.add(widget.your_quests);
                        } else {
                          setState(() {
                            checkVal = !val!;
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                "You can add only upto 4 Questions at a time!"),
                          ));
                        }
                      } else {
                        questIndex.remove(widget.your_quests);
                      }
                    }),
              )
            ],
          ),
        ));
  }
}
