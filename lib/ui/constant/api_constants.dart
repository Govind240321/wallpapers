class ApiConstant {
  static const String baseUrl = 'wallart-eight.vercel.app';

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
  static const String categoryWiseImages = 'api/image/:id/categoryWise';
}
