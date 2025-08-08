import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String firstName;
  final String lastName;
  final double avatarRadius;
  final String? profileUrl;
  final bool? useIcon;
  const ProfilePictureWidget({
    super.key,
    required this.avatarRadius,
    required this.profileUrl,
    this.useIcon = false,
    required this.firstName,
    required this.lastName,
  });

  String getInitials(String firstName, String lastName) {
    if (firstName.isEmpty && lastName.isEmpty) return '';
    final firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0] : '';
    return (firstInitial + lastInitial).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = getInitials(firstName, lastName);
    final imageSize = avatarRadius * 2;

    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: BoxBorder.all(color: Colors.white),

        color: profileUrl != null && profileUrl!.trim().isNotEmpty
            ? null
            : AppColors.primary,
      ),
      child: ClipOval(
        child: profileUrl != null && profileUrl!.trim().isNotEmpty
            ? CachedNetworkImage(
                imageUrl: profileUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: BoxBorder.all(color: Colors.white),
                    ),
                    child: Center(
                      child: Icon(Icons.person, color: Colors.white, size: 38),
                    ),
                  ),
                ),
              )
            : Center(
                child: useIcon!
                    ? Icon(Icons.person, color: Colors.white)
                    : Text(
                        initials,
                        style: TextStyle(
                          fontSize: avatarRadius / 2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
      ),
    );
  }
}
