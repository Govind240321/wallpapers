/// _id : "63f3a6d720f14aef95193449"
/// categoryId : "63f3a6c520f14aef95193444"
/// imageUrl : "iyiyiy.png"
/// public_id : "rgg"
/// streakPoint : 0
/// dCreatedAt : "2023-02-20T16:59:03.399Z"
/// dUpdatedAt : "2023-02-20T16:59:03.399Z"
/// __v : 0

class ImageData {
  ImageData({
    String? id,
    String? categoryId,
    String? imageUrl,
    String? publicId,
    num? streakPoint,
    String? dCreatedAt,
    String? dUpdatedAt,
    num? v,
  }) {
    _id = id;
    _categoryId = categoryId;
    _imageUrl = imageUrl;
    _publicId = publicId;
    _streakPoint = streakPoint;
    _dCreatedAt = dCreatedAt;
    _dUpdatedAt = dUpdatedAt;
    _v = v;
  }

  ImageData.fromJson(dynamic json) {
    _id = json['_id'];
    _categoryId = json['categoryId'];
    _imageUrl = json['imageUrl'];
    _publicId = json['public_id'];
    _streakPoint = json['streakPoint'];
    _dCreatedAt = json['dCreatedAt'];
    _dUpdatedAt = json['dUpdatedAt'];
    _v = json['__v'];
  }

  String? _id;
  String? _categoryId;
  String? _imageUrl;
  String? _publicId;
  num? _streakPoint;
  String? _dCreatedAt;
  String? _dUpdatedAt;
  num? _v;

  ImageData copyWith({
    String? id,
    String? categoryId,
    String? imageUrl,
    String? publicId,
    num? streakPoint,
    String? dCreatedAt,
    String? dUpdatedAt,
    num? v,
  }) =>
      ImageData(
        id: id ?? _id,
        categoryId: categoryId ?? _categoryId,
        imageUrl: imageUrl ?? _imageUrl,
        publicId: publicId ?? _publicId,
        streakPoint: streakPoint ?? _streakPoint,
        dCreatedAt: dCreatedAt ?? _dCreatedAt,
        dUpdatedAt: dUpdatedAt ?? _dUpdatedAt,
        v: v ?? _v,
      );

  String? get id => _id;

  String? get categoryId => _categoryId;

  String? get imageUrl => _imageUrl;

  String? get publicId => _publicId;

  num? get streakPoint => _streakPoint;

  String? get dCreatedAt => _dCreatedAt;

  String? get dUpdatedAt => _dUpdatedAt;

  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['categoryId'] = _categoryId;
    map['imageUrl'] = _imageUrl;
    map['public_id'] = _publicId;
    map['streakPoint'] = _streakPoint;
    map['dCreatedAt'] = _dCreatedAt;
    map['dUpdatedAt'] = _dUpdatedAt;
    map['__v'] = _v;
    return map;
  }

}