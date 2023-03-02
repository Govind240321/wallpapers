/// _id : "8974930u7586899693yw7586"
/// displayName : "govind"
/// email : "ranjetttu9@gmail.com"
/// googleId : "yugiop"
/// streakPoint : 40
/// dCreatedAt : "2023-02-23T15:57:54.966Z"
/// dUpdatedAt : "2023-02-23T17:33:09.774Z"
/// __v : 0

class UserData {
  UserData({
    String? id,
    String? displayName,
    String? email,
    String? googleId,
    num? streakPoint,
    String? dCreatedAt,
    String? dUpdatedAt,
    num? v,
  }) {
    _id = id;
    _displayName = displayName;
    _email = email;
    _googleId = googleId;
    _streakPoint = streakPoint;
    _dCreatedAt = dCreatedAt;
    _dUpdatedAt = dUpdatedAt;
    _v = v;
  }

  UserData.fromJson(dynamic json) {
    _id = json['_id'];
    _displayName = json['displayName'];
    _email = json['email'];
    _googleId = json['googleId'];
    _streakPoint = json['streakPoint'];
    _dCreatedAt = json['dCreatedAt'];
    _dUpdatedAt = json['dUpdatedAt'];
    _v = json['__v'];
  }

  String? _id;
  String? _displayName;
  String? _email;
  String? _googleId;
  num? _streakPoint;
  String? _dCreatedAt;
  String? _dUpdatedAt;
  num? _v;

  UserData copyWith({
    String? id,
    String? displayName,
    String? email,
    String? googleId,
    num? streakPoint,
    String? dCreatedAt,
    String? dUpdatedAt,
    num? v,
  }) =>
      UserData(
        id: id ?? _id,
        displayName: displayName ?? _displayName,
        email: email ?? _email,
        googleId: googleId ?? _googleId,
        streakPoint: streakPoint ?? _streakPoint,
        dCreatedAt: dCreatedAt ?? _dCreatedAt,
        dUpdatedAt: dUpdatedAt ?? _dUpdatedAt,
        v: v ?? _v,
      );

  String? get id => _id;

  String? get displayName => _displayName;

  String? get email => _email;

  String? get googleId => _googleId;

  num? get streakPoint => _streakPoint;

  String? get dCreatedAt => _dCreatedAt;

  String? get dUpdatedAt => _dUpdatedAt;

  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['displayName'] = _displayName;
    map['email'] = _email;
    map['googleId'] = _googleId;
    map['streakPoint'] = _streakPoint;
    map['dCreatedAt'] = _dCreatedAt;
    map['dUpdatedAt'] = _dUpdatedAt;
    map['__v'] = _v;
    return map;
  }

}