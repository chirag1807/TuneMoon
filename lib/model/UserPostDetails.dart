import 'dart:convert';

class UserPostDetails {
  String? uid;
  String? userName;
  List<String>? favArtists;

  UserPostDetails({this.uid, this.userName, this.favArtists});

  UserPostDetails.fromMap(Map<String, dynamic> map){
    uid = map["uid"];
    userName = map["userName"];
    favArtists = map["favArtists"].cast<String>();
  }

  Map<String, dynamic> toMap(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['userName'] = userName;
    data['favArtists'] = favArtists;
    return data;
  }
}
