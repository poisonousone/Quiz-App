import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/choice_card.dart';

enum Current {first, second, third, forth}

class QuizApp extends StatefulWidget {
  List<bool> checkboxValue = [false, false, false, false];
  Current _current;
  @override
  _QuizAppState createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  var firestoreSnapshot = FirebaseFirestore.instance.collection("Quiz").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Quiz"),
        centerTitle: true,
        backgroundColor: Colors.grey.shade900,
      ),
      backgroundColor: Colors.grey.shade800,
      body: StreamBuilder(
          stream: firestoreSnapshot,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return Column(
                    children: [
                      Column(
                        children: [
                          //Here must have been an image
                          Container(
                            height: 150,
                          ),
                          Container(
                              height: 150,
                              width: 500,
                              margin: const EdgeInsets.all(25),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(snapshot.data.documents[0]['question'])
                          ),
                        ]
                      ),
                      Column(
                        children: [
                          _choiceCard(snapshot, 1, 0),
                          Container(
                            color: Colors.grey.shade900,
                            child: ButtonBar(
                              alignment: MainAxisAlignment.spaceEvenly,
                              buttonMinWidth: 160,
                              children: [
                                RaisedButton(
                                  onPressed: () {},
                                  color: Colors.green.shade900,
                                  child: Text("Check"),
                                ),
                                FlatButton(
                                  onPressed: null,
                                  child: Text("Skip"),
                                )
                              ],
                            )
                          )
                        ]
                      )
                    ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            );
          }),
    );
  }

  _choiceCard(AsyncSnapshot<dynamic> snapshot, int type, int questionNumber) {
    switch (type) {
      case 0: {
          return Column(
            children: [
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents[questionNumber]['answers'].length,
                  itemBuilder: (context, int index) {
                    return Row(
                      children: <Widget>[
                        Checkbox(
                            value: widget.checkboxValue[index],
                            onChanged: (newValue) {
                              setState(() {
                                widget.checkboxValue[index] = newValue;
                              });
                            },
                        ),
                        Text(snapshot.data.documents[questionNumber]['answers'][index])
                      ],
                    );
                  }
              ),
            ],
          );
        }
      case 1: {
        return Column(
          children: [
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.documents[questionNumber]['answers'].length,
                itemBuilder: (context, int index) {
                  return Row(
                    children: <Widget>[
                      /*Checkbox(
                        value: widget.checkedValue[index],
                        onChanged: (newValue) {
                          setState(() {
                            widget.checkedValue[index] = newValue;
                          });
                        },
                      ), */
                      Radio(
                          value: Current.values[index],
                          groupValue: widget._current,
                          onChanged: (Current newValue) {
                            setState(() {
                              widget._current = newValue;
                            });
                          },
                      ),
                      Text(snapshot.data.documents[questionNumber]['answers'][index])
                    ],
                  );
                }
            ),
          ],
        );
      }
    }
  }
}
