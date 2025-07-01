import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_admin_client/commons/widgets/KVerticalSpacer.dart';
import 'package:socket_io_admin_client/core/constants/app_assets_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';

class KAppDrawer extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String? profileImageUrl;
  final VoidCallback onSignOut;

  const KAppDrawer({
    super.key,
    required this.name,
    required this.email,
    required this.role,
    this.profileImageUrl,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: AppColorsConstants.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                SizedBox(
                  height: 140,
                  width: 140,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage:
                        profileImageUrl != null && profileImageUrl!.isNotEmpty
                        ? CachedNetworkImageProvider(profileImageUrl!)
                        : const AssetImage(AppAssetsConstants.profileImg)
                              as ImageProvider,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),

                KVerticalSpacer(height: 16),

                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: AppColorsConstants.blackColor,
                  ),
                ),

                Text(
                  email,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColorsConstants.blackColor,
                  ),
                ),
              ],
            ),
          ),

          KVerticalSpacer(height: 20),

          // Sign Out Tile
          ListTile(
            onTap: onSignOut,
            title: Text("Sign Out"),
            leading: Icon(
              Icons.logout_outlined,
              color: AppColorsConstants.blackColor,
            ),
            titleTextStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: AppColorsConstants.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
