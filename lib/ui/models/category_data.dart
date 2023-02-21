/// _id : "63f45e07b970d9a1c14fb48e"
/// name : "Anime"
/// thumbnailUrl : "https://res.cloudinary.com/drl3zlwrd/image/upload/v1676959238/Category/Anime.jpg"
/// public_id : "Category/Anime"
/// dCreatedAt : "2023-02-21T06:00:39.244Z"
/// dUpdatedAt : "2023-02-21T15:42:49.101Z"
/// __v : 0
/// userVisit : 3
/// isTrending : true

class CategoryData {
  CategoryData({
    String? id,
    String? name,
    String? thumbnailUrl,
    String? publicId,
    String? dCreatedAt,
    String? dUpdatedAt,
    num? v,
    num? userVisit,
    bool? isTrending,
  }) {
    _id = id;
    _name = name;
    _thumbnailUrl = thumbnailUrl;
    _publicId = publicId;
    _dCreatedAt = dCreatedAt;
    _dUpdatedAt = dUpdatedAt;
    _v = v;
    _userVisit = userVisit;
    _isTrending = isTrending;
  }

  CategoryData.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _thumbnailUrl = json['thumbnailUrl'];
    _publicId = json['public_id'];
    _dCreatedAt = json['dCreatedAt'];
    _dUpdatedAt = json['dUpdatedAt'];
    _v = json['__v'];
    _userVisit = json['userVisit'];
    _isTrending = json['isTrending'];
  }

  String? _id;
  String? _name;
  String? _thumbnailUrl;
  String? _publicId;
  String? _dCreatedAt;
  String? _dUpdatedAt;
  num? _v;
  num? _userVisit;
  bool? _isTrending;

  CategoryData copyWith({
    String? id,
    String? name,
    String? thumbnailUrl,
    String? publicId,
    String? dCreatedAt,
    String? dUpdatedAt,
    num? v,
    num? userVisit,
    bool? isTrending,
  }) =>
      CategoryData(
        id: id ?? _id,
        name: name ?? _name,
        thumbnailUrl: thumbnailUrl ?? _thumbnailUrl,
        publicId: publicId ?? _publicId,
        dCreatedAt: dCreatedAt ?? _dCreatedAt,
        dUpdatedAt: dUpdatedAt ?? _dUpdatedAt,
        v: v ?? _v,
        userVisit: userVisit ?? _userVisit,
        isTrending: isTrending ?? _isTrending,
      );

  String? get id => _id;

  String? get name => _name;

  String? get thumbnailUrl => _thumbnailUrl;

  String? get publicId => _publicId;

  String? get dCreatedAt => _dCreatedAt;

  String? get dUpdatedAt => _dUpdatedAt;

  num? get v => _v;

  num? get userVisit => _userVisit;

  bool? get isTrending => _isTrending;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['thumbnailUrl'] = _thumbnailUrl;
    map['public_id'] = _publicId;
    map['dCreatedAt'] = _dCreatedAt;
    map['dUpdatedAt'] = _dUpdatedAt;
    map['__v'] = _v;
    map['userVisit'] = _userVisit;
    map['isTrending'] = _isTrending;
    return map;
  }
}
