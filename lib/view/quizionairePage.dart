import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lesionanalysis/model/questionModel.dart';
import 'package:http/http.dart' as http;
import 'CaptureImagePage.dart';

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  Color colorToShow = Colors.indigoAccent;
  Color right = Colors.green;
  int numOfQuestion;
  int currNumOfQuestion = 0;
  String question = "";
  String ans = "";
  String submitButton = "Next Question ->";
  List<RadioModel> ansButton = new List<RadioModel>();

  @override
  void initState() {
    super.initState();
    ansButton.add(new RadioModel(false, 'Yes'));
    ansButton.add(new RadioModel(false, 'No'));
    ansButton.add(new RadioModel(false, 'Maybe'));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return dialogNotToGoBack();
        },
        child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder(
                future: showQuestion(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    numOfQuestion = snapshot.data.data.length;
                    getFirstQuestion(snapshot.data.data[currNumOfQuestion].question, snapshot.data.data[currNumOfQuestion].id);
                    return Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3, //define % of width from the full screen
                          child: Container(
                            padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              question,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontFamily: "Quando",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: new ListView.builder(
                                  itemCount: ansButton.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new InkWell(
                                      splashColor: Colors.green[200],
                                      onTap: () {
                                        setState(() {
                                          ansButton.forEach((element) => element.isSelected = false);
                                          ansButton[index].isSelected = true;
                                          ans = ansButton[index].buttonText;
                                        });
                                      },
                                      child: new RadioItem(ansButton[index]),
                                    );
                                  },
                                )
                        ),
                        Expanded(
                          flex: 1,
                            child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: MaterialButton(
                                color: Colors.blue,
                                height: 50.0,
                                minWidth: double.infinity,
                                child: new Text(submitButton,
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontFamily: 'Alike-Regular',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onPressed: (){
                                  print(ans);
                                  print(snapshot.data.data[currNumOfQuestion].id);
                                  currNumOfQuestion = currNumOfQuestion+1; //increasing number of question
                                  if(currNumOfQuestion == numOfQuestion){ //when all question printing complete
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (context) => CaptureImagePage(marks: 10)
                                    ));
                                  }

                                  getNextQuestion(snapshot.data.data[currNumOfQuestion].question,
                                      snapshot.data.data[currNumOfQuestion].id);

                                  //for last question showing submit button.
                                  if((currNumOfQuestion)==(numOfQuestion-1)) {
                                    setState(() {
                                      submitButton = "Submit";
                                    });
                                  }

                                  //make all the button unpressed
                                  setState(() {
                                          ansButton.forEach((element) => element.isSelected = false);
                                  });

                                },
                              ),
                            ),
                        )
                      ],
                    );
                  }
                  else{
                    return showLoader();
                  }
                },
              ),
            )
        ),
    );
  }

  dialogNotToGoBack(){
    showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text("Warning"),
          content: new Text("Please complete all the questions. Thank you."),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.close), onPressed: (){Navigator.pop(context);})
          ],
        ),
    );
  }

  Future<QuestionModel> showQuestion() async{
    var data = await http.get("http://api.ahzamee.com/Questions/post/post/read.php");
    QuestionModel questionModel = QuestionModel.fromJson(json.decode(data.body));
    return questionModel;
  }

  void getNextQuestion(question, id){
    setState(() {
      this.question = '$id'+". "+'$question';
      print(question);
    });
  }
  void getFirstQuestion(question, id){
      this.question = '$id'+". "+'$question';
      print(question);
  }

  showLoader(){
    return Align(
      alignment: FractionalOffset.center,
      child: CircularProgressIndicator(),);
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(left: 50.0,top: 20.0,right: 50.0,bottom: 15.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 50.0,
            width: 200.0,
            child: new Center(
              child: new Text(_item.buttonText,
                  style: new TextStyle(
                      color:
                      _item.isSelected ? Colors.white : Colors.white,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color: _item.isSelected
                  ? Colors.green
                  : Colors.blue,
              border: new Border.all(
                  width: 1.0,
                  color: _item.isSelected
                      ? Colors.lightGreen
                      : Colors.lightBlue),
              borderRadius: const BorderRadius.all(const Radius.circular(20.0)),
              boxShadow:[
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0, // has the effect of softening the shadow
                  spreadRadius: 3.0, // has the effect of extending the shadow
                  offset: Offset(
                    5.0, // horizontal, move right 10
                    5.0, // vertical, move down 10
                  ),
                )
              ]
            ),
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}

