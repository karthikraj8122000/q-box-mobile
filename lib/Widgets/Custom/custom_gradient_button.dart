import 'package:flutter/material.dart';

import '../../../../../Widgets/Common/app_text.dart';


Widget buildGradientButton(String name, VoidCallback onPressedCallback) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.pink, Colors.purple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.transparent
      ),
        onPressed: ()=>onPressedCallback,
        child: AppText(text: name, fontSize: 16)),
  );
}

// gradient: const LinearGradient(
// colors: [Colors.pink, Colors.purple],
// begin: Alignment.topLeft,
// end: Alignment.bottomRight,
// ),
//
// CustomButton(
// label: name,
// onPressed: onPressedCallback,
// elevation: 0,
// padding: const EdgeInsets.symmetric(vertical: 20),
// borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
// color: AppColors.buttonBgColor,
//
// );
