import 'package:captain_helper/UI/colors.dart';
import 'package:captain_helper/UI/styles.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:google_fonts/google_fonts.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message>
    with AutomaticKeepAliveClientMixin<Message> {
  bool get wantKeepAlive => true;
  TextEditingController numberController = TextEditingController();
  bool _isNumberValid = true;
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('91');

  clearNumber() {
    numberController.clear();
  }

  void _openCountryPickerDialog() => showDialog(
      context: context,
      builder: (context) => Theme(
            data: Theme.of(context).copyWith(
              primaryColor: underLineColor,
              accentColor: blueColor,
            ),
            child: CountryPickerDialog(
              titlePadding: EdgeInsets.all(8.0),
              searchCursorColor: blueColor,
              searchInputDecoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              isSearchable: true,
              title: Text(
                'SELECT YOUR COUNTRY',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              onValuePicked: (Country country) {
                setState(() {
                  _selectedDialogCountry = country;
                });
              },
              priorityList: [
                CountryPickerUtils.getCountryByIsoCode('IN'),
                CountryPickerUtils.getCountryByIsoCode('US'),
                CountryPickerUtils.getCountryByIsoCode('PK'),
                CountryPickerUtils.getCountryByIsoCode('BD'),
                CountryPickerUtils.getCountryByIsoCode('NP'),
              ],
            ),
          ));

  sendMessage() {
    setState(() {
      numberController.text.isEmpty
          ? _isNumberValid = false
          : _isNumberValid = true;
    });
    if (_isNumberValid) {
      FocusScope.of(context).unfocus();
      var finalNumber =
          "${_selectedDialogCountry.phoneCode}" + "${numberController.text}";

      FlutterOpenWhatsapp.sendSingleMessage("$finalNumber", "‎‎‎‎ ‎‎‎");
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Number field must not be blank.",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              content: Text(
                "Please Enter Number, it is required.",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "CLOSE",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: blueColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: ListView(
        children: [
          SizedBox(
            height: 15.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 12.0),
              Text(
                "Send Whatsapp Messages Without Saving Number",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.0),
              Text(
                "SELECT COUNTRY",
                style: styleW20C,
              ),
              Card(
                elevation: 0.0,
                child: ListTile(
                  onTap: _openCountryPickerDialog,
                  title: _buildDialogItem(_selectedDialogCountry),
                  leading: Icon(
                    Icons.arrow_drop_down_outlined,
                    size: 50.0,
                    color: darkTextColor,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(12.0),
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
                    cursorColor: blueColor,
                    keyboardType: TextInputType.number,
                    controller: numberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Type Whatsapp Number Here...",
                      prefix: Text(
                        "+${_selectedDialogCountry.phoneCode}  ",
                        style: TextStyle(color: darkTextColor),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: clearNumber,
                      ),
                      hintStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      errorText:
                          _isNumberValid ? null : "This field is required.",
                      errorStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Center(
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(
                    18.0,
                    10.0,
                    18.0,
                    10.0,
                  ),
                  color: titleColor,
                  onPressed: () {
                    sendMessage();
                    clearNumber();
                  },
                  shape: StadiumBorder(),
                  child: Text(
                    "SEND",
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
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildDialogItem(Country country) => Container(
      child: Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(
            width: 8.0,
          ),
          Text(
            "+${country.phoneCode}(${country.isoCode}) ${country.name}",
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
