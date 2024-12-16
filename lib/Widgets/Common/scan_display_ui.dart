
import 'package:flutter/material.dart';

Widget buildScanAndDisplayUI(BuildContext context, String name, String labelText, String labelText2, String barcodeValue, Function() onTap) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 20),
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: name == 'Qbox'
                  ? const AssetImage('assets/qr_box.png')
                  : const AssetImage('assets/qr_food.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Text(labelText, style: const TextStyle(color: Colors.deepPurple)),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 80.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(labelText2, style: const TextStyle(color: Colors.deepPurple, fontSize: 18, fontWeight: FontWeight.bold)),
            Text(barcodeValue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ],
  );
}