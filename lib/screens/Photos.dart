import 'dart:io';
import 'package:captain_helper/UI/colors.dart';
import 'package:captain_helper/UI/styles.dart';
import 'package:captain_helper/screens/View_photo.dart';
import 'package:flutter/material.dart';

final Directory _photoDir =
    Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class Photos extends StatefulWidget {
  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos>
    with AutomaticKeepAliveClientMixin<Photos> {
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    if (!Directory("${_photoDir.path}").existsSync()) {
      return Scaffold(
        backgroundColor: backGroundColor,
        body: Container(
          child: Center(
            child: Text(
              "Install WhatsApp\nYour Friend's Status will be Shown here.",
              style: styleW20C,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      var imageList = _photoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".jpg"))
          .toList(growable: false);

      if (imageList.length > 0) {
        return Scaffold(
          backgroundColor: backGroundColor,
          body: GridView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: imageList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              String imgPath = imageList[index];
              return Padding(
                padding: EdgeInsets.all(5.0),
                child: Material(
                  borderRadius: BorderRadius.circular(12.0),
                  elevation: 3.0,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoViewPage(
                          imagePath: imgPath,
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Hero(
                        tag: imgPath,
                        child: Image.file(
                          File(imgPath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: backGroundColor,
          body: Center(
            child: Container(
              child: Text(
                "Sorry, No Images were Found.",
                style: styleW20C,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
    }
  }
}
