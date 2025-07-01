import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_admin_client/commons/widgets/KFilledBtn.dart';
import 'package:socket_io_admin_client/commons/widgets/KTextFormField.dart';
import 'package:socket_io_admin_client/commons/widgets/KUIDGeneratableTextFormField.dart';
import 'package:socket_io_admin_client/commons/widgets/KVerticalSpacer.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';
import 'package:socket_io_admin_client/core/logger/app_logger.dart';
import 'package:socket_io_admin_client/features/user/presentation/providers/user_client_provider.dart';
import 'package:socket_io_admin_client/features/user/presentation/providers/uuid_generator_provider.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

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
      backgroundColor: AppColorsConstants.whiteColor,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Company Role TextField
              KTextFormField(
                controller: companyRoleController,
                hintText: "Company Role",
                prefixIcon: Icons.person,
              ),

              const KVerticalSpacer(height: 20),

              // Employee Id TextField using UUID Provider
              Consumer<UUIDGeneratorProvider>(
                builder: (context, uuidProvider, _) {
                  // Sync the controller with the UUID provider
                  empIdController.text = uuidProvider.uuid;
                  return KUIDGeneratableTextField(
                    controller: empIdController,
                    hintText: "Employee ID",
                    prefixIcon: Icons.important_devices,
                    suffixIcon: Icons.refresh,
                    onSuffixIconTap: () {
                      uuidProvider.generateNewUUID();
                    },
                  );
                },
              ),

              const KVerticalSpacer(height: 40),

              Consumer<UserClientProvider>(
                builder: (context, userClientProvider, child) {
                  return KFilledBtn(
                    label: "Add User",
                    icon: Icons.add,
                    onPressed: () {
                      // You can handle form submission here
                      if (formKey.currentState!.validate()) {
                        AppLogger.info("Form Valid");

                        final role = companyRoleController.text.trim();
                        final empId = empIdController.text.trim();
                      }
                    },
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
