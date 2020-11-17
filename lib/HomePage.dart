import 'package:captain_helper/Navigationdrawer.dart';
import 'package:captain_helper/UI/colors.dart';
import 'package:captain_helper/UI/styles.dart';
import 'package:captain_helper/screens/Message.dart';
import 'package:captain_helper/screens/Photos.dart';
import 'package:captain_helper/screens/Videos.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: MyNavigationDrawer(),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text("CAPTAIN HELPER", style: style),
        bottom: TabBar(
          unselectedLabelColor: darkTextColor,
          indicatorColor: underLineColor,
          indicatorWeight: 3.5,
          labelColor: blueColor,
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                "MESSAGE",
                style: style1,
              ),
            ),
            Tab(
              child: Text(
                "PHOTOS",
                style: style1,
              ),
            ),
            Tab(
              child: Text(
                "VIDEOS",
                style: style1,
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Message(),
          Photos(),
          Videos(),
        ],
      ),
    );
  }
}
