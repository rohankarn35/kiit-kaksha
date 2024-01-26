  import 'package:flutter/material.dart';
import 'package:kiit_kaksha/aboutwidgets/cleardata.dart';
import 'package:kiit_kaksha/branch_select.dart';


void showResetConfirmationDialog(BuildContext context)async {


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Do you really want to clear your data?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await clearLocalData(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BranchSelect()));
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }