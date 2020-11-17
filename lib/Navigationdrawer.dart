import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'UI/colors.dart';

class MyNavigationDrawer extends StatelessWidget {
  final _menutextcolor = TextStyle(
    color: Colors.black,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );
  final _headingtextcolor = TextStyle(
    color: underLineColor,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );
  final _iconcolor = IconThemeData(
    color: Color(0xff757575),
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        SizedBox(
          height: 30.0,
        ),
        ListTile(
          title: Text(
            "INSTA SECTION",
            style: _headingtextcolor,
            textAlign: TextAlign.center,
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed("/insta");
          },
        ),
        Divider(
          thickness: 2.0,
          // color: darkTextColor,
        ),
        ListTile(
          leading: IconTheme(
            data: _iconcolor,
            child: Icon(Icons.info),
          ),
          title: Text("Contact Us", style: _menutextcolor),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed("/contactUs");
          },
        ),
        ListTile(
          leading: IconTheme(
            data: _iconcolor,
            child: Icon(Icons.share),
          ),
          title: Text("Share with Friends", style: _menutextcolor),
          onTap: () {
            // you can modify message if you want.
            Share.share(
                "Hi, I found a awesome app that can\n\n*Download WhatsApp Status, instagram posts and reels* \n\nDownload Your Contact's Status Photos\nDownload Your Contact's Video Status \n\n* Download Link:-  * \n\n 👇👇👇👇👇\n\n https://play.google.com/store/apps/details?id=com.BharatTiwari.captain_helper");
          },
        ),
        ListTile(
          leading: IconTheme(
            data: _iconcolor,
            child: Icon(Icons.rate_review),
          ),
          title: Text("Rate and Review", style: _menutextcolor),
          onTap: () async {
            Navigator.of(context).pop();
            const url =
                'https://play.google.com/store/apps/details?id=com.BharatTiwari.captain_helper';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not open App';
            }
          },
        ),
      ],
    );
  }
}
