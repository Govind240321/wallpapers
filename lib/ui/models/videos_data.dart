/// id : ""
/// videoUrl : ""
/// public_id : ""
/// type : ""

// {
// "id":"",
// "videoUrl":"",
// "public_id":"",
// "type":""
// }

class VideoData {
  VideoData({
    String? id,
    String? videoUrl,
    String? publicId,
    String? type,
  }) {
    _id = id;
    _videoUrl = videoUrl;
    _publicId = publicId;
    _type = type;
  }

  VideoData.fromJson(dynamic json) {
    _id = json['id'];
    _videoUrl = json['videoUrl'];
    _publicId = json['public_id'];
    _type = json['type'];
  }

  String? _id;
  String? _videoUrl;
  String? _publicId;
  String? _type;

  VideoData copyWith({
    String? id,
    String? videoUrl,
    String? publicId,
    String? type,
  }) =>
      VideoData(
        id: id ?? _id,
        videoUrl: videoUrl ?? _videoUrl,
        publicId: publicId ?? _publicId,
        type: type ?? _type,
      );

  String? get id => _id;

  String? get videoUrl => _videoUrl;

  String? get publicId => _publicId;

  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['videoUrl'] = _videoUrl;
    map['public_id'] = _publicId;
    map['type'] = _type;
    return map;
  }
}