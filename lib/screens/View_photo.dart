import 'dart:io';
import 'dart:typed_data';
import 'package:captain_helper/UI/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share/share.dart';

class PhotoViewPage extends StatefulWidget {
  var imagePath;
  PhotoViewPage({this.imagePath});
  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  void _onLoading(bool t, String str) {
    if (t) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Center(
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator()),
                ),
              ],
            );
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimpleDialog(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "😎 Saved in Gallary",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              10.0,
                            ),
                          ),
                          Text(
                            str,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: underLineColor,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(
                            "FileManager > Captain Helper",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          MaterialButton(
                            child: Text("Close"),
                            color: underLineColor,
                            textColor: Colors.white,
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BottomAppBar(
          elevation: 0.0,
          color: Colors.black,
          child: Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 35.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.download_outlined,
                  size: 35.0,
                  color: Colors.white,
                ),
                onPressed: () async {
                  _onLoading(true, "");
                  File originalImageFile1 = File(widget.imagePath);

                  Directory directory = await getExternalStorageDirectory();
                  if (!Directory("${directory.path}/Captain Helper/Images")
                      .existsSync()) {
                    Directory("${directory.path}/Captain Helper/Images")
                        .createSync(recursive: true);
                  }
                  String path = directory.path;
                  String curDate = DateTime.now().toString();
                  String newFileName =
                      "$path/Captain Helper/Images/IMG-$curDate.jpg";

                  await originalImageFile1.copy(newFileName);

                  Uri myUri = Uri.parse(widget.imagePath);
                  File originalImageFile = File.fromUri(myUri);
                  Uint8List bytes;
                  await originalImageFile.readAsBytes().then((value) {
                    bytes = Uint8List.fromList(value);
                  }).catchError((onError) {});
                  final result = await ImageGallerySaver.saveImage(
                      Uint8List.fromList(bytes));
                  _onLoading(false,
                      "If Image is not available in Gallery\nyou can find all images at");
                },
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.share,
                  size: 35.0,
                  color: Colors.white,
                ),
                onPressed: () {
                  Share.shareFiles(
                    [widget.imagePath],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: PhotoView(
          minScale: 0.4,
          maxScale: 2.0,
          initialScale: PhotoViewComputedScale.contained * 0.8,
          imageProvider: FileImage(
            File(widget.imagePath),
          ),
        ),
      ),
    );
  }
}
