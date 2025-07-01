import 'package:go_router/go_router.dart';
import 'package:socket_io_admin_client/core/constants/app_router_constants.dart';
import 'package:socket_io_admin_client/features/auth/presentation/screens/auth_forget_password_screen.dart';
import 'package:socket_io_admin_client/features/auth/presentation/screens/auth_login_screen.dart';
import 'package:socket_io_admin_client/features/auth/presentation/screens/auth_sign_up_screen.dart';
import 'package:socket_io_admin_client/features/chat/presentation/screens/chat_screen.dart';
import 'package:socket_io_admin_client/features/home/presentation/screens/home_screen.dart';
import 'package:socket_io_admin_client/features/role/presentation/screens/role_screen.dart';
import 'package:socket_io_admin_client/features/splash/presentation/screens/splash_screen.dart';
import 'package:socket_io_admin_client/features/user/presentation/screens/update_user_screen.dart';
import 'package:socket_io_admin_client/features/user/presentation/screens/user_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Splash
    GoRoute(
      path: '/splash',
      name: AppRouterConstants.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // Login
    GoRoute(
      path: '/login',
      name: AppRouterConstants.authLogin,
      builder: (context, state) => const AuthLoginScreen(),
    ),

    // Sign Up
    GoRoute(
      path: '/signUp',
      name: AppRouterConstants.authSignUp,
      builder: (context, state) => const AuthSignUpScreen(),
    ),

    // Forget Password
    GoRoute(
      path: '/forgetPassword',
      name: AppRouterConstants.authForgetPassword,
      builder: (context, state) => const AuthForgetPasswordScreen(),
    ),

    // Role
    GoRoute(
      path: '/role',
      name: AppRouterConstants.userRole,
      builder: (context, state) => const RoleScreen(),
    ),

    // Chat
    GoRoute(
      path: '/chat',
      name: AppRouterConstants.chat,
      builder: (context, state) => const ChatScreen(),
    ),

    // home
    GoRoute(
      path: '/home',
      name: AppRouterConstants.home,
      builder: (context, state) => const HomeScreen(),
    ),

    // User
    GoRoute(
      path: '/user',
      name: AppRouterConstants.user,
      builder: (context, state) => const UserScreen(),
    ),

    // add user
    GoRoute(
      path: '/updateUser',
      name: AppRouterConstants.updateUser,
      builder: (context, state) => const UpdateUserScreen(),
    ),
  ],
);
