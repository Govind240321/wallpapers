class CategoryItem {
  final String id;
  final String name;
  final String thumbnailUrl;
  final bool firebaseData;
  bool isPremium = false;

  CategoryItem(this.id, this.name, this.thumbnailUrl, [this.firebaseData = false]);
}
