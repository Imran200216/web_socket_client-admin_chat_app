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
import 'package:socket_io_admin_client/core/service/auth_local_service.dart';
import 'package:socket_io_admin_client/core/validator/app_validators.dart';
import 'package:socket_io_admin_client/features/auth/presentation/providers/auth_email_provider.dart';

class AuthSignUpScreen extends StatefulWidget {
  const AuthSignUpScreen({super.key});

  @override
  State<AuthSignUpScreen> createState() => _AuthSignUpScreenState();
}

class _AuthSignUpScreenState extends State<AuthSignUpScreen> {
  // Controller
  final TextEditingController userNameSignUpController =
      TextEditingController();
  final TextEditingController emailSignUpController = TextEditingController();
  final TextEditingController passwordSignUpController =
      TextEditingController();

  // form Key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                    // Sign Up Image
                    SvgPicture.asset(
                      AppAssetsConstants.authSignUpImg,
                      height: 400,
                      width: 400,
                      fit: BoxFit.contain,
                    ),

                    KVerticalSpacer(height: 20),

                    // Username TextField
                    KTextFormField(
                      validator: (value) =>
                          AppValidators.validateUserName(value),
                      controller: userNameSignUpController,
                      hintText: "Username",
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                    ),

                    // Email TextField
                    KTextFormField(
                      validator: (value) => AppValidators.validateEmail(value),
                      controller: emailSignUpController,
                      hintText: "Email",
                      prefixIcon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    // Password TextField
                    KTextFormField(
                      validator: (value) =>
                          AppValidators.validatePassword(value),
                      controller: passwordSignUpController,
                      hintText: "Password",
                      prefixIcon: Icons.password,
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    KVerticalSpacer(height: 20),

                    // Sign Up Btn
                    KFilledBtn(
                      isLoading: authEmailProvider.isLoading,
                      label: "Sign Up",
                      icon: Icons.login,
                      color: AppColorsConstants.primaryColor,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          // Form Valid
                          AppLogger.info("Form is Valid");

                          // Sign Up function
                          await authEmailProvider.signUpWithEmailPassword(
                            userNameSignUpController.text.trim(),
                            emailSignUpController.text.trim(),
                            passwordSignUpController.text.trim(),
                          );

                          // Success SnackBar
                          KSnackBar.success(
                            context: context,
                            message: "Sign Up Successfully",
                          );

                          // Save auth status
                          await AuthLocalService.setAuthStatus(true);

                          // ✅ Log current auth status
                          final status = await AuthLocalService.getAuthStatus();
                          AppLogger.info("Auth Status: $status");

                          // User Role Screen
                          GoRouter.of(
                            context,
                          ).pushReplacementNamed(AppRouterConstants.userRole);
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
                            text: "Already have an account? ",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            textAlign: TextAlign.center,
                          ),

                          // Sign Up
                          KTextBtn(
                            label: "Sign In",
                            textStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColorsConstants.blackColor,
                            ),
                            onPressed: () {
                              // Sign Up Screen
                              GoRouter.of(
                                context,
                              ).pushNamed(AppRouterConstants.authLogin);
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
