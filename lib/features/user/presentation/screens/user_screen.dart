import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:socket_io_admin_client/commons/widgets/KUserListTile.dart';
import 'package:socket_io_admin_client/commons/widgets/KVerticalSpacer.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_db_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_router_constants.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColorsConstants.primaryColor,
        leading: IconButton(
          onPressed: () {
            // Pop
            GoRouter.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text("Users"),
        titleTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: AppColorsConstants.blackColor,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(AppDBConstants.userCollection)
            .snapshots(),
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;

          final List<Widget> children;

          if (snapshot.hasError) {
            children = const [Center(child: Text('Something went wrong'))];
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            children = const [Center(child: Text('No users found'))];
          } else {
            final users = snapshot.data!.docs;

            children = users.map((doc) {
              final userData = doc.data() as Map<String, dynamic>;

              return KUserListTile(
                userName: userData['userName'] ?? '',
                userEmail: userData['email'] ?? '',
                companyRole: userData['companyRole'] ?? '',
                empId: userData['empId'] ?? '',
                userUid: doc.id,
                onTap: () {
                  GoRouter.of(
                    context,
                  ).pushNamed(AppRouterConstants.updateUser, extra: doc.id);
                },
              );
            }).toList();
          }

          return Skeletonizer(
            enabled: isLoading,
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: isLoading ? 6 : children.length,
              separatorBuilder: (context, index) => KVerticalSpacer(height: 20),
              itemBuilder: (context, index) {
                if (isLoading) {
                  return const ListTile(
                    leading: CircleAvatar(),
                    title: Text("Loading Name"),
                    subtitle: Text("Loading Email"),
                  );
                }
                return children[index];
              },
            ),
          );
        },
      ),
    );
  }
}
