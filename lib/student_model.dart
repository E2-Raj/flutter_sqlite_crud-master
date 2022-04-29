import 'dart:typed_data';
/*
class Student {
  int id;
  String name;
  Student(this.id, this.name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
    };
    return map;
  }

  Student.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}

*/

class Student {
  int id;
  Uint8List imageData;
  int pic;
  String isolate;

  Student({this.id, this.imageData, this.pic, this.isolate});

  // Just to use the data in convinent json map format.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageData': imageData,
      'pic': pic,
      'isolate': isolate,
    };
  }

  // Implement toString to make it easier to see information using just print statement while debugging
  @override
  String toString() {
    return 'MentionData{imageName: $id, imageData: $imageData,pic: $pic,isolate: $isolate}';
  }
}
