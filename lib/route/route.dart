
import 'package:forwa_app/screens/chat/message_screen.dart';
import 'package:forwa_app/screens/choose_receiver/choose_receiver_screen.dart';
import 'package:forwa_app/screens/choose_receiver/choose_receiver_screen_controller.dart';
import 'package:forwa_app/screens/edit_profile_address/edit_profile_address_screen.dart';
import 'package:forwa_app/screens/edit_profile_address/edit_profile_address_screen_controller.dart';
import 'package:forwa_app/screens/give/give_screen.dart';
import 'package:forwa_app/screens/give/give_screen_controller.dart';
import 'package:forwa_app/screens/give_success/give_success_screen.dart';
import 'package:forwa_app/screens/give_success/give_success_screen_controller.dart';
import 'package:forwa_app/screens/login/login_screen.dart';
import 'package:forwa_app/screens/login/login_screen_controller.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:forwa_app/screens/product/product_screen.dart';
import 'package:forwa_app/screens/product/product_screen_controller.dart';
import 'package:forwa_app/screens/profile/profile_screen.dart';
import 'package:forwa_app/screens/profile/profile_screen_controller.dart';
import 'package:forwa_app/screens/profile_address/profile_address_screen.dart';
import 'package:forwa_app/screens/profile_address/profile_address_screen_controller.dart';
import 'package:forwa_app/screens/public_profile/public_profile_screen.dart';
import 'package:forwa_app/screens/public_profile/public_profile_screen_controller.dart';
import 'package:forwa_app/screens/register/register_screen.dart';
import 'package:forwa_app/screens/register/register_screen_controller.dart';
import 'package:forwa_app/screens/splash/splash_screen.dart';
import 'package:forwa_app/screens/splash/splash_screen_controller.dart';
import 'package:forwa_app/screens/take/take_screen.dart';
import 'package:forwa_app/screens/take/take_screen_controller.dart';
import 'package:forwa_app/screens/take_success/take_succcess_screen.dart';
import 'package:forwa_app/screens/take_success/take_success_screen_controller.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

const ROUTE_SPLASH = '/splash';
const ROUTE_LOGIN = '/login';
const ROUTE_REGISTER = '/register';
const ROUTE_PROFILE = '/profile';
const ROUTE_PUBLIC_PROFILE = '/public_profile';
const ROUTE_PROFILE_ADDRESS = '/profile_address';
const ROUTE_EDIT_PROFILE_ADDRESS = '/edit_profile_address';
const ROUTE_MAIN = '/main';
const ROUTE_PRODUCT = '/product';
const ROUTE_GIVE = '/give';
const ROUTE_TAKE = '/take';
const ROUTE_CHOOSE_RECEIVER = '/choose_receiver';
const ROUTE_GIVE_SUCCESS = '/give_success';
const ROUTE_TAKE_SUCCESS = '/take_success';
const ROUTE_MESSAGE = '/message';

var appRoute = [
  GetPage(name: ROUTE_SPLASH, page: () => SplashScreen(), binding: SplashScreenBinding()),
  GetPage(name: ROUTE_MAIN, page: () => const MainScreen(), binding: MainScreenBinding()),
  GetPage(name: ROUTE_LOGIN, page: () => const LoginScreen(), binding: LoginScreenBinding()),
  GetPage(name: ROUTE_REGISTER, page: () => const RegisterScreen(), binding: RegisterScreenBinding()),
  GetPage(name: ROUTE_PRODUCT, page: () => const ProductScreen(), binding: ProductScreenBinding()),
  GetPage(name: ROUTE_GIVE, page: () => const GiveScreen(), binding: GiveScreenBinding()),
  GetPage(name: ROUTE_TAKE, page: () => const TakeScreen(), binding: TakeScreenBinding()),
  GetPage(name: ROUTE_PROFILE, page: () => ProfileScreen(), binding: ProfileScreenBinding()),
  GetPage(name: ROUTE_PUBLIC_PROFILE, page: () => const PublicProfileScreen(), binding: PublicProfileScreenBinding()),
  GetPage(name: ROUTE_PROFILE_ADDRESS, page: () => const ProfileAddressScreen(), binding: ProfileAddressBinding()),
  GetPage(name: ROUTE_EDIT_PROFILE_ADDRESS, page: () => const EditProfileAddressScreen(), binding: EditProfileAddressBinding()),
  GetPage(name: ROUTE_CHOOSE_RECEIVER, page: () => const ChooseReceiverScreen(), binding: ChooseReceiverScreenBinding()),
  GetPage(name: ROUTE_GIVE_SUCCESS, page: () => const GiveSuccessScreen(), binding: GiveSuccessBinding()),
  GetPage(name: ROUTE_TAKE_SUCCESS, page: () => const TakeSuccessScreen(), binding: TakeSuccessScreenBinding()),
  GetPage(name: ROUTE_MESSAGE, page: () => MessageScreen()),
];
