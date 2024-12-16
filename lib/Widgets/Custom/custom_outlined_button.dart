import 'package:flutter/material.dart';
import '../../../../../Widgets/Common/app_text.dart';

Widget buildOutlinedButton(String name, IconData icon, VoidCallback onPressedCallback) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 12.0),
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        side: BorderSide(color: Colors.black, width: 1),
        backgroundColor: Colors.transparent,
      ),
      onPressed: onPressedCallback,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(text: name, fontSize: 16, color: Colors.black),
          SizedBox(width: 5),
          Icon(icon, size: 24, color: Colors.black)
        ],
      ),
    ),
  );
}