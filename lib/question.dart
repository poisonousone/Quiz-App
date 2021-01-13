import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizApp extends StatefulWidget {
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
            return ListView(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(snapshot.data.documents[0]['question'])
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents[0]['answers'].length,
                    itemBuilder: (context, int index) {
                      return Text(snapshot.data.documents[0]['answers'][index]);
                    })
              ]
            );
          }),
    );
  }
}
