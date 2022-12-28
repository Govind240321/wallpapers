class LiveWallpaperItem {
  final String heroId;
  final String videoUrl;
  bool isPremium = false;

  LiveWallpaperItem(this.heroId, this.videoUrl, [this.isPremium = false]);
}

final List<LiveWallpaperItem> liveWallpaperList = [
  LiveWallpaperItem("1",
      "https://media.giphy.com/media/dxsBv1QQM0SSj2T5Hm/giphy.gif"),
  LiveWallpaperItem("2",
      "https://media.giphy.com/media/13DZCJrmTryVKU/giphy.gif"),
  LiveWallpaperItem("3",
      "https://media.giphy.com/media/f8Pe72FsM3elc47Y9e/giphy.gif"),
  LiveWallpaperItem("4",
      "https://media.giphy.com/media/IWsz1enyrhjBm/giphy.gif"),
  LiveWallpaperItem("5",
      "https://media.giphy.com/media/CWlXUL6NqRpixZjJg3/giphy.gif"),
  LiveWallpaperItem("6",
      "https://media.giphy.com/media/EuwbSy46466Q0/giphy.gif"),
  LiveWallpaperItem("7",
      "https://media.giphy.com/media/FwV7WC94GAE9knwd0d/giphy.gif"),
  LiveWallpaperItem("8",
      "https://media.giphy.com/media/BOtcdnkxEfCeje61Ok/giphy.gif"),
  LiveWallpaperItem("9",
      "https://media.giphy.com/media/IWsz1enyrhjBm/giphy.gif"),
  LiveWallpaperItem("10",
      "https://media.giphy.com/media/JvkKjnIlKQE9i/giphy.gif"),
  LiveWallpaperItem("11",
      "https://media.giphy.com/media/Q8rtelNnb7pwlFzQ0J/giphy.gif")
];
