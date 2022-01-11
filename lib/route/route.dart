
import 'package:forwa_app/screens/address_select/address_select_screen.dart';
import 'package:forwa_app/screens/message/message_screen.dart';
import 'package:forwa_app/screens/choose_receiver/choose_receiver_screen.dart';
import 'package:forwa_app/screens/choose_receiver/choose_receiver_screen_controller.dart';
import 'package:forwa_app/screens/edit_profile_address/edit_profile_address_screen.dart';
import 'package:forwa_app/screens/edit_profile_address/edit_profile_address_screen_controller.dart';
import 'package:forwa_app/screens/give/give_screen.dart';
import 'package:forwa_app/screens/give/give_screen_controller.dart';
import 'package:forwa_app/screens/give_success/give_success_screen.dart';
import 'package:forwa_app/screens/give_success/give_success_screen_controller.dart';
import 'package:forwa_app/screens/introduction/intro_screen.dart';
import 'package:forwa_app/screens/introduction/intro_screen_controller.dart';
import 'package:forwa_app/screens/login/login_screen.dart';
import 'package:forwa_app/screens/login/login_screen_controller.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:forwa_app/screens/message/message_screen_controller.dart';
import 'package:forwa_app/screens/order/order_screen.dart';
import 'package:forwa_app/screens/order/order_screen_controller.dart';
import 'package:forwa_app/screens/password_forgot/password_forgot_screen.dart';
import 'package:forwa_app/screens/password_forgot/password_forgot_screen_controller.dart';
import 'package:forwa_app/screens/password_reset/password_reset_screen.dart';
import 'package:forwa_app/screens/password_reset/password_reset_screen_controller.dart';
import 'package:forwa_app/screens/product/product_screen.dart';
import 'package:forwa_app/screens/product/product_screen_controller.dart';
import 'package:forwa_app/screens/profile/profile_screen.dart';
import 'package:forwa_app/screens/profile/profile_screen_controller.dart';
import 'package:forwa_app/screens/profile_address/profile_address_screen.dart';
import 'package:forwa_app/screens/profile_address/profile_address_screen_controller.dart';
import 'package:forwa_app/screens/profile_edit/profile_edit_screen.dart';
import 'package:forwa_app/screens/profile_edit/profile_edit_screen_controller.dart';
import 'package:forwa_app/screens/public_profile/public_profile_screen.dart';
import 'package:forwa_app/screens/public_profile/public_profile_screen_controller.dart';
import 'package:forwa_app/screens/register/register_screen.dart';
import 'package:forwa_app/screens/register/register_screen_controller.dart';
import 'package:forwa_app/screens/splash/splash_screen.dart';
import 'package:forwa_app/screens/splash/splash_screen_controller.dart';
import 'package:forwa_app/screens/support/support_screen.dart';
import 'package:forwa_app/screens/take/take_screen.dart';
import 'package:forwa_app/screens/take/take_screen_controller.dart';
import 'package:forwa_app/screens/take_success/take_succcess_screen.dart';
import 'package:forwa_app/screens/take_success/take_success_screen_controller.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

const ROUTE_SPLASH = '/splash';
const ROUTE_INTRODUCTION = '/introduction';
const ROUTE_LOGIN = '/login';
const ROUTE_REGISTER = '/register';
const ROUTE_PASSWORD_FORGOT = '/password_forgot';
const ROUTE_PASSWORD_RESET = '/password_reset';
const ROUTE_PROFILE = '/profile';
const ROUTE_PUBLIC_PROFILE = '/public_profile';
const ROUTE_PROFILE_ADDRESS = '/profile_address';
const ROUTE_PROFILE_EDIT = '/profile_edit';
const ROUTE_EDIT_PROFILE_ADDRESS = '/edit_profile_address';
const ROUTE_SELECT_ADDRESS = '/select_address';
const ROUTE_MAIN = '/main';
const ROUTE_PRODUCT = '/product';
const ROUTE_GIVE = '/give';
const ROUTE_TAKE = '/take';
const ROUTE_CHOOSE_RECEIVER = '/choose_receiver';
const ROUTE_GIVE_SUCCESS = '/give_success';
const ROUTE_TAKE_SUCCESS = '/take_success';
const ROUTE_MESSAGE = '/message';
const ROUTE_SUPPORT = '/support';
const ROUTE_ORDER = '/order';

const previousRouteParam = 'previous_route';

var appRoute = [
  GetPage(name: ROUTE_SPLASH, page: () => SplashScreen(), binding: SplashScreenBinding()),
  GetPage(name: ROUTE_INTRODUCTION, page: () => const IntroScreen(), binding: IntroScreenBinding()),
  GetPage(name: ROUTE_MAIN, page: () => const MainScreen(), binding: MainScreenBinding()),
  GetPage(name: ROUTE_LOGIN, page: () => LoginScreen(), binding: LoginScreenBinding()),
  GetPage(name: ROUTE_REGISTER, page: () => RegisterScreen(), binding: RegisterScreenBinding()),
  GetPage(name: ROUTE_PASSWORD_FORGOT, page: () => PasswordForgotScreen(), binding: PasswordForgotScreenBinding()),
  GetPage(name: ROUTE_PASSWORD_RESET, page: () => PasswordResetScreen(), binding: PasswordResetScreenBinding()),
  GetPage(name: ROUTE_PRODUCT, page: () => const ProductScreen(), binding: ProductScreenBinding()),
  GetPage(name: ROUTE_GIVE, page: () => GiveScreen(), binding: GiveScreenBinding()),
  GetPage(name: ROUTE_TAKE, page: () => TakeScreen(), binding: TakeScreenBinding()),
  GetPage(name: ROUTE_PROFILE, page: () => ProfileScreen(), binding: ProfileScreenBinding()),
  GetPage(name: ROUTE_PROFILE_EDIT, page: () => const ProfileEditScreen(), binding: ProfileEditScreenBinding()),
  GetPage(name: ROUTE_PUBLIC_PROFILE, page: () => const PublicProfileScreen(), binding: PublicProfileScreenBinding()),
  GetPage(name: ROUTE_PROFILE_ADDRESS, page: () => const ProfileAddressScreen(), binding: ProfileAddressBinding()),
  GetPage(name: ROUTE_EDIT_PROFILE_ADDRESS, page: () => EditProfileAddressScreen(), binding: EditProfileAddressBinding()),
  GetPage(name: ROUTE_CHOOSE_RECEIVER, page: () => const ChooseReceiverScreen(), binding: ChooseReceiverScreenBinding()),
  GetPage(name: ROUTE_GIVE_SUCCESS, page: () => const GiveSuccessScreen(), binding: GiveSuccessBinding()),
  GetPage(name: ROUTE_TAKE_SUCCESS, page: () => const TakeSuccessScreen(), binding: TakeSuccessScreenBinding()),
  GetPage(name: ROUTE_MESSAGE, page: () => MessageScreen(), binding: MessageScreenBinding()),
  GetPage(name: ROUTE_SUPPORT, page: () => const SupportScreen()),
  GetPage(name: ROUTE_SELECT_ADDRESS, page: () => const AddressSelectScreen()),
  GetPage(name: ROUTE_ORDER, page: () => const OrderScreen(), binding: OrderScreenBinding()),
];
