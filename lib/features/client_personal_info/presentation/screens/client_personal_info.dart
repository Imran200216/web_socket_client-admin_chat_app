import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';
import 'package:socket_io_admin_client/features/user/presentation/providers/user_client_provider.dart';

class ClientPersonalInfo extends StatefulWidget {
  const ClientPersonalInfo({super.key});

  @override
  State<ClientPersonalInfo> createState() => _ClientPersonalInfoState();
}

class _ClientPersonalInfoState extends State<ClientPersonalInfo> {
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<UserClientProvider>().fetchUser(uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserClientProvider>();

    return Scaffold(
      backgroundColor: AppColorsConstants.whiteColor,
      appBar: AppBar(
        title: const Text("User Info"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.user == null
          ? const Center(child: Text("No user found"))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColorsConstants.whiteColor,
                  border: Border.all(
                    color: AppColorsConstants.textFieldHintColor,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Role: ${provider.user!.companyRole}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text('Emp ID: ${provider.user!.empId}'),
                  ],
                ),
              ),
            ),
    );
  }
}
