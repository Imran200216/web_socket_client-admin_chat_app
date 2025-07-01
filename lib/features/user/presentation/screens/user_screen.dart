import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:socket_io_admin_client/commons/widgets/KVerticalSpacer.dart';
import 'package:socket_io_admin_client/core/constants/app_db_constants.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
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

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(userData['userName'] ?? 'No Name'),
                subtitle: Text("Email: ${userData['userEmail'] ?? ''}"),
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
