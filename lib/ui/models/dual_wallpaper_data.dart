/// _id : "63f4f0f55df26679558b7b3c"
/// streakPoint : 20
/// leftImage : {"file_url":"uidsuduis","public_id":"isidosdid","file_type":"hsohdasod","id":"1676996831079"}
/// rightImage : {"file_url":"hosahdoa","public_id":"jiaoihda","file_type":"adsdind","id":"1676996831079"}
/// dCreatedAt : "2023-02-21T16:27:33.641Z"
/// dUpdatedAt : "2023-02-21T16:27:33.641Z"
/// __v : 0

class DualWallpaperData {
  DualWallpaperData({
    String? id,
    num? streakPoint,
    LeftImage? leftImage,
    RightImage? rightImage,
    String? dCreatedAt,
    String? dUpdatedAt,
    num? v,
  }) {
    _id = id;
    _streakPoint = streakPoint;
    _leftImage = leftImage;
    _rightImage = rightImage;
    _dCreatedAt = dCreatedAt;
    _dUpdatedAt = dUpdatedAt;
    _v = v;
  }

  DualWallpaperData.fromJson(dynamic json) {
    _id = json['_id'];
    _streakPoint = json['streakPoint'];
    _leftImage = json['leftImage'] != null
        ? LeftImage.fromJson(json['leftImage'])
        : null;
    _rightImage = json['rightImage'] != null
        ? RightImage.fromJson(json['rightImage'])
        : null;
    _dCreatedAt = json['dCreatedAt'];
    _dUpdatedAt = json['dUpdatedAt'];
    _v = json['__v'];
  }

  String? _id;
  num? _streakPoint;
  LeftImage? _leftImage;
  RightImage? _rightImage;
  String? _dCreatedAt;
  String? _dUpdatedAt;
  num? _v;

  DualWallpaperData copyWith({
    String? id,
    num? streakPoint,
    LeftImage? leftImage,
    RightImage? rightImage,
    String? dCreatedAt,
    String? dUpdatedAt,
    num? v,
  }) =>
      DualWallpaperData(
        id: id ?? _id,
        streakPoint: streakPoint ?? _streakPoint,
        leftImage: leftImage ?? _leftImage,
        rightImage: rightImage ?? _rightImage,
        dCreatedAt: dCreatedAt ?? _dCreatedAt,
        dUpdatedAt: dUpdatedAt ?? _dUpdatedAt,
        v: v ?? _v,
      );

  String? get id => _id;

  num? get streakPoint => _streakPoint;

  LeftImage? get leftImage => _leftImage;

  RightImage? get rightImage => _rightImage;

  String? get dCreatedAt => _dCreatedAt;

  String? get dUpdatedAt => _dUpdatedAt;

  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['streakPoint'] = _streakPoint;
    if (_leftImage != null) {
      map['leftImage'] = _leftImage?.toJson();
    }
    if (_rightImage != null) {
      map['rightImage'] = _rightImage?.toJson();
    }
    map['dCreatedAt'] = _dCreatedAt;
    map['dUpdatedAt'] = _dUpdatedAt;
    map['__v'] = _v;
    return map;
  }
}

/// file_url : "hosahdoa"
/// public_id : "jiaoihda"
/// file_type : "adsdind"
/// id : "1676996831079"

class RightImage {
  RightImage({
    String? fileUrl,
    String? publicId,
    String? fileType,
    String? id,
  }) {
    _fileUrl = fileUrl;
    _publicId = publicId;
    _fileType = fileType;
    _id = id;
  }

  RightImage.fromJson(dynamic json) {
    _fileUrl = json['file_url'];
    _publicId = json['public_id'];
    _fileType = json['file_type'];
    _id = json['id'];
  }

  String? _fileUrl;
  String? _publicId;
  String? _fileType;
  String? _id;

  RightImage copyWith({
    String? fileUrl,
    String? publicId,
    String? fileType,
    String? id,
  }) =>
      RightImage(
        fileUrl: fileUrl ?? _fileUrl,
        publicId: publicId ?? _publicId,
        fileType: fileType ?? _fileType,
        id: id ?? _id,
      );

  String? get fileUrl => _fileUrl;

  String? get publicId => _publicId;

  String? get fileType => _fileType;

  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['file_url'] = _fileUrl;
    map['public_id'] = _publicId;
    map['file_type'] = _fileType;
    map['id'] = _id;
    return map;
  }
}

/// file_url : "uidsuduis"
/// public_id : "isidosdid"
/// file_type : "hsohdasod"
/// id : "1676996831079"

class LeftImage {
  LeftImage({
    String? fileUrl,
    String? publicId,
    String? fileType,
    String? id,
  }) {
    _fileUrl = fileUrl;
    _publicId = publicId;
    _fileType = fileType;
    _id = id;
  }

  LeftImage.fromJson(dynamic json) {
    _fileUrl = json['file_url'];
    _publicId = json['public_id'];
    _fileType = json['file_type'];
    _id = json['id'];
  }

  String? _fileUrl;
  String? _publicId;
  String? _fileType;
  String? _id;

  LeftImage copyWith({
    String? fileUrl,
    String? publicId,
    String? fileType,
    String? id,
  }) =>
      LeftImage(
        fileUrl: fileUrl ?? _fileUrl,
        publicId: publicId ?? _publicId,
        fileType: fileType ?? _fileType,
        id: id ?? _id,
      );

  String? get fileUrl => _fileUrl;

  String? get publicId => _publicId;

  String? get fileType => _fileType;

  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['file_url'] = _fileUrl;
    map['public_id'] = _publicId;
    map['file_type'] = _fileType;
    map['id'] = _id;
    return map;
  }

}