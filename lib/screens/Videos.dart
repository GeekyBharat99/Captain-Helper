import 'dart:io';
import 'package:captain_helper/UI/colors.dart';
import 'package:captain_helper/UI/styles.dart';
import 'package:captain_helper/Video_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

final Directory _videoDir =
    Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  @override
  Widget build(BuildContext context) {
    if (!Directory("${_videoDir.path}").existsSync()) {
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
      return VideoGrid(directory: _videoDir);
    }
  }
}

class VideoGrid extends StatefulWidget {
  final Directory directory;

  const VideoGrid({Key key, this.directory}) : super(key: key);

  @override
  _VideoGridState createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid>
    with AutomaticKeepAliveClientMixin<VideoGrid> {
  bool get wantKeepAlive => true;
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
                            style: styleW20C,
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(
                            str,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
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
                                fontSize: 16.0,
                                color: underLineColor,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          MaterialButton(
                            child: Text(
                              "Close",
                            ),
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
    var videoList = widget.directory
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".mp4"))
        .toList(growable: false);

    if (videoList != null) {
      if (videoList.length > 0) {
        return Scaffold(
          backgroundColor: backGroundColor,
          body: Container(
            child: ListView.builder(
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                String videoPath = videoList[index];
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Material(
                        color: backGroundColor,
                        borderRadius: BorderRadius.circular(12.0),
                        elevation: 3.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Column(
                            children: [
                              Container(
                                height: 350.0,
                                width: 350.0,
                                child: ChewieListItem(
                                  videoPlayerController:
                                      VideoPlayerController.file(
                                    File(videoPath),
                                  ),
                                  looping: false,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.download_outlined,
                                        size: 35.0,
                                        color: blueColor,
                                      ),
                                      onPressed: () async {
                                        _onLoading(true, "");

                                        File originalVideoFile =
                                            File(videoPath);
                                        Directory directory =
                                            await getExternalStorageDirectory();
                                        if (!Directory(
                                                "${directory.path}/Captain Helper/Videos")
                                            .existsSync()) {
                                          Directory(
                                                  "${directory.path}/Captain Helper/Videos")
                                              .createSync(recursive: true);
                                        }
                                        String path = directory.path;
                                        String curDate =
                                            DateTime.now().toString();
                                        String newFileName =
                                            "$path/Captain Helper/Videos/video-$curDate.mp4";

                                        await originalVideoFile
                                            .copy(newFileName);

                                        final result =
                                            await ImageGallerySaver.saveFile(
                                          newFileName,
                                        );

                                        _onLoading(false,
                                            "If video is not available in Gallery,\nyou can find all videos at");
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.share,
                                        size: 35.0,
                                        color: blueColor,
                                      ),
                                      onPressed: () {
                                        Share.shareFiles(
                                          [videoPath],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      } else {
        return Center(
          child: Text(
            "Sorry, No Videos were Found.",
            style: styleW20C,
            textAlign: TextAlign.center,
          ),
        );
      }
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
