import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_admin_client/commons/widgets/KFilledBtn.dart';
import 'package:socket_io_admin_client/commons/widgets/KSnackBar.dart';
import 'package:socket_io_admin_client/commons/widgets/KTextFormField.dart';
import 'package:socket_io_admin_client/commons/widgets/KUIDGeneratableTextFormField.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_router_constants.dart';
import 'package:socket_io_admin_client/features/user/presentation/providers/user_client_provider.dart';
import 'package:socket_io_admin_client/features/user/presentation/providers/uuid_generator_provider.dart';

class UpdateUserScreen extends StatefulWidget {
  final String userUid;

  const UpdateUserScreen({super.key, required this.userUid});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final TextEditingController companyRoleController = TextEditingController();
  final TextEditingController empIdController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    companyRoleController.dispose();
    empIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text("User UID: ${widget.userUid}"),

              const SizedBox(height: 20),

              KTextFormField(
                controller: companyRoleController,
                hintText: "Company Role",
                prefixIcon: Icons.person,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter role" : null,
              ),

              const SizedBox(height: 20),

              Consumer<UUIDGeneratorProvider>(
                builder: (context, uuidProvider, _) {
                  return KUIDGeneratableTextField(
                    controller: empIdController,
                    hintText: "Employee ID",
                    prefixIcon: Icons.badge,
                    suffixIcon: Icons.refresh,
                    onSuffixIconTap: () {
                      uuidProvider.generateNewUUID();
                      empIdController.text = uuidProvider.uuid;
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? "Generate ID" : null,
                  );
                },
              ),

              const SizedBox(height: 40),

              Consumer<UserClientProvider>(
                builder: (context, userClientProvider, _) {
                  return KFilledBtn(
                    color: AppColorsConstants.primaryColor,
                    isLoading: userClientProvider.isLoading,
                    label: "Update",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final role = companyRoleController.text.trim();
                        final empId = empIdController.text.trim();

                        try {
                          await userClientProvider.updateUser(
                            userUid: widget.userUid,
                            companyRole: role,
                            empId: empId,
                          );

                          KSnackBar.success(
                            context: context,
                            message: "User updated!",
                          );

                          // User Screen
                          GoRouter.of(
                            context,
                          ).pushReplacementNamed(AppRouterConstants.user);
                        } catch (e) {
                          KSnackBar.error(
                            context: context,
                            message: "Update failed: $e",
                          );
                        }
                      }
                    },
                    icon: Icons.add,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
