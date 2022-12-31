class SearchMusicDataClass {
  String? sId;
  String? musicFilePath;
  String? title;
  List<String>? singers;
  String? movie;
  List<String>? actors;

  SearchMusicDataClass({this.sId, this.musicFilePath, this.title, this.singers, this.movie, this.actors});

  SearchMusicDataClass.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    musicFilePath = json['musicFilePath'];
    title = json['title'];
    singers = json['singers'].cast<String>();
    movie = json['movie'];
    actors = json['actors'].cast<String>();
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