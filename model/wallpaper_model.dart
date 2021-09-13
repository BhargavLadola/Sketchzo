class WallpaperModel{

  String photographer;
  String photographer_Url;
  int photographer_Id;
  SrcModel src;

  WallpaperModel({this.src, this.photographer_Url, this.photographer_Id, this.photographer});

  factory WallpaperModel.fromMap(Map<String, dynamic>jsonData){
    return WallpaperModel(
      src: SrcModel.fromMap(jsonData['src']),
      photographer_Url: jsonData[' photographer_Url'],
      photographer_Id: jsonData[' photographer_id'],
      photographer: jsonData[' photographer']
    );
  }

}

class SrcModel {

  String portrait;
  String small;
  String original;

  SrcModel({this.original, this.portrait, this.small});

  factory SrcModel.fromMap(Map<String, dynamic>jsonData){
    return SrcModel(
      portrait: jsonData['portrait'],
      original: jsonData['original'],
      small: jsonData['small'],
    );
  }

}