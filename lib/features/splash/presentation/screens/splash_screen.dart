import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_admin_client/core/constants/app_assets_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_db_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_router_constants.dart';
import 'package:socket_io_admin_client/core/service/auth_local_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateUser();
  }

  //
  Future<void> _navigateUser() async {
    // splash delay
    await Future.delayed(const Duration(seconds: 2));

    // local storage status
    final isAuthenticated = await AuthLocalService.getAuthStatus();
    final hasDesignation = await AuthLocalService.getHasDesignation();
    final userRole = await AuthLocalService.getUserRole();

    if (!isAuthenticated) {
      // 🔐 Not authenticated → Go to Login
      GoRouter.of(context).pushReplacementNamed(AppRouterConstants.authLogin);
    } else if (!hasDesignation) {
      // 🧾 Authenticated but no role → Go to Role screen
      GoRouter.of(context).pushReplacementNamed(AppRouterConstants.userRole);
    } else {
      // ✅ Authenticated and has role
      if (userRole == AppDBConstants.admin) {
        GoRouter.of(context).pushReplacementNamed(AppRouterConstants.chat);
      } else {
        GoRouter.of(context).pushReplacementNamed(AppRouterConstants.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsConstants.whiteColor,
      body: Center(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Splash Icon
            SvgPicture.asset(
              AppAssetsConstants.splashIcon,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),

            // App Name
            Text(
              "SOC Client",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppColorsConstants.blackColor,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
