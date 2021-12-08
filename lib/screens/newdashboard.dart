import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_share/flutter_share.dart';
import 'login.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Dashboard extends StatefulWidget {
  bool isupgrade;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String username;
  String email;
  String balance;
  String bonus;
  String alert;
  String user_type;
  String notification;
  List<dynamic> account;
  List<dynamic> banners = [];
  String bank;
  bool _isLoading = false;
  AppUpdateInfo _updateInfo;
  bool _flexibleUpdateAvailable = false;
  Timer timer;
  bool mainwallet = true;
  final GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    checkForUpdate();
    filldetails();
    walletupdate1();
    super.initState();
    //timer = Timer.periodic(Duration(seconds: 15), (Timer t) => walletupdate1());
    call_Alert();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  setlogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("token");

    Toast.show("Account logout successfully", context,
        backgroundColor: Colors.green[700],
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
      print(_updateInfo);

      if (_updateInfo.updateAvailable == true) {
        _showUPDATEDialog();
      }
    }).catchError((e) => _showError(e));
  }

  void _showError(dynamic exception) {
    print(exception.toString());
    // _scaffoldstate.currentState
    //     .showSnackBar(SnackBar(content: Text(exception.toString())));
  }

  _launchURL() async {
    const url = 'https://api.whatsapp.com/send?phone=2347069923546';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (this.mounted) {
      setState(() {
        username = pref.getString("username");
        user_type = pref.getString("user_type");
        email = pref.getString("email");
        balance = "₦" + pref.getString("walletb") + ".0";
        bonus = "₦" + pref.getString("bonusb") + ".0";
        alert = pref.getString("alert");
        notification = pref.getString("notification");
        account = json.decode(pref.getString("account"));
        banners = json.decode(pref.getString("banners"));
      });
    }
    print("dgghdf");
    print(banners);
  }

  Future<dynamic> call_Alert() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    print(alert != null);

    if (alert != null && alert != "") {
      _showMyDialog();
      setState(() {
        pref.setString("alert", null);
      });
    }
  }

  Future<void> _showUPDATEDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update App?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'A new version of  voicestelecom app available on playstore'),
                SizedBox(
                  height: 10,
                ),
                Text('Would you like to update?'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('IGNORE'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('LATER'),
              onPressed: () {
                InAppUpdate.startFlexibleUpdate().then((_) {
                  setState(() {
                    _flexibleUpdateAvailable = true;
                  });
                }).catchError((e) => _showError(e));
              },
            ),
            ElevatedButton(
              child: Text('UPDATE NOW'),
              onPressed: () {
                InAppUpdate.performImmediateUpdate()
                    .catchError((e) => _showError(e));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'We Provide Awesome Services at voicestelecom',
      text:
          'We use cutting-edge technology to run our services. Our data delivery and wallet funding is automated, airtime top-up and data purchase are automated and get delivered to you almost instantly. We offer instant recharge of Airtime, Databundle, CableTV (DStv, GOtv & Startimes), Electricity Bill Payment and Airtime to cash.',
      linkUrl: 'https://www.voicestelecom.com.ng?referal=$username',
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert Notification'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Dear $username'),
                SizedBox(
                  height: 10,
                ),
                Text('$alert'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> walletupdate1() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String url = 'https://www.voicestelecom.com.ng/api/user/';

    Response res = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Token ${pref.getString("token")}'
      },
    );
    Map resJson = json.decode(res.body);
    print("wallet update");
    if (this.mounted) {
      setState(() {
        pref.setString("walletb", resJson["user"]["wallet_balance"]);
        pref.setString("bonusb", resJson["user"]["bonus_balance"]);
        pref.setString("user_type", resJson["user"]["user_type"]);
        balance = "₦" + pref.getString("walletb") + ".0";
        bonus = "₦" + pref.getString("bonusb") + ".0";
        user_type = pref.getString("user_type");
      });
    }
  }

  Future<dynamic> walletupdate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String url = 'https://www.voicestelecom.com.ng/api/user/';
    setState(() {
      _isLoading = true;
    });

    Response res = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Token ${pref.getString("token")}'
      },
    );
    Map resJson = json.decode(res.body);
    print(resJson);
    setState(() {
      pref.setString("walletb", resJson["user"]["wallet_balance"]);
      pref.setString("bonusb", resJson["user"]["bonus_balance"]);
      balance = "₦" + pref.getString("walletb") + ".0";
      bonus = "₦" + pref.getString("bonusb") + ".0";
      _isLoading = false;
      Toast.show("Wallet update successfully", context,
          backgroundColor: Colors.green[700],
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    });
  }

  Widget fundbtn(text, color, action) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed("$action");
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: color,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
        ),
        child: Text(
          '$text',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var phonesize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: _social_Account(),
      backgroundColor: Colors.white,
      key: _scaffoldstate,
      drawer: MyAnimation(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: "Poppins",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(
                              "$username",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: "Poppins",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "$user_type",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: "Poppins",
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _scaffoldstate.currentState.openDrawer();
                        },
                        child: SvgPicture.asset(
                          'images/drawer_icon.svg',
                          color: Colors.black,
                        ),
                      )
                    ]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: phonesize.width * 0.45,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.green[400],
                              Colors.green[700],
                            ])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          size: 30,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Wallet Balance",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "$balance",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: phonesize.width * 0.45,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Colors.amber[800],
                              Colors.amber[500],
                            ]),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.wallet_giftcard,
                          size: 30,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Bonus Balance",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "$bonus",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: phonesize.height * 0.005),
            Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          phonesize.height * 0.020),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  phonesize.height * 0.020),
                                              topRight: Radius.circular(
                                                  phonesize.height * 0.020))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Select Payment Method",
                                                    style: TextStyle(
                                                        fontSize:
                                                            phonesize.height *
                                                                0.020,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Icon(
                                                      Icons.cancel_sharp,
                                                      color: Colors.red,
                                                    ))
                                              ]),
                                          SizedBox(
                                              height: phonesize.height * 0.04),
                                          fundbtn("Monnify ATM",
                                              Colors.green.shade200, '/atm'),
                                          SizedBox(
                                              height: phonesize.height * 0.01),
                                          fundbtn("Paystack ATM",
                                              Colors.green.shade200, '/atm2'),
                                          SizedBox(
                                              height: phonesize.height * 0.01),
                                          fundbtn("Automated Bank Transfer",
                                              Colors.pink.shade200, '/bank'),
                                          SizedBox(
                                              height: phonesize.height * 0.01),
                                          fundbtn("Manual Bank Transfer",
                                              Colors.green.shade200, '/bank2'),
                                          SizedBox(
                                              height: phonesize.height * 0.01),
                                          fundbtn(
                                              "Coupon Funding",
                                              Color.fromRGBO(17, 35, 210, 0.5),
                                              '/coupon'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.all(phonesize.height * 0.035),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.05),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                    child: Icon(
                                  Icons.account_balance_wallet,
                                  size: phonesize.height * 0.030,
                                  color: Colors.green[800],
                                ))),
                          ),
                          SizedBox(height: phonesize.height * 0.01),
                          Text(
                            "Fund Wallet",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/history");
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.all(phonesize.height * 0.035),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.05),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                    child: Icon(
                                  Icons.history_rounded,
                                  size: phonesize.height * 0.030,
                                  color: Colors.green[700],
                                ))),
                          ),
                          SizedBox(height: phonesize.height * 0.01),
                          Text(
                            "Transaction",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/wallet");
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.all(phonesize.height * 0.035),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.05),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                    child: Icon(
                                  Icons.credit_card_sharp,
                                  size: phonesize.height * 0.030,
                                  color: Colors.amber[800],
                                ))),
                          ),
                          SizedBox(height: phonesize.height * 0.01),
                          Text(
                            "Wallet Summary",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/setting");
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.all(phonesize.height * 0.035),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.05),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                    child: Icon(
                                  Icons.dashboard_customize,
                                  size: phonesize.height * 0.030,
                                  color: Colors.amber[700],
                                ))),
                          ),
                          SizedBox(height: phonesize.height * 0.01),
                          Text(
                            "More",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                  ],
                )),

            banners.length >= 1
                ? Container(
                    height: phonesize.height * 0.27,
                    child: ListView(
                      children: [
                        CarouselSlider(
                          items: bannerwidget(),

                          //Slider Container properties

                          options: CarouselOptions(
                            height: phonesize.height * 0.20,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),

            SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "What would you like to do ?",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 10, top: 0, bottom: 13, right: 10),
              padding:
                  EdgeInsets.only(left: 12, top: 12, bottom: 12, right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 2,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/datanet");
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.all(phonesize.height * 0.012),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Center(
                                    child: Image.asset(
                                  "images/buydata.png",
                                  height: 30,
                                ))),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Buy Data",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/airtimenet");
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.all(phonesize.height * 0.012),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Center(
                                    child: Image.asset(
                                  "images/buyairtime.png",
                                  height: 30,
                                ))),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Buy Airtime",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/cablename");
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.all(phonesize.height * 0.012),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Center(
                                    child: Image.asset(
                                  "images/cablesub.png",
                                  height: 30,
                                ))),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Cable Sub",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/bill");
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.all(phonesize.height * 0.012),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Center(
                                    child: Image.asset(
                                  "images/bill.png",
                                  height: 30,
                                ))),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Bill Payment",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/airtimefundin");
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.all(phonesize.height * 0.012),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Center(
                                    child: Image.asset(
                                  "images/transfer.png",
                                  height: 30,
                                ))),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Airtime to Cash",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(4.0),
                      //   child: Column(children: [
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.of(context).pushNamed("/recharge");
                      //       },
                      //       child: Container(
                      //           padding:
                      //               EdgeInsets.all(phonesize.height * 0.012),
                      //           decoration: BoxDecoration(
                      //             color: Colors.green[50],
                      //             borderRadius: BorderRadius.all(
                      //               Radius.circular(5),
                      //             ),
                      //           ),
                      //           child: Center(
                      //               child: Image.asset(
                      //             "images/printer.png",
                      //             height: 30,
                      //           ))),
                      //     ),
                      //     SizedBox(
                      //       height: 5,
                      //     ),
                      //     Text(
                      //       "Recharge Pin",
                      //       style: TextStyle(
                      //           color: Colors.grey[500],
                      //           fontFamily: "Poppins",
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //   ]),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(4.0),
                      //   child: Column(children: [
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.of(context).pushNamed("/ResultChecker");
                      //       },
                      //       child: Container(
                      //           padding:
                      //               EdgeInsets.all(phonesize.height * 0.012),
                      //           decoration: BoxDecoration(
                      //             color: Colors.green[50],
                      //             borderRadius: BorderRadius.all(
                      //               Radius.circular(5),
                      //             ),
                      //           ),
                      //           child: Center(
                      //               child: Image.asset(
                      //             "images/resultchecker.png",
                      //             height: 30,
                      //           ))),
                      //     ),
                      //     SizedBox(
                      //       height: 5,
                      //     ),
                      //     Text(
                      //       "Education pin",
                      //       style: TextStyle(
                      //           color: Colors.grey[500],
                      //           fontFamily: "Poppins",
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //   ]),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/referal");
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.all(phonesize.height * 0.012),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Center(
                                    child: Image.asset(
                                  "images/referral.png",
                                  height: 30,
                                ))),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "My Referals",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/bonus");
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.all(phonesize.height * 0.012),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Center(
                                    child: Image.asset(
                                  "images/bonus.png",
                                  height: 30,
                                ))),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Bonus to wallet",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(4.0),
                      //   child: Column(children: [
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.of(context).pushNamed("/bulksms");
                      //       },
                      //       child: Container(
                      //           padding:
                      //               EdgeInsets.all(phonesize.height * 0.012),
                      //           decoration: BoxDecoration(
                      //             color: Colors.green[50],
                      //             borderRadius: BorderRadius.all(
                      //               Radius.circular(5),
                      //             ),
                      //           ),
                      //           child: Center(
                      //               child: Image.asset(
                      //             "images/sms.png",
                      //             height: 30,
                      //           ))),
                      //     ),
                      //     SizedBox(
                      //       height: 5,
                      //     ),
                      //     Text(
                      //       "Bulk SMS",
                      //       style: TextStyle(
                      //           color: Colors.grey[500],
                      //           fontFamily: "Poppins",
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //   ]),
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.all(4.0),
                      //   child: Column(children: [
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.of(context).pushNamed("/transfer");
                      //       },
                      //       child: Container(
                      //           padding:
                      //               EdgeInsets.all(phonesize.height * 0.012),
                      //           decoration: BoxDecoration(
                      //             color: Colors.green[50],
                      //             borderRadius: BorderRadius.all(
                      //               Radius.circular(5),
                      //             ),
                      //           ),
                      //           child: Center(
                      //               child: Image.asset(
                      //             "images/a2c.png",
                      //             height: 30,
                      //           ))),
                      //     ),
                      //     SizedBox(
                      //       height: 5,
                      //     ),
                      //     Text(
                      //       "Transfer to other",
                      //       style: TextStyle(
                      //           color: Colors.grey[500],
                      //           fontFamily: "Poppins",
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //   ]),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ///Topnav
          ],
        ),
      ),
    );
  }

  Widget _social_Account() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.view_list,
      animatedIconTheme: IconThemeData(size: 25),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Icon(Icons.chat_sharp),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onTap: () {
              _launchURL2('https://api.whatsapp.com/send?phone=2347069923546');
            },
            label: 'Whatsapp',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.green),

        SpeedDialChild(
            child: Icon(Icons.share),
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            onTap: () {
              share();
            },
            label: 'Share',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.green)
      ],
    );
  }

  _launchURL2(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Widget> bannerwidget() {
    return banners.map((bannerobject) {
      return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed("${bannerobject['route']}");
        },
        child: Container(
          margin: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: NetworkImage(
                  "https://voicestelecom.com.ng${bannerobject['banner']}"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }).toList();
  }
}
