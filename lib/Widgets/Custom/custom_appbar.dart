import 'package:flutter/material.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';

class CustomAppbar extends StatefulWidget {
  final title;
  const CustomAppbar({super.key,required this.title});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.mintGreen,
      title: widget.title,
    );
  }
}
