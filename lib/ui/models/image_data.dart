/// _id : "6431919ea5f6a178e9255d2e"
/// categoryId : "64318d008dd73d0c7cc57ab6"
/// imageUrl : "https://i.pinimg.com/originals/e8/4b/74/e84b7477d5d5a33f1f76e7e846761df6.png"
/// isDeleted : false
/// dCreatedAt : "2023-04-08T16:09:02.643Z"
/// dUpdatedAt : "2023-04-08T16:09:02.643Z"
/// isFavorite : false

class ImageData {
  ImageData({
    String? id,
    String? categoryId,
    String? imageUrl,
    bool? isDeleted,
    String? dCreatedAt,
    String? dUpdatedAt,
    bool? isFavorite,
  }) {
    _id = id;
    _categoryId = categoryId;
    _imageUrl = imageUrl;
    _isDeleted = isDeleted;
    _dCreatedAt = dCreatedAt;
    _dUpdatedAt = dUpdatedAt;
    _isFavorite = isFavorite;
  }

  ImageData.fromJson(dynamic json) {
    _id = json['_id'];
    _categoryId = json['categoryId'];
    _imageUrl = json['imageUrl'];
    _isDeleted = json['isDeleted'];
    _dCreatedAt = json['dCreatedAt'];
    _dUpdatedAt = json['dUpdatedAt'];
    _isFavorite = json['isFavorite'];
  }

  String? _id;
  String? _categoryId;
  String? _imageUrl;
  bool? _isDeleted;
  String? _dCreatedAt;
  String? _dUpdatedAt;
  bool? _isFavorite;

  ImageData copyWith({
    String? id,
    String? categoryId,
    String? imageUrl,
    bool? isDeleted,
    String? dCreatedAt,
    String? dUpdatedAt,
    bool? isFavorite,
  }) =>
      ImageData(
        id: id ?? _id,
        categoryId: categoryId ?? _categoryId,
        imageUrl: imageUrl ?? _imageUrl,
        isDeleted: isDeleted ?? _isDeleted,
        dCreatedAt: dCreatedAt ?? _dCreatedAt,
        dUpdatedAt: dUpdatedAt ?? _dUpdatedAt,
        isFavorite: isFavorite ?? _isFavorite,
      );

  String? get id => _id;

  String? get categoryId => _categoryId;

  String? get imageUrl => _imageUrl;

  bool? get isDeleted => _isDeleted;

  String? get dCreatedAt => _dCreatedAt;

  String? get dUpdatedAt => _dUpdatedAt;

  bool? get isFavorite => _isFavorite;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['categoryId'] = _categoryId;
    map['imageUrl'] = _imageUrl;
    map['isDeleted'] = _isDeleted;
    map['dCreatedAt'] = _dCreatedAt;
    map['dUpdatedAt'] = _dUpdatedAt;
    map['isFavorite'] = _isFavorite;
    return map;
  }

}