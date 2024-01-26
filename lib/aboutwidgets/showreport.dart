import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

void showReportDialog(BuildContext context) {
  TextEditingController nameController = TextEditingController();
  TextEditingController problemController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Report Problem'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: problemController,
                maxLines: 3,  // Allow multiple lines for problem description
                decoration: InputDecoration(
                  labelText: 'Describe the Problem',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
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
          ElevatedButton(
            onPressed: () async {
              final Email email = Email(
                body: 'Hello there, \n${problemController.text}\n\n\n Name: ${nameController.text}\n\n',
                subject: 'Problem Report from ${nameController.text}',
                recipients: ['contact@rohankarn.com.np'],
                bcc: ['rohankarn35@gmail.com'],
                isHTML: false,
              );

              await FlutterEmailSender.send(email);

              Navigator.of(context).pop();
            },
            child: Text('Submit'),
          ),
        ],
      );
    },
  );
}
