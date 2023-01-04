/// id : "wes"
/// displayName : ""
/// email : ""
/// streaksPoint : 20

class UserData {
  UserData({
    String? id,
    String? displayName,
    String? email,
    num? streaksPoint,
  }) {
    _id = id;
    _displayName = displayName;
    _email = email;
    _streaksPoint = streaksPoint;
  }

  UserData.fromJson(dynamic json) {
    _id = json['id'];
    _displayName = json['displayName'];
    _email = json['email'];
    _streaksPoint = json['streaksPoint'];
  }

  String? _id;
  String? _displayName;
  String? _email;
  num? _streaksPoint;
  UserData copyWith({
    String? id,
    String? displayName,
    String? email,
    num? streaksPoint,
  }) =>
      UserData(
        id: id ?? _id,
        displayName: displayName ?? _displayName,
        email: email ?? _email,
        streaksPoint: streaksPoint ?? _streaksPoint,
      );
  String? get id => _id;
  String? get displayName => _displayName;
  String? get email => _email;
  num? get streaksPoint => _streaksPoint;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['displayName'] = _displayName;
    map['email'] = _email;
    map['streaksPoint'] = _streaksPoint;
    return map;
  }
}
