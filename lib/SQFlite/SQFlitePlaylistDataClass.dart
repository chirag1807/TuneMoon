class SQFlitePlaylistDataClass {
  String? sId;
  String? musicFilePath;
  String? title;
  String? singers;
  String? movie;
  String? actors;

  SQFlitePlaylistDataClass({this.sId, this.musicFilePath, this.title, this.singers, this.movie, this.actors});

  SQFlitePlaylistDataClass.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    musicFilePath = json['musicFilePath'];
    title = json['title'];
    singers = json['singers'];
    movie = json['movie'];
    actors = json['actors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['musicFilePath'] = musicFilePath;
    data['title'] = title;
    data['singers'] = singers;
    data['movie'] = movie;
    data['actors'] = actors;
    return data;
  }
}