import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUSPage extends StatefulWidget {
  @override
  _ContactUSPageState createState() => _ContactUSPageState();
}

class _ContactUSPageState extends State<ContactUSPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Contact Us",
        ),
      ),
      backgroundColor: Colors.teal,
      body: ListView(
        children: [
          SizedBox(
            height: 8.0,
          ),
          ContactUs(
            cardColor: Colors.white,
            textColor: Colors.teal.shade900,
            logo: NetworkImage(
                "https://instagram.fbho4-2.fna.fbcdn.net/v/t51.2885-19/s150x150/79389207_562047124630450_4369539872562610176_n.jpg?_nc_ht=instagram.fbho4-2.fna.fbcdn.net&_nc_ohc=zPMZkDmNMJ8AX9cJXDl&oh=13033b8ef38d64626a98c0eab7687fd6&oe=5FB84647"),
            email: 'bharattiwari9926@gmail.com',
            companyName: 'Bharat Tiwari',
            companyColor: Colors.teal.shade100,
            website: 'https://bharattiwari.netlify.app/',
            githubUserName: 'GeekyBharat99',
            linkedinURL: 'https://www.linkedin.com/in/bharat-tiwari-301392176',
            tagLine: 'Flutter and Full Stack Developer',
            taglineColor: Colors.teal.shade100,
            twitterHandle: 'BharatT92504136',
            instagram: 'geeky_bharat99',
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Text(
                "Designed and Developed with ❤ By Bharat Tiwari",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
