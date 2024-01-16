import 'package:flutter/material.dart';
import 'package:kiit_kaksha/widgets/media.dart';
import 'package:url_launcher/url_launcher.dart';

void showDeveloperDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          width: 330,
          height: 240,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundImage: AssetImage(
                          "assets/myphoto.jpg"),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Rohan Karn', // Replace with the developer's name
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                       showmedia("https://github.com/rohankarn35", "assets/github.png"),
                       SizedBox(width: 8,),
                       showmedia("https://www.instagram.com/rohankarn487/", "assets/insta.jpg"),
                        SizedBox(width: 8,),
                       showmedia("https://www.linkedin.com/in/rohan-karn-725847222/", "assets/linkdein.png"),


                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
