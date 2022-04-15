class Questions {
  final String? type;
  final String? question;
  final List<String>? options;
  final List<String>? answer;
  final Tags? tag;
  Questions({this.type, this.question, this.options, this.answer, this.tag});

  factory Questions.fromJson(Map<String, dynamic> json) {
    //print(json);
    var ans;
    if (json['Answers'] is String) {
      ans = [json['Answers'].toString()];
    } else {
      ans = json['Answers'].cast<String>();
    }
    return Questions(
        type: json['Type'],
        question: json['Question'],
        options: json['Options'].cast<String>() as List<String>,
        answer: ans as List<String>,
        tag: Tags.fromJson(json['Tags']));
  }
}

class Tags {
  final String? subject;
  final String? marks;
  final List<String>? bloom;
  final List<String>? keyword;

  Tags({this.subject, this.marks, this.bloom,this.keyword});

  factory Tags.fromJson(Map<String, dynamic> json) {
    //print(json['image']['data']);
    return Tags(
      subject: json['Subject'] ?? '',
      marks: json['Marks'] ?? '',
      bloom: json['Bloom’s Taxonomy'].cast<String>() as List<String>,
      keyword: json['Keywords'].cast<String>() as List<String>,
    );
  }
}
