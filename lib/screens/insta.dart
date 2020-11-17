import 'dart:convert';
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:connectivity/connectivity.dart';
import 'package:captain_helper/Video_player.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:captain_helper/UI/colors.dart';
import 'package:captain_helper/UI/styles.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

class Insta extends StatefulWidget {
  @override
  _InstaState createState() => _InstaState();
}

class _InstaState extends State<Insta> {
  TextEditingController urlController = TextEditingController();
  GlobalKey<ScaffoldState> _key = GlobalKey();
  var _isDisabled = true;
  var finalurltoRequest = '';
  var fileUrl = "";
  var isVideo = null;
  var fileName;
  var isLoading = false;
  var isDownloading = false;
  var progress = 0;
  var shareablePath = null;

  final Dio _dio = Dio();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool validateURL(List<String> urls) {
    Pattern pattern = r'^((http(s)?:\/\/)?((w){3}.)?instagram?(\.com)?\/|).+$';
    RegExp regex = RegExp(pattern);

    for (var url in urls) {
      if (!regex.hasMatch(url)) {
        return false;
      }
    }
    return true;
  }

  clearURL() {
    urlController.clear();
    setState(() {
      _isDisabled = true;
    });
  }

  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'its Downloaded.' : 'Download Failed',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }

  Future<Directory> _getDownloadDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        progress = (received / total * 100).toInt();
      });
    }
  }

  Future<void> _startDownload(String savePath) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(fileUrl, savePath,
          onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      await _showNotification(result);
      final resulttt = await ImageGallerySaver.saveFile(
        shareablePath,
      );
    }
  }

  Future<void> _download() async {
    setState(() {
      isDownloading = true;
    });
    final dir = await _getDownloadDirectory();

    final savePath = path.join(dir.path, fileName);
    setState(() {
      shareablePath = savePath;
    });
    await _startDownload(savePath);
  }

  urlFixer() async {
    var url = urlController.text;
    print(url);
    url = url.toString().replaceAll(RegExp(r'\?igshid=.*'), '');
    url = url.toString().replaceAll(RegExp(r'https://instagram.com/'), '');
    setState(() {
      urlController.text =
          url.toString().replaceAll(RegExp(r'\?igshid=.*'), '');
    });
    //Check Internet Connection
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      final bar = snackSample("No Internet!");
      _key.currentState.showSnackBar(bar);
      return;
    }
    try {
      setState(() {
        isLoading = true;
        isDownloading = false;
        progress = 0;
        isVideo = null;
      });
      Response response = await Dio().get("${urlController.text}?__a=1");
      setState(() {
        isVideo = response.data["graphql"]["shortcode_media"]["is_video"];
        if (isVideo) {
          fileUrl = response.data["graphql"]["shortcode_media"]["video_url"];
          fileName =
              'IG-${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.mp4';
        } else {
          fileUrl = response.data["graphql"]["shortcode_media"]["display_url"];
          fileName =
              'IG-${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg';
        }
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      final bar = snackSample("Private, Stories or Invalid URL");
      _key.currentState.showSnackBar(bar);
    }
  }

  void getButton(String url) {
    if (validateURL([url])) {
      setState(() {
        _isDisabled = false;
      });
    } else {
      setState(() {
        _isDisabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: backGroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text("CAPTAIN HELPER", style: style),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 2.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Download Instagram Posts, Reels and IGTV videos.",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Theme(
                  data: ThemeData(
                    primaryColor: underLineColor,
                    accentColor: blueColor,
                  ),
                  child: TextField(
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onChanged: (value) {
                      getButton(value);
                    },
                    cursorColor: blueColor,
                    keyboardType: TextInputType.url,
                    controller: urlController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Paste a Instagram Link..",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: clearURL,
                      ),
                      hintStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      errorStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButton(
                    padding: EdgeInsets.fromLTRB(
                      18.0,
                      10.0,
                      18.0,
                      10.0,
                    ),
                    color: titleColor,
                    onPressed: () async {
                      Map<String, dynamic> result = await SystemChannels
                          .platform
                          .invokeMethod('Clipboard.getData');
                      setState(() {
                        urlController.text = result["text"].toString();
                      });

                      setState(() {
                        getButton(result['text'].toString());
                      });
                    },
                    shape: StadiumBorder(),
                    child: Text(
                      "PASTE",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: backGroundColor,
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    padding: EdgeInsets.fromLTRB(
                      18.0,
                      10.0,
                      18.0,
                      10.0,
                    ),
                    color: titleColor,
                    onPressed: _isDisabled ? null : urlFixer,
                    shape: StadiumBorder(),
                    child: Text(
                      "START",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: backGroundColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3.0,
              ),
              if (isLoading) Center(child: CircularProgressIndicator()),
              if (isVideo != null)
                if (isVideo)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 250.0,
                        width: 350.0,
                        child: ChewieListItem(
                          videoPlayerController:
                              VideoPlayerController.network(fileUrl),
                          looping: false,
                        ),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.fromLTRB(
                          18.0,
                          10.0,
                          18.0,
                          10.0,
                        ),
                        color: titleColor,
                        onPressed: isDownloading ? null : _download,
                        shape: StadiumBorder(),
                        child: Text(
                          "DOWNLOAD",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                              color: backGroundColor,
                            ),
                          ),
                        ),
                      ),
                      if (isDownloading)
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: LinearPercentIndicator(
                            lineHeight: 20.0,
                            percent: progress / 100,
                            center: Text("$progress %"),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: titleColor,
                          ),
                        ),
                      if (progress == 100)
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: RaisedButton(
                                padding: EdgeInsets.fromLTRB(
                                  18.0,
                                  10.0,
                                  18.0,
                                  10.0,
                                ),
                                color: titleColor,
                                onPressed: shareablePath == null
                                    ? null
                                    : () {
                                        Share.shareFiles(
                                          [shareablePath],
                                        );
                                      },
                                shape: StadiumBorder(),
                                child: Text(
                                  "SHARE",
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0,
                                      color: backGroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Saved In Gallery",
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
              if (isVideo != null)
                if (!isVideo)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: ProgressiveImage(
                          height: 250.0,
                          width: 250.0,
                          placeholder: AssetImage('assets/loading.jpg'),
                          thumbnail: AssetImage('assets/loading.jpg'),
                          image: NetworkImage(fileUrl),
                        ),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.fromLTRB(
                          18.0,
                          10.0,
                          18.0,
                          10.0,
                        ),
                        color: titleColor,
                        onPressed: fileUrl == "" ? null : _download,
                        shape: StadiumBorder(),
                        child: Text(
                          "DOWNLOAD",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                              color: backGroundColor,
                            ),
                          ),
                        ),
                      ),
                      if (isDownloading)
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: LinearPercentIndicator(
                            lineHeight: 20.0,
                            percent: progress / 100,
                            center: Text("$progress %"),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: titleColor,
                          ),
                        ),
                      if (progress == 100)
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: RaisedButton(
                                padding: EdgeInsets.fromLTRB(
                                  18.0,
                                  10.0,
                                  18.0,
                                  10.0,
                                ),
                                color: titleColor,
                                onPressed: shareablePath == null
                                    ? null
                                    : () {
                                        Share.shareFiles(
                                          [shareablePath],
                                        );
                                      },
                                shape: StadiumBorder(),
                                child: Text(
                                  "SHARE",
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0,
                                      color: backGroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Text(
                                "Saved In Gallery",
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                    ],
                  )
            ],
          ),
        ],
      ),
    );
  }
}
