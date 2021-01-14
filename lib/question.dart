import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Current { first, second, third, fourth }
String answer;
List<bool> isRight = [null, null, null, null, null];

class QuizApp extends StatefulWidget {
  List<bool> checkboxValue = [false, false, false, false];
  Current _current;
  int questionNumber = 0;
  @override
  _QuizAppState createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  var firestoreSnapshot =
      FirebaseFirestore.instance.collection("Quiz").snapshots();
  final textController = TextEditingController();

  _QuizAppState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Test Quiz",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "OldeEnglish",
                fontSize: 40,
              )),
          centerTitle: true,
          backgroundColor: Colors.grey.shade900,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavigationRoute()));
                  },
                  child: Icon(
                    Icons.menu,
                    size: 26.0,
                  ),
                )),
          ]),
      backgroundColor: Colors.grey.shade800,
      body: StreamBuilder(
          stream: firestoreSnapshot,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return Column(
              children: [
                Column(children: [
                  SizedBox(height: 8),
                  Image.asset(
                    "assets/images/coat_of_arms.png",
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
                      child: Center(
                        child: Text(
                            snapshot.data.documents[widget.questionNumber % 5]
                                ['question'],
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Roboto",
                              fontSize: 20,
                            )),
                      )),
                ]),
                Column(children: [
                  _choiceCard(snapshot, widget.questionNumber % 5),
                  Container(
                      color: Colors.grey.shade900,
                      child: ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        buttonMinWidth: 160,
                        children: [
                          RaisedButton(
                            onPressed: () {
                              switch (_checkAnswer(
                                  snapshot, widget.questionNumber % 5)) {
                                case true:
                                  {
                                    final snackbar = SnackBar(
                                      content: Text("You're right!"),
                                      backgroundColor: Colors.green,
                                      duration: Duration(milliseconds: 800),
                                    );
                                    Scaffold.of(context).showSnackBar(snackbar);
                                    setState(() {
                                      isRight[widget.questionNumber % 5] = true;
                                      widget.questionNumber++;
                                      widget._current = null;
                                      for (int i = 0; i < 4; i++) {
                                        widget.checkboxValue[i] = false;
                                      }
                                      ;
                                      clearTextField();
                                    });
                                    break;
                                  }
                                case false:
                                  {
                                    final snackbar = SnackBar(
                                      content: Text("Wrong"),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(milliseconds: 800),
                                    );
                                    Scaffold.of(context).showSnackBar(snackbar);
                                    setState(() {
                                      isRight[widget.questionNumber % 5] =
                                          false;
                                      widget.questionNumber++;
                                      widget._current = null;
                                      for (int i = 0; i < 4; i++) {
                                        widget.checkboxValue[i] = false;
                                      }
                                      ;
                                      clearTextField();
                                    });
                                    break;
                                  }
                                case null:
                                  {
                                    final snackbar = SnackBar(
                                      content: Text("Type something!"),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(milliseconds: 800),
                                    );
                                    Scaffold.of(context).showSnackBar(snackbar);
                                    break;
                                  }
                              }
                              ;
                            },
                            color: Colors.green.shade900,
                            child: Text(
                              "Check",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                widget.questionNumber++;
                                widget._current = null;
                                for (int i = 0; i < 4; i++) {
                                  widget.checkboxValue[i] = false;
                                }
                                ;
                                clearTextField();
                              });
                            },
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ))
                ])
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            );
          }),
    );
  }

  _choiceCard(AsyncSnapshot<dynamic> snapshot, int questionNumber) {
    int type = snapshot.data.documents[questionNumber]['type'];
    switch (type) {
      case 0:
        {
          return Column(
            children: [
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount:
                      snapshot.data.documents[questionNumber]['answers'].length,
                  itemBuilder: (context, int index) {
                    return Row(
                      children: <Widget>[
                        Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Checkbox(
                              checkColor: Colors.black,
                              activeColor: Colors.white,
                              value: widget.checkboxValue[index],
                              onChanged: (newValue) {
                                setState(() {
                                  widget.checkboxValue[index] = newValue;
                                });
                              },
                            )),
                        Text(
                            snapshot.data.documents[questionNumber]['answers']
                                [index],
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Roboto",
                              fontSize: 15,
                            ))
                      ],
                    );
                  }),
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
                  itemCount:
                      snapshot.data.documents[questionNumber]['answers'].length,
                  itemBuilder: (context, int index) {
                    return Row(
                      children: <Widget>[
                        Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio(
                              focusColor: Colors.white,
                              activeColor: Colors.white,
                              value: Current.values[index],
                              groupValue: widget._current,
                              onChanged: (Current newValue) {
                                setState(() {
                                  widget._current = newValue;
                                });
                              },
                            )),
                        Text(
                            snapshot.data.documents[questionNumber]['answers']
                                [index],
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Roboto",
                              fontSize: 15,
                            ))
                      ],
                    );
                  }),
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
                        Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio(
                              activeColor: Colors.white,
                              value: Current.values[index],
                              groupValue: widget._current,
                              onChanged: (Current newValue) {
                                setState(() {
                                  widget._current = newValue;
                                });
                              },
                            )),
                        Text(
                            snapshot.data.documents[questionNumber]['answers']
                                [index],
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Roboto",
                              fontSize: 15,
                            ))
                      ],
                    );
                  }),
            ],
          );
        }
      case 3:
        {
          return Container(
            child: Column(children: [
              TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: "Enter your answer",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: "Roboto",
                      fontSize: 15,
                    ),
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    )
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Roboto",
                    fontSize: 15,
                  ),
                  onChanged: (value) {
                    setState(() {
                      answer = value;
                    });
                  }),
              Container(
                height: 120,
              )
            ]),
            margin: EdgeInsets.all(10),
          );
        }
    }
  }

  clearTextField() {
    textController.clear();
  }

  bool _checkAnswer(AsyncSnapshot<dynamic> snapshot, int questionNumber) {
    var type = snapshot.data.documents[questionNumber]['type'];
    switch (type) {
      case 0:
        {
          return compareArrays(widget.checkboxValue,
              snapshot.data.documents[questionNumber]['rightAnswer']);
        }
      case 1:
        {
          return (widget._current.toString().toLowerCase() ==
              snapshot.data.documents[questionNumber]['rightAnswer']);
        }
      case 2:
        {
          return (widget._current.toString().toLowerCase() ==
              snapshot.data.documents[questionNumber]['rightAnswer']);
        }
      case 3:
        {
          if (!(answer == null))
            return (answer
                    .replaceAll(new RegExp(r'[^\w\s]+'), '')
                    .toLowerCase()
                    .replaceAll(new RegExp(r' '), '') ==
                snapshot.data.documents[questionNumber]['rightAnswer']
                    .replaceAll(new RegExp(r'[^\w\s]+'), '')
                    .toLowerCase()
                    .replaceAll(new RegExp(r' '), ''));
          return null;
        }
      default:
        return true;
    }
  }

  bool compareArrays(List first, List second) {
    for (int i = 0; i < first.length; i++) {
      if (first[i] != second[i]) return false;
    }
    ;
    return true;
  }
}

class NavigationRoute extends StatefulWidget {
  @override
  _NavigationRouteState createState() => _NavigationRouteState();
}

class _NavigationRouteState extends State<NavigationRoute> {
  var navSnapshot = FirebaseFirestore.instance.collection("Quiz").snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Question List",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "OldeEnglish",
            fontSize: 40,
          ),
        ),
        backgroundColor: Colors.grey.shade900,
      ),
      body: StreamBuilder(
        stream: navSnapshot,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, int index) {
              return Container(
                child: Row(
                  children: [
                    Text(snapshot.data.documents[index]['quote'],
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto",
                          fontSize: 15,
                        )),
                    Icon(_iconButton(isRight, index), color: Colors.white)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.grey.shade800,
    );
  }

  _iconButton(List<bool> answers, int index) {
    switch (answers[index]) {
      case null:
        {
          return Icons.check_box_outline_blank_outlined;
        }
      case true:
        {
          return Icons.check;
        }
      case false:
        {
          return Icons.clear_rounded;
        }
      default:
        return Icons.check_box_outline_blank_outlined;
    }
  }
}
