import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'analysisResult.dart';

class CaptureImagePage extends StatefulWidget {
  final int marks;

  CaptureImagePage({Key key, @required this.marks}) : super(key: key);

  @override
  CaptureImagePageState createState() => CaptureImagePageState(marks);
}

class CaptureImagePageState extends State<CaptureImagePage> {
  File _image;
  //String _retrieveDataError;
  ProgressDialog progressDialog;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 224.0,maxWidth: 224.0);

    setState(() {
      _image = image;
    });
  }

  String message;
  var imageResult;

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
                showImage(),
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

  Widget showImage() {
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
                      List<int> imageBytes = _image.readAsBytesSync();
                      String base64Image = base64Encode(imageBytes);
                      result(base64Image);
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

//getting csrf token for server request
  Future<String> getCsrfToken() async {
    var response = await http.get(Uri.encodeFull('http://mdhassan.herokuapp.com/imagepredict'));
    var csrfToken = response.headers.remove('set-cookie').substring(10, 74); //csrf 64 chars
    return csrfToken;
  }

  result(String image) async{
    //final csrf = await getCsrfToken();
    var response = await http.post('http://mdhassan.herokuapp.com/imagepredict',
    body:{
      'image' : image
    });
    imageResult = jsonDecode(response.body);
  }

  dialogNotToGoBack(){
    showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text("ERROR"),
        content: new Text("Please try again."),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.close), onPressed: (){Navigator.pop(context);})
        ],
      ),
    );
  }

  void _onLoading() {
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
    new Future.delayed(new Duration(seconds: 5), () {
      if(imageResult!=null){
        Navigator.pop(context); //pop dialog
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AnalysisResult(imageResult: imageResult)
        ));
      }else{
        Navigator.pop(context);
        dialogNotToGoBack();
      }
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
      //_retrieveDataError = response.exception.code;
    }
  }
}
