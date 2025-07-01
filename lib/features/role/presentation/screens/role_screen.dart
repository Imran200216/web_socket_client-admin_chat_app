import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_admin_client/commons/widgets/KDropDownTextFormField.dart';
import 'package:socket_io_admin_client/commons/widgets/KFilledBtn.dart';
import 'package:socket_io_admin_client/commons/widgets/KSnackBar.dart';
import 'package:socket_io_admin_client/commons/widgets/KVerticalSpacer.dart';
import 'package:socket_io_admin_client/core/constants/app_assets_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_db_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_router_constants.dart';
import 'package:socket_io_admin_client/core/logger/app_logger.dart';
import 'package:socket_io_admin_client/core/service/auth_local_service.dart';
import 'package:socket_io_admin_client/features/role/presentation/providers/user_role_drop_down_provider.dart';
import 'package:socket_io_admin_client/features/role/presentation/providers/user_role_provider.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  // form Key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // User Roles
  final List<String> userRoles = ['Admin', 'User'];

  // User Selected Value
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // User Role Image
                SvgPicture.asset(
                  AppAssetsConstants.authUserRoleImg,
                  height: 400,
                  width: 400,
                  fit: BoxFit.contain,
                ),

                // String Drop Down TextField
                Consumer<UserRoleDropDownProvider>(
                  builder: (context, userRoleDropDownProvider, child) {
                    return KStringDropdownTextFormField(
                      items: userRoleDropDownProvider.roles,
                      hintText: "Select Your Role",
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a role.';
                        }
                        return null;
                      },
                      selectedValue: userRoleDropDownProvider.selectedRole,
                      onChanged: (value) {
                        userRoleDropDownProvider.setSelectedRole(value);
                      },
                      onSaved: (value) {
                        userRoleDropDownProvider.setSelectedRole(value);
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    );
                  },
                ),

                KVerticalSpacer(height: 40),

                // Next Button
                Consumer<UserRoleProvider>(
                  builder: (context, userRoleProvider, child) {
                    return KFilledBtn(
                      isLoading: userRoleProvider.isLoading,
                      label: "Next",
                      icon: Icons.navigate_next,
                      color: AppColorsConstants.primaryColor,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          AppLogger.info("Form is Valid");

                          final role = context
                              .read<UserRoleDropDownProvider>()
                              .selectedRole;
                          if (role == null) return;

                          // Save role locally
                          await AuthLocalService.setHasDesignation(true);
                          await AuthLocalService.setUserRole(role);
                          final userRoleSelected =
                              await AuthLocalService.getUserRole();
                          AppLogger.info("User Role: $userRoleSelected");

                          // Get current user UID
                          final userUid =
                              FirebaseAuth.instance.currentUser?.uid;
                          if (userUid == null) {
                            AppLogger.error("User UID is null");
                            KSnackBar.error(
                              context: context,
                              message: "Something went wrong. Please re-login.",
                            );
                            return;
                          }

                          // Update role in Firestore
                          await userRoleProvider.updateUserRole(
                            userUid,
                            userRoleSelected!,
                          );

                          // Show success toast
                          KSnackBar.success(
                            context: context,
                            message: "User Role Selected: $userRoleSelected",
                          );

                          // Navigate based on role
                          if (userRoleSelected == AppDBConstants.admin) {
                            GoRouter.of(
                              context,
                            ).pushReplacementNamed(AppRouterConstants.chat);
                          } else {
                            GoRouter.of(
                              context,
                            ).pushReplacementNamed(AppRouterConstants.home);
                          }
                        } else {
                          KSnackBar.error(
                            context: context,
                            message: "Something went wrong. Please try again.",
                          );
                          AppLogger.error("Form is invalid");
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
