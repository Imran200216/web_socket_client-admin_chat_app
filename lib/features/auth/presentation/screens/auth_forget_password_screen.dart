import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_admin_client/commons/widgets/KFilledBtn.dart';
import 'package:socket_io_admin_client/commons/widgets/KSnackBar.dart';
import 'package:socket_io_admin_client/commons/widgets/KTextBtn.dart';
import 'package:socket_io_admin_client/commons/widgets/KTextFormField.dart';
import 'package:socket_io_admin_client/commons/widgets/KVerticalSpacer.dart';
import 'package:socket_io_admin_client/core/constants/app_assets_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_router_constants.dart';
import 'package:socket_io_admin_client/core/logger/app_logger.dart';
import 'package:socket_io_admin_client/core/validator/app_validators.dart';
import 'package:socket_io_admin_client/features/auth/presentation/providers/auth_email_provider.dart';

class AuthForgetPasswordScreen extends StatefulWidget {
  const AuthForgetPasswordScreen({super.key});

  @override
  State<AuthForgetPasswordScreen> createState() =>
      _AuthForgetPasswordScreenState();
}

class _AuthForgetPasswordScreenState extends State<AuthForgetPasswordScreen> {
  // Controller
  final TextEditingController emailForgetPasswordController =
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
                    // Forget Password Img
                    SvgPicture.asset(
                      AppAssetsConstants.authForgetPasswordImg,
                      height: 400,
                      width: 400,
                      fit: BoxFit.contain,
                    ),

                    KVerticalSpacer(height: 20),

                    // Email TextField
                    KTextFormField(
                      validator: (value) => AppValidators.validateEmail(value),
                      controller: emailForgetPasswordController,
                      hintText: "Email",
                      prefixIcon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    KVerticalSpacer(height: 10),

                    // Send Btn
                    KFilledBtn(
                      isLoading: authEmailProvider.isLoading,
                      label: "Send password link",
                      icon: Icons.link,
                      color: AppColorsConstants.primaryColor,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          // Form Valid
                          AppLogger.info("Form is Valid");

                          // Forget Password function
                          await authEmailProvider.sendResetEmailPassword(
                            emailForgetPasswordController.text.trim(),
                          );

                          // Success SnackBar
                          KSnackBar.success(
                            context: context,
                            message: "Sign In Successfully",
                          );

                          // Login Screen
                          GoRouter.of(
                            context,
                          ).pushReplacementNamed(AppRouterConstants.authLogin);
                        } else {
                          KSnackBar.error(
                            context: context,
                            message: "Something went wrong. Please try again.",
                          );

                          AppLogger.error("Form is invalid");
                        }
                      },
                    ),

                    KTextBtn(
                      isUnderline: true,
                      label: "Back to Login",
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      color: AppColorsConstants.blackColor,
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
