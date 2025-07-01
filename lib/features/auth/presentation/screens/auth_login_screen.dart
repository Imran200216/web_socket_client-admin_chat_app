import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_admin_client/commons/widgets/KFilledBtn.dart';
import 'package:socket_io_admin_client/commons/widgets/KSnackBar.dart';
import 'package:socket_io_admin_client/commons/widgets/KText.dart';
import 'package:socket_io_admin_client/commons/widgets/KTextBtn.dart';
import 'package:socket_io_admin_client/commons/widgets/KTextFormField.dart';
import 'package:socket_io_admin_client/commons/widgets/KVerticalSpacer.dart';
import 'package:socket_io_admin_client/core/constants/app_assets_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_router_constants.dart';
import 'package:socket_io_admin_client/core/logger/app_logger.dart';
import 'package:socket_io_admin_client/core/validator/app_validators.dart';
import 'package:socket_io_admin_client/core/service/auth_local_service.dart';
import 'package:socket_io_admin_client/features/auth/presentation/providers/auth_email_provider.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  // Controller
  final TextEditingController emailLoginController = TextEditingController();
  final TextEditingController passwordLoginController = TextEditingController();

  // form Key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailLoginController.dispose();
    passwordLoginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsConstants.whiteColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formKey,
          child: Container(
            color: AppColorsConstants.whiteColor,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Consumer<AuthEmailProvider>(
              builder: (context, authEmailProvider, child) {
                return Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Login Image
                    SvgPicture.asset(
                      AppAssetsConstants.authSignInImg,
                      height: 400,
                      width: 400,
                      fit: BoxFit.contain,
                    ),

                    KVerticalSpacer(height: 20),

                    // Email TextField
                    KTextFormField(
                      validator: (value) => AppValidators.validateEmail(value),
                      controller: emailLoginController,
                      hintText: "Email",
                      prefixIcon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    // Password TextField
                    KTextFormField(
                      validator: (value) =>
                          AppValidators.validatePassword(value),
                      controller: passwordLoginController,
                      hintText: "Password",
                      prefixIcon: Icons.password,
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: KTextBtn(
                        label: "Forget Password?",
                        textStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColorsConstants.blackColor,
                        ),
                        onPressed: () {
                          // Auth Forget Password
                          GoRouter.of(
                            context,
                          ).pushNamed(AppRouterConstants.authForgetPassword);
                        },
                      ),
                    ),

                    KVerticalSpacer(height: 20),

                    // Sign In Btn
                    KFilledBtn(
                      isLoading: authEmailProvider.isLoading,
                      label: "Sign In",
                      icon: Icons.login,
                      color: AppColorsConstants.primaryColor,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          // Form Valid
                          AppLogger.info("Form is Valid");

                          // Sign In function
                          await authEmailProvider.signInWithEmailPassword(
                            emailLoginController.text.trim(),
                            passwordLoginController.text.trim(),
                          );

                          // Success SnackBar
                          KSnackBar.success(
                            context: context,
                            message: "Sign In Successfully",
                          );

                          // Save auth status
                          await AuthLocalService.setAuthStatus(true);

                          // ✅ Log current auth status
                          final status = await AuthLocalService.getAuthStatus();
                          AppLogger.info("Auth Status: $status");

                          // Home Screen
                          GoRouter.of(
                            context,
                          ).pushReplacementNamed(AppRouterConstants.home);
                        } else {
                          KSnackBar.error(
                            context: context,
                            message: "Something went wrong. Please try again.",
                          );

                          AppLogger.error("Form is invalid");
                        }
                      },
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 2,
                        children: [
                          // Don't have an account
                          KText(
                            text: "Don't have an account? ",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            textAlign: TextAlign.center,
                          ),

                          // Sign Up
                          KTextBtn(
                            label: "Sign Up",
                            textStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColorsConstants.blackColor,
                            ),
                            onPressed: () {
                              // Sign Up Screen
                              GoRouter.of(
                                context,
                              ).pushNamed(AppRouterConstants.authSignUp);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
