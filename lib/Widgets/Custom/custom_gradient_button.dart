import 'package:flutter/material.dart';
import '../../../../../Widgets/Common/app_text.dart';

Widget buildGradientButton(String name,IconData icon, VoidCallback onPressedCallback) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(text: name, fontSize: 16,color: Colors.white,),
            SizedBox(width: 5,),
            Icon(icon,size: 24,color: Colors.white,)
          ],
        )),
  );
}
