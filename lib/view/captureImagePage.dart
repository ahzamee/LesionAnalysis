import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'analysisResult.dart';

class CaptureImagePage extends StatefulWidget {
  int marks;

  CaptureImagePage({Key key, @required this.marks}) : super(key: key);

  @override
  CaptureImagePageState createState() => CaptureImagePageState(marks);
}

class CaptureImagePageState extends State<CaptureImagePage> {
  File _image;
  String _retrieveDataError;
  ProgressDialog progressDialog;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  String message;
  String image;

  @override
  void initState() {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    super.initState();
  }

  int marks;

  CaptureImagePageState(this.marks);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Image of Affected Area",
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Material(
              //elevation: 5.0,
              child: Container(
                  child: Column(children: <Widget>[
                choiceButton(),
                ShowImage(),
              ])),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: MaterialButton(
                color: Colors.blue,
                height: 50.0,
                minWidth: double.infinity,
                child: new Text("Continue",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontFamily: 'Alike-Regular',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                  onPressed: (){
                    /*Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => QuestionPage()
                    ));*/
                    _onLoading();
                  },
                ),
            ),
          )
        ],
      ),
    );
  }

  Widget choiceButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 100, 20, 10),
      child: MaterialButton(
        onPressed: () {
          getImage();
        },
        child: Text(
          "Take a picture",
          style: TextStyle(
            fontFamily: "Alike",
            fontSize: 20.0,
            color: Colors.white,
          ),
          maxLines: 1,
        ),
        color: Colors.green[600],
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo,
/*        minWidth: 100.0,
        height: 45.0,*/ /*        minWidth: 100.0,
        height: 45.0,*/
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  Widget ShowImage() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Material(
          elevation: 2.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            height: 250,
            child: FutureBuilder<void>(
              future: retrieveLostData(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Text(
                      "Please wait...",
                      textAlign: TextAlign.center,
                    );
                  case ConnectionState.done:
                    if (_image != null) {
                      return Image.file(_image);
                    }
                    return Text(
                      "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Text(
                        "Pick Image Error",
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return Text(
                        "Pick Image Error",
                        textAlign: TextAlign.center,
                      );
                    }
                }
              },
            ),
          )),
    );
  }

  void _onLoading() {
    final themeColor = new Color(0xfff5a623);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Center(
                  child: CircularProgressIndicator(),
                ),
                new Text("  \nAnalysing...")
              ],
            ));
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AnalysisResult()
      ));
    });
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }
}
