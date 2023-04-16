class ApiConstant {
  static const String baseUrl = 'sloopymobile.com';

  static const int limit = 30;

  // EndPoints
  //Categories
  static const String getTrendingCategories = 'api/category/trending';
  static const String getPopularCategories = 'api/category/popular';
  static const String getAllCategories = 'api/category/getAll';

  //Videos
  static const String getAllVideos = 'api/video/get';

  //Users
  static const String getAllUsers = 'api/admin/getAll';

  //Images
  static const String getAllImages = 'api/image/get';
  static const String availImage = 'api/user/buyImage';
  static const String checkAvailImage = 'api/user/imageCheck';
  static const String categoryWiseImages = 'api/image/:id/categoryWise';

  //Dual Wallpapers
  static const String getAllDualWallpaper = 'api/dual-wallpaper/get';
  static const String availDualWallpaper = 'api/user/buyDualWallpaper';
  static const String checkAvailDualWallpaper = 'api/user/dualCheck';

  //User
  static const String userSignUp = "api/user/signup";
  static const String getUserById = "api/user/:id/get";
  static const String updateUserById = "api/user/:id/update";
  static const String getUserImages = "api/user/image/:id";

  //Device ID
  static const String addDeviceId = 'api/deviceUser/create';

  //Favorite
  static const String getAllFavorites = 'api/favorite/:id/getAll';
  static const String addToFavorites = 'api/favorite/add-image';
  static const String removeFavorites = 'api/favorite/remove-image';
}
