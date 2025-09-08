import 'package:flutter/material.dart';

class ProfileMenuCard extends StatelessWidget {
  final String? title, subTitle;
  final VoidCallback? press;
  final IconData? icon;
  final Color iconColor;
  final Color bgColor;

  const ProfileMenuCard({
    super.key,
    this.title,
    this.subTitle,
    this.icon,
    this.press,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: press,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,

                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 17),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? "",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    subTitle ?? "",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF010F07).withValues(alpha: 0.54),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
