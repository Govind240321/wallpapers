/// id : ""
/// imageUrl : ""
/// categoryId : ""
/// public_id : ""
/// user_id : ""
/// points : 20
// {
// "id":"",
// "imageUrl":"",
// "categoryId":"",
// "public_id":"",
// "user_id":"",
// "points":20
// }

class ImageData {
  ImageData({
    String? id,
    String? imageUrl,
    String? categoryId,
    String? publicId,
    String? userId,
    num? points,
  }) {
    _id = id;
    _imageUrl = imageUrl;
    _categoryId = categoryId;
    _publicId = publicId;
    _userId = userId;
    _points = points;
  }

  ImageData.fromJson(dynamic json) {
    _id = json['id'];
    _imageUrl = json['imageUrl'];
    _categoryId = json['categoryId'];
    _publicId = json['public_id'];
    _userId = json['user_id'];
    _points = json['points'];
  }

  String? _id;
  String? _imageUrl;
  String? _categoryId;
  String? _publicId;
  String? _userId;
  num? _points;

  ImageData copyWith({
    String? id,
    String? imageUrl,
    String? categoryId,
    String? publicId,
    String? userId,
    num? points,
  }) =>
      ImageData(
        id: id ?? _id,
        imageUrl: imageUrl ?? _imageUrl,
        categoryId: categoryId ?? _categoryId,
        publicId: publicId ?? _publicId,
        userId: userId ?? _userId,
        points: points ?? _points,
      );
  String? get id => _id;
  String? get imageUrl => _imageUrl;
  String? get categoryId => _categoryId;
  String? get publicId => _publicId;

  String? get userId => _userId;

  num? get points => _points;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['imageUrl'] = _imageUrl;
    map['categoryId'] = _categoryId;
    map['public_id'] = _publicId;
    map['user_id'] = _userId;
    map['points'] = _points;
    return map;
  }
}
