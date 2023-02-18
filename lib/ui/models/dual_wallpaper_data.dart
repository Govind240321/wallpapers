/// id : ""
/// points : 20
/// left_image : {"id":"","imageUrl":"","public_id":"","file_type":""}
/// right_image : {"id":"","imageUrl":"","public_id":"","file_type":""}

/*{
"id":"",
"points":20,
"left_image":{
"id":"",
"imageUrl":"",
"public_id":"",
"file_type":""
},
"right_image":{
"id":"",
"imageUrl":"",
"public_id":"",
"file_type":""
}
}*/

class DualWallpaperData {
  DualWallpaperData({
    String? id,
    num? points,
    LeftImage? leftImage,
    RightImage? rightImage,
  }) {
    _id = id;
    _points = points;
    _leftImage = leftImage;
    _rightImage = rightImage;
  }

  DualWallpaperData.fromJson(dynamic json) {
    _id = json['id'];
    _points = json['points'];
    _leftImage = json['left_image'] != null
        ? LeftImage.fromJson(json['left_image'])
        : null;
    _rightImage = json['right_image'] != null
        ? RightImage.fromJson(json['right_image'])
        : null;
  }

  String? _id;
  num? _points;
  LeftImage? _leftImage;
  RightImage? _rightImage;

  DualWallpaperData copyWith({
    String? id,
    num? points,
    LeftImage? leftImage,
    RightImage? rightImage,
  }) =>
      DualWallpaperData(
        id: id ?? _id,
        points: points ?? _points,
        leftImage: leftImage ?? _leftImage,
        rightImage: rightImage ?? _rightImage,
      );
  String? get id => _id;
  num? get points => _points;
  LeftImage? get leftImage => _leftImage;
  RightImage? get rightImage => _rightImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['points'] = _points;
    if (_leftImage != null) {
      map['left_image'] = _leftImage?.toJson();
    }
    if (_rightImage != null) {
      map['right_image'] = _rightImage?.toJson();
    }
    return map;
  }
}

/// id : ""
/// imageUrl : ""
/// public_id : ""
/// file_type : ""

class RightImage {
  RightImage({
    String? id,
    String? imageUrl,
    String? publicId,
    String? fileType,
  }) {
    _id = id;
    _imageUrl = imageUrl;
    _publicId = publicId;
    _fileType = fileType;
  }

  RightImage.fromJson(dynamic json) {
    _id = json['id'];
    _imageUrl = json['imageUrl'];
    _publicId = json['public_id'];
    _fileType = json['file_type'];
    if (_fileType == null) {
      var extension = _imageUrl?.split(".").last;
      _fileType = extension;
    }
  }

  String? _id;
  String? _imageUrl;
  String? _publicId;
  String? _fileType;

  RightImage copyWith({
    String? id,
    String? imageUrl,
    String? publicId,
    String? fileType,
  }) =>
      RightImage(
        id: id ?? _id,
        imageUrl: imageUrl ?? _imageUrl,
        publicId: publicId ?? _publicId,
        fileType: fileType ?? _fileType,
      );

  String? get id => _id;

  String? get imageUrl => _imageUrl;

  String? get publicId => _publicId;

  String? get fileType => _fileType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['imageUrl'] = _imageUrl;
    map['public_id'] = _publicId;
    map['file_type'] = _fileType;
    return map;
  }
}

/// id : ""
/// imageUrl : ""
/// public_id : ""
/// file_type : ""

class LeftImage {
  LeftImage({
    String? id,
    String? imageUrl,
    String? publicId,
    String? fileType,
  }) {
    _id = id;
    _imageUrl = imageUrl;
    _publicId = publicId;
    _fileType = fileType;
  }

  LeftImage.fromJson(dynamic json) {
    _id = json['id'];
    _imageUrl = json['imageUrl'];
    _publicId = json['public_id'];
    _fileType = json['file_type'];
    if (_fileType == null) {
      var extension = _imageUrl?.split(".").last;
      _fileType = extension;
    }
  }

  String? _id;
  String? _imageUrl;
  String? _publicId;
  String? _fileType;

  LeftImage copyWith({
    String? id,
    String? imageUrl,
    String? publicId,
    String? fileType,
  }) =>
      LeftImage(
        id: id ?? _id,
        imageUrl: imageUrl ?? _imageUrl,
        publicId: publicId ?? _publicId,
        fileType: fileType ?? _fileType,
      );

  String? get id => _id;

  String? get imageUrl => _imageUrl;

  String? get publicId => _publicId;

  String? get fileType => _fileType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['imageUrl'] = _imageUrl;
    map['public_id'] = _publicId;
    map['file_type'] = _fileType;
    return map;
  }
}
