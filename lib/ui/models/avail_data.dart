/// isAlreadyBought : false

class AvailData {
  AvailData({
    bool? isAlreadyBought,
  }) {
    _isAlreadyBought = isAlreadyBought;
  }

  AvailData.fromJson(dynamic json) {
    _isAlreadyBought = json['isAlreadyBought'];
  }

  bool? _isAlreadyBought;

  AvailData copyWith({
    bool? isAlreadyBought,
  }) =>
      AvailData(
        isAlreadyBought: isAlreadyBought ?? _isAlreadyBought,
      );

  bool? get isAlreadyBought => _isAlreadyBought;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isAlreadyBought'] = _isAlreadyBought;
    return map;
  }
}
