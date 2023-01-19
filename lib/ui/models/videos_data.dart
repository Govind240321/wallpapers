/// videoId : ""

class VideosData {
  VideosData({
    String? videoId,
  }) {
    _videoId = videoId;
  }

  VideosData.fromJson(dynamic json) {
    _videoId = json['videoId'];
  }

  String? _videoId;

  VideosData copyWith({
    String? videoId,
  }) =>
      VideosData(
        videoId: videoId ?? _videoId,
      );

  String? get videoId => _videoId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['videoId'] = _videoId;
    return map;
  }
}
