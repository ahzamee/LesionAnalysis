import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lesionanalysis/view/quizionairePage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  String userName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: new AppBar(title: new Text("Home"),),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(accountName: new Text(userName),
              accountEmail: null,
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.black38,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset("images/userIcon.png",fit: BoxFit.fill,width: 50.0,),
                ),
              ),
              decoration: new BoxDecoration(color: Colors.green),
            ),
            new ListTile(
              title: new Text("User information"),
              trailing: new Icon(Icons.arrow_forward),
              onTap: (){},
            ),
            new ListTile(
              title: new Text("Edit information"),
              trailing: new Icon(Icons.arrow_forward),
              onTap: (){},
            ),
            new ListTile(
              title: new Text("Notification"),
              trailing: new Icon(Icons.arrow_forward),
              onTap: (){},
            ),
            new ListTile(
              title: new Text("Close"),
              trailing: new Icon(Icons.close),
              onTap: (){Navigator.pop(context);},
            ),
          ],
        ),
      ),
      body: new Column(
        children: <Widget>[
          new Padding(padding: const EdgeInsets.all(30.0),
          child: new Text("Tap the start button to answer some questions, which will help us to analyse your lesion.",
            style: new TextStyle(
              fontSize: 20.0,
              fontFamily: 'Alike-Regular'
            ),
          ),),
          new Padding(padding: const EdgeInsets.all(30.0),
            child: new Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: Image.asset("images/homePage.png"),
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: MaterialButton(
                color: Colors.blue,
                height: 50.0,
                minWidth: double.infinity,
                child: new Text("Start Now",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontFamily: 'Alike-Regular',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => QuestionPage()
                  ));
                },
              ),
            ),
          )
        ],
      ),);
  }
}