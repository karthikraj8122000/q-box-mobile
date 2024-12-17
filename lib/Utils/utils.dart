import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../Widgets/Common/app_text.dart';



// Dialog

Future<bool> showExitPopup(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: AppText(text:'Are you sure?',fontSize: 16,),
      content: AppText(text: 'Do you want to exit the app?',fontSize: 14,),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: AppText(text: 'No',fontSize: 14,),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            SystemNavigator.pop();
          },
          child: AppText(text: 'Yes',fontSize: 14),
        ),
      ],
    ),
  ) ?? false;
}

WillPopCallback  handleWillPop(BuildContext context)  {
  return () async{
    return await showExitPopup(context);
  };
}

