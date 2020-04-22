class QuestionModel {
  List<Data> data;

  QuestionModel({this.data});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String question;
  String createdOn;

  Data(
      {this.id,
        this.question,
        this.createdOn});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['created_on'] = this.createdOn;
    return data;
  }
}