import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonService extends ChangeNotifier{

  presentToast(message,{ gravity }){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity != null ? gravity : ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      // fontSize: 16.0
    );
  }
  emptyCheck(data){
    return data != null && data.length == 0 ? true : false;
  }
}
