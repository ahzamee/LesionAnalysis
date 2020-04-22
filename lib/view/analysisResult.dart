import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lesionanalysis/view/homePage.dart';

class AnalysisResult extends StatefulWidget {
  @override
  _AnalysisResultState createState() => _AnalysisResultState();
}

class _AnalysisResultState extends State<AnalysisResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
              margin: const EdgeInsets.only(top: 300.0),
              child: Center(
                child: new Text("Result will show over here.",
                  style: TextStyle(
                      fontFamily: "Alike-Regular",
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: MaterialButton(
                color: Colors.blue,
                height: 50.0,
                minWidth: double.infinity,
                child: new Text("Analysis Again",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontFamily: 'Alike-Regular',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HomePage()
                  ));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
