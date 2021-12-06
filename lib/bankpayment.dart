import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/constants/color_constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BankPagePayment extends StatefulWidget {
  final String title;

  BankPagePayment({Key key, this.title}) : super(key: key);

  @override
  _BankPagePaymentState createState() => _BankPagePaymentState();
}

class _BankPagePaymentState extends State<BankPagePayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _codeController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<dynamic> account;
  String bank;
  List<dynamic> banks;
  String username;
  //bool _obscureText = true;

  @override
  void initState() {
    filldetails();
    super.initState();
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      account = json.decode(pref.getString("account"));
      bank = pref.getString("bank");
      banks = json.decode(pref.getString("banks"));
      username = pref.getString("username");
    });

    print(banks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Automated Bank Transfer",
              style: TextStyle(color: Colors.black, fontSize: 17.0)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: ModalProgressHUD(
          child: SingleChildScrollView(
              child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(10.0, 20, 10.0, 0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.green.shade200,
                            ),
                            child: Center(
                                child: Text(
                              "AUTOMATED BANK FUNDING \n\nPay into the account below your wallet will be funded automatically",
                              style: TextStyle(color: Colors.black),
                            ))),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              height: 199,
                              width: 344,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: Colors.green[700],
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: SvgPicture.asset(
                                        "assets/svg/ellipse_top_pink.svg",
                                        color: Colors.pink[300]),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: SvgPicture.asset(
                                        "assets/svg/ellipse_bottom_pink.svg",
                                        color: Colors.pink[300]),
                                  ),

                                  Positioned(
                                    left: 29,
                                    bottom: 120,
                                    child: Text(
                                      'ACCOUNT NUMBER',
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kWhiteColor),
                                    ),
                                  ),
                                  Positioned(
                                    left: 29,
                                    bottom: 80,
                                    child: Text(
                                      "${account[0]["accountNumber"]}",
                                      style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: kWhiteColor),
                                    ),
                                  ),
                                  Positioned(
                                    left: 170,
                                    bottom: 82,
                                    child: GestureDetector(
                                      child: Tooltip(
                                        preferBelow: false,
                                        message: "Copy",
                                        child: Icon(
                                          Icons.copy_sharp,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                      onTap: () {
                                        Clipboard.setData(new ClipboardData(
                                            text:
                                                "${account[0]["accountNumber"]}"));
                                        Toast.show(
                                            'Account number copied.', context,
                                            backgroundColor:
                                                Color.fromRGBO(17, 35, 210, 1),
                                            duration: Toast.LENGTH_SHORT,
                                            gravity: Toast.BOTTOM);
                                      },
                                    ),
                                  ),

                                  Positioned(
                                    left: 29,
                                    bottom: 50,
                                    child: Text(
                                      'ACCOUNT NAME',
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kWhiteColor),
                                    ),
                                  ),
                                  Positioned(
                                    left: 29,
                                    bottom: 20,
                                    child: Text(
                                      "$username",
                                      style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: kWhiteColor),
                                    ),
                                  ),
                                  Positioned(
                                    left: 220,
                                    bottom: 50,
                                    child: Text(
                                      '₦25 charge',
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kWhiteColor),
                                    ),
                                  ),
                                  Positioned(
                                    left: 220,
                                    bottom: 20,
                                    child: Text(
                                      "${account[0]["bankName"]}",
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: kWhiteColor),
                                    ),
                                  ),
                                  // Positioned(
                                  //   bottom: 10,
                                  //   left: 26,
                                  //   child: Text(
                                  //     "\nMake transfer to this account to fund your wallet , \nyour username is account name",
                                  //     style: GoogleFonts.inter(
                                  //         fontSize: 12,
                                  //         fontWeight: FontWeight.w600,
                                  //         color: kWhiteColor),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              height: 199,
                              width: 344,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: Colors.green[700],
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: SvgPicture.asset(
                                        "assets/svg/ellipse_top_pink.svg",
                                        color: Colors.green[700]),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: SvgPicture.asset(
                                        "assets/svg/ellipse_bottom_pink.svg",
                                        color: Colors.green[700]),
                                  ),

                                  Positioned(
                                    left: 29,
                                    bottom: 120,
                                    child: Text(
                                      'ACCOUNT NUMBER',
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kWhiteColor),
                                    ),
                                  ),
                                  Positioned(
                                    left: 29,
                                    bottom: 80,
                                    child: Text(
                                      "${account[1]["accountNumber"]}",
                                      style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: kWhiteColor),
                                    ),
                                  ),
                                  Positioned(
                                    left: 170,
                                    bottom: 82,
                                    child: GestureDetector(
                                      child: Tooltip(
                                        preferBelow: false,
                                        message: "Copy",
                                        child: Icon(
                                          Icons.copy_sharp,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                      onTap: () {
                                        Clipboard.setData(new ClipboardData(
                                            text:
                                                "${account[1]["accountNumber"]}"));
                                        Toast.show(
                                            'Account number copied.', context,
                                            backgroundColor:
                                                Color.fromRGBO(17, 35, 210, 1),
                                            duration: Toast.LENGTH_SHORT,
                                            gravity: Toast.BOTTOM);
                                      },
                                    ),
                                  ),

                                  Positioned(
                                    left: 29,
                                    bottom: 50,
                                    child: Text(
                                      'ACCOUNT NAME',
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kWhiteColor),
                                    ),
                                  ),
                                  Positioned(
                                    left: 29,
                                    bottom: 20,
                                    child: Text(
                                      "$username",
                                      style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: kWhiteColor),
                                    ),
                                  ),
                                  Positioned(
                                    left: 220,
                                    bottom: 50,
                                    child: Text(
                                      '₦25 charge',
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kWhiteColor),
                                    ),
                                  ),
                                  Positioned(
                                    left: 220,
                                    bottom: 20,
                                    child: Text(
                                      "${account[1]["bankName"]}",
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: kWhiteColor),
                                    ),
                                  ),
                                  // Positioned(
                                  //   bottom: 10,
                                  //   left: 26,
                                  //   child: Text(
                                  //     "\nMake transfer to this account to fund your wallet , \nyour username is account name",
                                  //     style: GoogleFonts.inter(
                                  //         fontSize: 12,
                                  //         fontWeight: FontWeight.w600,
                                  //         color: kWhiteColor),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
          inAsyncCall: _isLoading,
        ));
  }
}
