import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget showmedia(String url, String filepath) {
  return InkWell(
    onTap: () async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    },
    child: CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage(filepath),
      backgroundColor: Colors.white,
    ),
  );
}
