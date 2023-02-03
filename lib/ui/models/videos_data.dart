/// id : ""
/// videoUrl : ""
/// public_id : ""

class VideoData {
  VideoData({
    String? id,
    String? videoUrl,
    String? publicId,
  }) {
    _id = id;
    _videoUrl = videoUrl;
    _publicId = publicId;
  }

  VideoData.fromJson(dynamic json) {
    _id = json['id'];
    _videoUrl = json['videoUrl'];
    _publicId = json['public_id'];
  }

  String? _id;
  String? _videoUrl;
  String? _publicId;

  VideoData copyWith({
    String? id,
    String? videoUrl,
    String? publicId,
  }) =>
      VideoData(
        id: id ?? _id,
        videoUrl: videoUrl ?? _videoUrl,
        publicId: publicId ?? _publicId,
      );

  String? get id => _id;

  String? get videoUrl => _videoUrl;

  String? get publicId => _publicId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['videoUrl'] = _videoUrl;
    map['public_id'] = _publicId;
    return map;
  }
}