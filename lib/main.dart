import 'package:app_settings/app_settings.dart';
import 'package:captain_helper/HomePage.dart';
import 'package:captain_helper/UI/colors.dart';
import 'package:captain_helper/screens/contact.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/insta.dart';

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with AutomaticKeepAliveClientMixin<MyApp> {
  bool get wantKeepAlive => true;
  var isPermissionGranted = true;
  var isPermanentlyDenied = false;

  permission() async {
    if (await Permission.storage.request().isGranted == false) {
      // Either the permission was already granted before or the user just granted it.
      setState(() {
        isPermissionGranted = false;
      });
    }
    if (await Permission.storage.isPermanentlyDenied == true) {
      setState(() {
        isPermanentlyDenied = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    permission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Captain Helper",
      theme: ThemeData(
        primaryColor: backGroundColor,
        accentColor: underLineColor,
        bottomAppBarColor: backGroundColor,
      ),
      home: isPermissionGranted == true
          ? HomePage()
          : Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isPermanentlyDenied == false
                      ? Text(
                          "We Need Storage Permission to Download whatsapp status, Please allow us, and completely close and Restart the app.",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          "You Permanently Denied The Permission,\nWe Need Storage Permission to Download whatsapp status, Please allow us.\nclick on open setting, then :-\n(1) Click On permissions and check the checkbox of storage \n(2) Completely close and Restart the app.",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                  SizedBox(
                    height: 20.0,
                  ),
                  isPermanentlyDenied == false
                      ? RaisedButton(
                          shape: StadiumBorder(),
                          onPressed: () {
                            permission();
                          },
                          child: Text(
                            "Allow Permission",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        )
                      : RaisedButton(
                          shape: StadiumBorder(),
                          onPressed: () {
                            AppSettings.openAppSettings();
                          },
                          child: Text(
                            "Open Setting",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
      routes: <String, WidgetBuilder>{
        "/contactUs": (BuildContext context) => ContactUSPage(),
        "/insta": (BuildContext context) => Insta(),
      },
    );
  }
}
