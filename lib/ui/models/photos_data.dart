/// id : ""
/// imageUrl : ""
/// premium : false

class PhotosData {
  PhotosData({String? id, String? imageUrl, bool? premium = false}) {
    _id = id;
    _imageUrl = imageUrl;
    _premium = premium;
  }

  PhotosData.fromJson(dynamic json) {
    _id = json['id'];
    _imageUrl = json['imageUrl'];
    _premium = json['premium'];
  }

  String? _id;
  String? _imageUrl;
  bool? _premium;
  PhotosData copyWith({
    String? id,
    String? imageUrl,
    bool? premium,
  }) =>
      PhotosData(
        id: id ?? _id,
        imageUrl: imageUrl ?? _imageUrl,
        premium: premium ?? _premium,
      );
  String? get id => _id;
  String? get imageUrl => _imageUrl;
  bool? get premium => _premium;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['imageUrl'] = _imageUrl;
    map['premium'] = _premium;
    return map;
  }
}

final List<PhotosData> photosList = [
  PhotosData(id: "Love",
      imageUrl: "https://images.pexels.com/photos/1629236/pexels-photo-1629236.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  PhotosData(id: "Office",
      imageUrl: "https://images.pexels.com/photos/37347/office-sitting-room-executive-sitting.jpg?auto=compress&cs=tinysrgb&w=1600"),
  PhotosData(id: "Dark",
      imageUrl: "https://images.pexels.com/photos/2449600/pexels-photo-2449600.png?auto=compress&cs=tinysrgb&w=1600",premium: true),
  PhotosData(id: "Nature",
      imageUrl: "https://images.pexels.com/photos/15286/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1600",premium: true),
  PhotosData(id: "Winter",
      imageUrl: "https://images.pexels.com/photos/235621/pexels-photo-235621.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  PhotosData(id: "Food",
      imageUrl: "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  PhotosData(id: "Sky",
      imageUrl: "https://images.pexels.com/photos/2114014/pexels-photo-2114014.jpeg?auto=compress&cs=tinysrgb&w=1600",premium: true),
  PhotosData(id: "Animal",
      imageUrl: "https://images.pexels.com/photos/247502/pexels-photo-247502.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  PhotosData(id: "Texture",
      imageUrl: "https://images.pexels.com/photos/1629236/pexels-photo-1629236.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  PhotosData(id: "Technology",
      imageUrl: "https://images.pexels.com/photos/3861969/pexels-photo-3861969.jpeg?auto=compress&cs=tinysrgb&w=1600",premium: true),
  PhotosData(id: "Dog",
      imageUrl: "https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  PhotosData(id: "Cat",
      imageUrl: "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?auto=compress&cs=tinysrgb&w=1600",premium: true),
  PhotosData(id: "Car",
      imageUrl: "https://images.pexels.com/photos/1545743/pexels-photo-1545743.jpeg?auto=compress&cs=tinysrgb&w=1600"),
];