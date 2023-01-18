/// id : ""
/// imageUrl : ""
/// premium : true
/// points : 5
/// userId : ""

class PhotosData {
  PhotosData({
    String? id,
    String? imageUrl,
    bool? premium,
    num? points,
    String? userId,
  }) {
    _id = id;
    _imageUrl = imageUrl;
    _premium = premium;
    _points = points;
    _userId = userId;
  }

  PhotosData.fromJson(dynamic json) {
    _id = json['id'];
    _imageUrl = json['imageUrl'];
    _premium = json['premium'];
    _points = json['points'];
    _userId = json['userId'];
  }

  String? _id;
  String? _imageUrl;
  bool? _premium;
  num? _points;
  String? _userId;

  PhotosData copyWith({
    String? id,
    String? imageUrl,
    bool? premium,
    num? points,
    String? userId,
  }) =>
      PhotosData(
        id: id ?? _id,
        imageUrl: imageUrl ?? _imageUrl,
        premium: premium ?? _premium,
        points: points ?? _points,
        userId: userId ?? _userId,
      );

  String? get id => _id;

  String? get imageUrl => _imageUrl;

  bool? get premium => _premium;

  num? get points => _points;

  String? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['imageUrl'] = _imageUrl;
    map['premium'] = _premium;
    map['points'] = _points;
    map['userId'] = _userId;
    return map;
  }
}