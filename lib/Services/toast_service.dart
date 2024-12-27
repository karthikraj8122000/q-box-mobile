import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonService extends ChangeNotifier{

  presentToast(message,{ToastGravity? gravity,Color? backgroundColor,
    Color? textColor}){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor
    );
  }
  emptyCheck(data){
    return data != null && data.length == 0 ? true : false;
  }
}
