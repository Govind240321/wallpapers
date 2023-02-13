/// id : ""
/// points : 20
/// left_image : {"id":"","imageUrl":"","public_id":""}
/// right_image : {"id":"","imageUrl":"","public_id":""}

/*{
"id":"",
"points":20,
"left_image":{
"id":"",
"imageUrl":"",
"public_id":""
},
"right_image":{
"id":"",
"imageUrl":"",
"public_id":""
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

class RightImage {
  RightImage({
    String? id,
    String? imageUrl,
    String? publicId,
  }) {
    _id = id;
    _imageUrl = imageUrl;
    _publicId = publicId;
  }

  RightImage.fromJson(dynamic json) {
    _id = json['id'];
    _imageUrl = json['imageUrl'];
    _publicId = json['public_id'];
  }

  String? _id;
  String? _imageUrl;
  String? _publicId;
  RightImage copyWith({
    String? id,
    String? imageUrl,
    String? publicId,
  }) =>
      RightImage(
        id: id ?? _id,
        imageUrl: imageUrl ?? _imageUrl,
        publicId: publicId ?? _publicId,
      );
  String? get id => _id;
  String? get imageUrl => _imageUrl;
  String? get publicId => _publicId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['imageUrl'] = _imageUrl;
    map['public_id'] = _publicId;
    return map;
  }
}

/// id : ""
/// imageUrl : ""
/// public_id : ""

class LeftImage {
  LeftImage({
    String? id,
    String? imageUrl,
    String? publicId,
  }) {
    _id = id;
    _imageUrl = imageUrl;
    _publicId = publicId;
  }

  LeftImage.fromJson(dynamic json) {
    _id = json['id'];
    _imageUrl = json['imageUrl'];
    _publicId = json['public_id'];
  }

  String? _id;
  String? _imageUrl;
  String? _publicId;
  LeftImage copyWith({
    String? id,
    String? imageUrl,
    String? publicId,
  }) =>
      LeftImage(
        id: id ?? _id,
        imageUrl: imageUrl ?? _imageUrl,
        publicId: publicId ?? _publicId,
      );
  String? get id => _id;
  String? get imageUrl => _imageUrl;
  String? get publicId => _publicId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['imageUrl'] = _imageUrl;
    map['public_id'] = _publicId;
    return map;
  }
}
