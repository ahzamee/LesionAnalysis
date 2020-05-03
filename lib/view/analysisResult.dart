import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:lesionanalysis/view/homePage.dart';

class AnalysisResult extends StatefulWidget {
  var imageResult;

  AnalysisResult({Key key, @required this.imageResult}) : super(key: key);
  @override
  _AnalysisResultState createState() => _AnalysisResultState(imageResult);
}

class _AnalysisResultState extends State<AnalysisResult> {
  var imageResult;
  _AnalysisResultState(this.imageResult);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
           Expanded(
             flex: 9,
             child: Center(
               child: DataTable(
                 columns: [
                   DataColumn(label: Text('Type',style: TextStyle(
                     fontSize: 16
                   ),)),
                   DataColumn(label: Text('Score',style: TextStyle(
                       fontSize: 16
                   ),)),
                 ],
                 rows: [
                   DataRow(cells: [
                     DataCell(Text('akiec')),
                     DataCell(Text(imageResult[0][0].toString())),
                   ]),
                   DataRow(cells: [
                     DataCell(Text('bcc')),
                     DataCell(Text(imageResult[0][1].toString())),
                   ]),
                   DataRow(cells: [
                     DataCell(Text('bkl')),
                     DataCell(Text(imageResult[0][2].toString())),
                   ]),
                   DataRow(cells: [
                     DataCell(Text('df')),
                     DataCell(Text(imageResult[0][3].toString())),
                   ]),
                   DataRow(cells: [
                     DataCell(Text('mel')),
                     DataCell(Text(imageResult[0][4].toString())),
                   ]),
                   DataRow(cells: [
                     DataCell(Text('ny')),
                     DataCell(Text(imageResult[0][5].toString())),
                   ]),
                   DataRow(cells: [
                     DataCell(Text('vasc')),
                     DataCell(Text(imageResult[0][6].toString())),
                   ])
                 ],
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
                  /*Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HomePage()
                  ));*/
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
