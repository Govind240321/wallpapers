import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:wallpapers/ui/binding/home_binding.dart';
import 'package:wallpapers/ui/constant/route_constant.dart';
import 'package:wallpapers/ui/views/home_screen.dart';
import 'package:wallpapers/ui/views/onboarding_screen.dart';
import 'package:wallpapers/ui/views/splash_screen.dart';

List<GetPage> getPages = [
  GetPage(name: RouteConstant.splashScreen, page: () => SplashScreen()),
  GetPage(name: RouteConstant.onboardingScreen, page: () => OnboardingScreen()),
  GetPage(
      name: RouteConstant.homeScreen,
      page: () => HomeScreen(),
      binding: HomeScreenBinding()),
];
