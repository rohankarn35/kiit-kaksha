import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class TeacherView extends StatefulWidget {
  final String teachername;

  const TeacherView({Key? key, required this.teachername}) : super(key: key);

  @override
  State<TeacherView> createState() => _TeacherViewState();
}

class _TeacherViewState extends State<TeacherView> {
  late Future<void> apiServiceFuture;

  String? profileurl;
  bool showShareMessage = true;
  

  String? email;
  String? cabinno;
  bool isvalid = true;
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> apiservice() async {
    final url =
        "your_link_here";

    String teachername = widget.teachername;
    teachername = teachername.replaceAll(" ", "");
    if (teachername.length < 2) {
      setState(() {
        isvalid = false;
      });
   
  }



    try {
      // Attempt to make a simple HTTP request to check for internet connectivity
      final response = await http.get(Uri.parse("https://www.google.com"));
      if (response.statusCode == 200) {
        // Continue with the original API call if there is internet connection
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);

          setState(() {
            profileurl = data[teachername]["profileurl"];
            email = data[teachername]["email"];
            cabinno = data[teachername]["cabin"];
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("No Internet Connection"),
                content: Text("Please check your internet connection."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pop(); // Close the current screen as well
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // No internet connection, show dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("No Internet Connection"),
              content: Text("Please check your internet connection."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pop(); // Close the current screen as well
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (isvalid) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("No Internet Connection"),
              content: Text("Please check your internet connection."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pop(); // Close the current screen as well
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (isvalid) {
      apiServiceFuture = apiservice();
    }

     WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSnackBar("Long Press  on the Card to Share");
    });
  }
 void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent, // Change the background color
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
     
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child:
                Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 26),
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: Screenshot(
                controller: _screenshotController,
                child: InkWell(
                  onLongPress: () {
                    _controllscreenshot();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width / 1.15,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                      border: isvalid
                          ? Border.all(color: Colors.green, width: 5)
                          : Border.all(color: Colors.red, width: 5),
                    ),
                    child: FutureBuilder<void>(
                      future: apiServiceFuture,
                      builder: (context, snapshot) {
                        if (!isvalid) {
                          return Center(
                            child: Text(
                              "Teacher's data not available !!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: JumpingDots(
                              color: Colors.white,
                              numberOfDots: 4,
                              animationDuration: Duration(milliseconds: 200),
                            ),
                          );
                        } else {
                          return Center(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                CircleAvatar(
                                  backgroundColor: Colors.greenAccent,
                                  radius: 70,
                                  backgroundImage: NetworkImage(profileurl ??
                                      'https://cdn-icons-png.flaticon.com/512/6596/6596121.png'),
                                ),
                                SizedBox(height: 20),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.teachername,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text("Email: ${email ?? "NA"}"),
                                      SizedBox(height: 10),
                                      Text("Cabin: ${cabinno ?? "NA"}"),
                                      Spacer(),
                                      Text(
                                        "© 2024 KIIT KAKSHA",
                                        style: TextStyle(color: Colors.black26),
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
           
 

          ],
        ),
      ),
    );
  }

  void _controllscreenshot() async {
    final uint8List = await _screenshotController.capture();
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = new File('$directory/screenshot.png');
    imgFile.writeAsBytesSync(uint8List!);

    // Add caption to the shared message
    String sharedMessage = email ?? "";

    // Share the image file along with the caption
    await Share.shareFiles([imgFile.path], text: sharedMessage);

    // Reset the state after sharing
  }
}
