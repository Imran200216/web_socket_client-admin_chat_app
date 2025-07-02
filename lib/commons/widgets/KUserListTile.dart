import 'package:flutter/material.dart';

class KUserListTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String companyRole;
  final String empId;
  final String userUid;
  final VoidCallback onTap;

  const KUserListTile({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.companyRole,
    required this.empId,
    required this.userUid,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      leading: const Icon(Icons.person),
      title: Text(userName.isNotEmpty ? userName : 'No Name'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Email: $userEmail"),
          Text("Role: ${companyRole.isNotEmpty ? companyRole : 'N/A'}"),
          Text("Emp ID: ${empId.isNotEmpty ? empId : 'N/A'}"),
        ],
      ),
      isThreeLine: true,
    );
  }
}
