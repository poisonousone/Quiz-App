import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _showQuestionScreen();
                },
                child: Icon(
                  Icons.menu,
                  size: 26.0,
                ),
              )
          ),
        ]
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
                          SizedBox(height: 150,),
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
                          _choiceCard(snapshot, 3, 0),
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
      case 0:
        {
          return Column(
            children: [
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents[questionNumber]['answers']
                      .length,
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
                        Text(snapshot.data
                            .documents[questionNumber]['answers'][index])
                      ],
                    );
                  }
              ),
            ],
          );
        }
      case 1:
        {
          return Column(
            children: [
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents[questionNumber]['answers']
                      .length,
                  itemBuilder: (context, int index) {
                    return Row(
                      children: <Widget>[
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
      case 2:
        {
          return Column(
            children: [
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, int index) {
                    return Row(
                      children: <Widget>[
                        Radio(
                          value: Current.values[index],
                          groupValue: widget._current,
                          onChanged: (Current newValue) {
                            setState(() {
                              widget._current = newValue;
                            });
                          },
                        ),
                        Text(snapshot.data
                            .documents[questionNumber]['answers'][index])
                      ],
                    );
                  }
              ),
            ],
          );
        }
      case 3:
        {
          return Container(
            child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Enter your answer",
                      contentPadding: EdgeInsets.all(8),

                    ),
                  ),
                  Container(
                    height: 120,
                  )
                ]
            ),
            margin: EdgeInsets.all(10),
          );
        }
    }
  }

  _showQuestionScreen() {
    return NavigationRoute();
  }
}

class NavigationRoute extends StatefulWidget {
  @override
  _NavigationRouteState createState() => _NavigationRouteState();
}

class _NavigationRouteState extends State<NavigationRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Quiz"),
        backgroundColor: Colors.grey.shade900,
      )
    );
  }
}

