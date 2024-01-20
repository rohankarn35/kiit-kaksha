import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget showmedia(String url, String filepath) {
  return InkWell(
    onTap: () async {
      try{
      final Uri uri = Uri.parse(url); // Ensure a valid Uri object
      // if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
  //  /   } 
      }catch(e){
        print(e.toString());
      }
    },
    child: CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage(filepath),
      backgroundColor: Colors.white,
    ),
  );
}
