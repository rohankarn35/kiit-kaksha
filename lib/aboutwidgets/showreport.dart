  import 'package:flutter/material.dart';

void showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report Problem'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please mail your problem to contact@rohankarn.com.np'),
            

              SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
