import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DynamicEMRAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double? titlefontSize;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final Color backgroundColor;
  final double elevation;
  final bool? automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final double? leadingWidth;
  final double? titleSpacing;

  const DynamicEMRAppBar({
    super.key,
    required this.title,
    this.titlefontSize,
    this.centerTitle = false,
    this.actions,
    this.leading,
    this.backgroundColor = AppColors.primary,
    this.elevation = 0,
    this.automaticallyImplyLeading = false,
    this.bottom,
    this.leadingWidth,
    this.titleSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      leadingWidth: leadingWidth,
      title: Text(
        title,
        style: TextStyle(fontSize: titlefontSize ?? 20, color: Colors.white),
      ),
      titleSpacing: titleSpacing,

      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: leading,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
