import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'constants/color_constant.dart';
import 'models/operation_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:in_app_update/in_app_update.dart';
import '../flutterwavepay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'login.dart';


class Dashboard extends StatefulWidget {
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
    String account;
  String bank;
  bool _isLoading = false;
  AppUpdateInfo _updateInfo;
  bool _flexibleUpdateAvailable = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    checkForUpdate();
    filldetails();
    walletupdate1();
    super.initState();

    call_Alert();
  }


  // Current selected
  int current = 0;
    int current2 = 0;
  // Handle Indicator
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }


  // Handle Indicator
  List<T> map2<T>(List list, Function handler) {
    List<T> result2 = [];
    for (var i = 0; i < list.length; i++) {
      result2.add(handler(i, list[i]));
    }
    return result2;
  }



  setlogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("token");

    Toast.show("Account logout successfully", context,
        backgroundColor: Colors.green[600],
        duration: Toast.LENGTH_SHORT,
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
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(exception.toString())));
  }

  _launchURL() async {
    const url =
        'https://api.whatsapp.com/send?phone=2348034582329&text=hello%20clekkelcoms%20%20I%20av%20want%20%20to%20trade%20bitcoin/giftcrad';
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
        account = pref.getString("account");
      bank = pref.getString("bank");
      });
    }
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
                    'A new version of elecastlesubng app available on playstore'),
                SizedBox(
                  height: 10,
                ),
                Text('Would you like to update?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('IGNORE'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('LATER'),
              onPressed: () {
                InAppUpdate.startFlexibleUpdate().then((_) {
                  setState(() {
                    _flexibleUpdateAvailable = true;
                  });
                }).catchError((e) => _showError(e));
              },
            ),
            FlatButton(
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
    title: 'We Provide Awesome Services at Elecastlesubng.com',
    text:
        'We use cutting-edge technology to run our services. Our data delivery and wallet funding is automated, airtime top-up and data purchase are automated and get delivered to you almost instantly. We offer instant recharge of Airtime, Databundle, CableTV (DStv, GOtv & Startimes), Electricity Bill Payment and Airtime to cash.',
    linkUrl: 'https://www.Elecastlesubng.com?referal=$username',
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
            FlatButton(
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

    String url = 'https://www.elecastlesubng.com/api/user/';

    Response res = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Token ${pref.getString("token")}'
      },
    );
    Map resJson = json.decode(res.body);
    print(resJson);
    if (this.mounted) {
      setState(() {
        pref.setString("walletb", resJson["user"]["wallet_balance"]);
        pref.setString("bonusb", resJson["user"]["bonus_balance"]);
        balance = "₦" + pref.getString("walletb") + ".0";
        bonus = "₦" + pref.getString("bonusb") + ".0";
      });
    }
  }

  Future<dynamic> walletupdate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String url = 'https://www.elecastlesubng.com/api/user/';
    setState(() {
      _isLoading = true;
    });

    Response res = await get(
      url,
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
          backgroundColor: Colors.green,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            DrawerHeader(
              child: Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'images/Elecastletrans2.png',
                  )),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            

            GestureDetector(
              onTap:  () {
                              Navigator.of(context).pushNamed("/pricing");
                            },
              child: Text(
                'Pricing',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          
            SizedBox(
              height: 30,
            ),
              GestureDetector(
              onTap:  () {
                              Navigator.of(context).pushNamed("/about");
                            },
              child:Text(
              'About',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),),
            SizedBox(
              height: 30,
            ),
              GestureDetector(
              onTap:  () {
                              Navigator.of(context).pushNamed("/supportchat");
                            },
              child:Text(
              'Live Support',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),),

             SizedBox(
              height: 30,
            ),
              GestureDetector(
              onTap:  () {
                              Navigator.of(context).pushNamed("/contact");
                            },
              child:Text(
              'Contact Us',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),),
            SizedBox(
              height: 30,
            ),

           
            GestureDetector(
              onTap:  () {
                              Navigator.of(context).pushNamed("/setting");
                            },
              child: Text(
                'Settings',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),

             SizedBox(
              height: 30,
            ),
             GestureDetector(
              onTap:  () {
                              setlogout();
                            },
              child: Text(
              'Log Out',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),),
            SizedBox(
              height: 30,
            ),
            Material(
              borderRadius: BorderRadius.circular(500),
              child: InkWell(
                borderRadius: BorderRadius.circular(500),
                splashColor: Color(0xFF1E1E99),
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF1E1E99),
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 65,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFF1E1E99),
                child: Center(
                  child: Text(
                    'v1.0',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 20,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 8),
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              // Custom AppBar
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Builder(
                      builder: (context) => IconButton(
                        icon: SvgPicture.asset(
                          'assets/svg/drawer_icon.svg',
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    Container(
                      height: 59,
                      width: 59,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage('images/ElecastleApp icn.png'),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // Card Section
              SizedBox(
                height: 25,
              ),

              Padding(
                padding: EdgeInsets.only(left: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Good day, $username',
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: kBlackColor),
                    ),
                    Text(
                      'Package : $user_type',
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: kBlackColor),
                    )
                  ],
                ),
              ),

              Container(
                height: 200,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 16, right: 6),
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 199,
                        width: 344,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: Color(0xFF1E1E99),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              child: SvgPicture.asset(
                                  "assets/svg/ellipse_top_pink.svg"),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: SvgPicture.asset(
                                  "assets/svg/ellipse_bottom_pink.svg"),
                            ),
                            Positioned(
                              left: 29,
                              top: 48,
                              child: Text(
                                'Wallet balance  ',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: kWhiteColor),
                              ),
                            ),
                            Positioned(
                              left: 29,
                              top: 65,
                              child: Text(
                                "$balance",
                                style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: kWhiteColor),
                              ),
                            ),
                            Positioned(
                              right: 21,
                              top: 35,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child:  InkWell(
                                  onTap:(){   Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => FlutterwavePay(
                                          email: email, username: username)));},
                                  child:Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Colors.purple,
                                ),
                              )),
                            ),
                            // Positioned(
                            //   left: 29,
                            //   bottom: 110,
                            //   child: Text(
                            //     'ACCOUNT NAME',
                            //     style: GoogleFonts.inter(
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.w400,
                            //         color: kWhiteColor),
                            //   ),
                            // ),
                            // Positioned(
                            //   left: 29,
                            //   bottom: 90,
                            //   child: Text(
                            //     'musa-dataappp',
                            //     style: GoogleFonts.inter(
                            //         fontSize: 18,
                            //         fontWeight: FontWeight.w700,
                            //         color: kWhiteColor),
                            //   ),
                            // ),
                            Positioned(
                              left: 29,
                              bottom: 80,
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
                              bottom: 50,
                              child: Text(
                                "$account",
                                style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: kWhiteColor),
                              ),
                            ),
                            Positioned(
                                left:170,
                                bottom:52,
                                child: GestureDetector(
                        child: Tooltip(
                          preferBelow: false,
                          message: "Copy",
                          child:Icon(
                                  Icons.copy_sharp,
                                  color: Colors.white,
                                  size: 14,
                                ),
                        ),
                        onTap: () {
                          Clipboard.setData(
                              new ClipboardData(text: "$account"));
                          Toast.show('Account number copied.', context,
                              backgroundColor: Colors.indigo[900],
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        },
                      ),
                                
                                
                                ),
                            Positioned(
                              left: 220,
                              bottom: 80,
                              child: Text(
                                '₦50 charge',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: kWhiteColor),
                              ),
                            ),
                            Positioned(
                              left: 220,
                              bottom: 50,
                              child: Text(
                                "$bank",
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: kWhiteColor),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 26,
                              child: Text(
                                "\nMake transfer to this account to fund your wallet , \nyour username is account name",
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: kWhiteColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 199,
                        width: 344,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: Color(0xFF1E1E99),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              child: SvgPicture.asset(
                                  "assets/svg/ellipse_top_pink.svg"),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: SvgPicture.asset(
                                  "assets/svg/ellipse_bottom_pink.svg"),
                            ),
                            Positioned(
                              left: 29,
                              top: 48,
                              child: Text(
                                'Bonus',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: kWhiteColor),
                              ),
                            ),
                            Positioned(
                              left: 29,
                              top: 65,
                              child: Text(
                                "$bonus",
                                style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: kWhiteColor),
                              ),
                            ),
                            Positioned(
                              right: 21,
                              top: 35,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: InkWell(
                                  onTap:(){ share();},
                                  child:Icon(
                                  Icons.share,
                                  size: 30,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                            ),
                            Positioned(
                              left: 20,
                              bottom: 50,
                              child: Text(
                                "Refer people to elecastle and earn ₦500 \nimmediately the person upgrade his/her account \nto affiliate or topuser",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: kWhiteColor),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              bottom: 20,
                              child: Text(
                                "Referal Username: $username",
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: kWhiteColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),

              // Operation Section
              Padding(
                padding:
                    EdgeInsets.only(left: 16, bottom: 13, top: 29, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Services',
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: kBlackColor),
                    ),
                  
                    Row(
                      children: map<Widget>(
                        datas,
                        (index, selected) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            height: 9,
                            width: 9,
                            margin: EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: current == index
                                    ? kBlueColor
                                    : kTwentyBlueColor),
                          );
                        },
                      ),
                    ),

                    
                  ],
                ),
              ),

              Container(
                height: 123,
                child: ListView.builder(
                  itemCount: datas.length,
                  padding: EdgeInsets.only(left: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          current = index;
                        });
                      },
                      child: OperationCard(
                          operation: datas[index].name,
                          selectedIcon: datas[index].selectedIcon,
                          unselectedIcon: datas[index].unselectedIcon,
                          link:datas[index].link,
                          isSelected: current == index,
                          context: this),
                    );
                  },
                ),
              ),



              // Operation Section
              Padding(
                padding:
                    EdgeInsets.only(left: 16, bottom: 13, top: 29, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Operations',
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: kBlackColor),
                    ),
                  
                    

                     Row(
                      children: map2<Widget>(
                        datas2,
                        (index, selected) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            height: 9,
                            width: 9,
                            margin: EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: current2 == index
                                    ? kBlueColor
                                    : kTwentyBlueColor),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
                Container(
                height: 60,
                child: ListView.builder(
                  itemCount: datas2.length,
                  padding: EdgeInsets.only(left: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          current2 = index;
                        });
                      },
                      child: OperationCard2(
                          operation: datas2[index].name,
                          selectedIcon: datas2[index].selectedIcon,
                          unselectedIcon: datas2[index].unselectedIcon,
                          isSelected: current2 == index,
                          link:datas2[index].link,
                          context: this),
                    );
                  },
                ),
              ),



              

              // Transaction Section
              Padding(
                padding:
                    EdgeInsets.only(left: 16, bottom: 13, top: 29, right: 10),
                child: Text(
                  'Notification',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kBlackColor),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 10, top: 0, bottom: 13, right: 10),
                padding:
                    EdgeInsets.only(left: 24, top: 12, bottom: 12, right: 22),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Text(
                  "$notification",
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kBlackColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class OperationCard extends StatefulWidget {
  final String operation;
   final IconData selectedIcon;
   final IconData unselectedIcon;
  final bool isSelected;
  final String link;
  _DashboardState context;

  OperationCard(
      {this.operation,
      this.selectedIcon,
      this.unselectedIcon,
      this.isSelected,
      this.link,
      this.context});

  @override
  _OperationCardState createState() => _OperationCardState();
}

class _OperationCardState extends State<OperationCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed(widget.link);
      },
          child: Container(
        margin: EdgeInsets.only(right: 16),
        width: 123,
        height: 123,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: kTenBlackColor,
                blurRadius: 10,
                spreadRadius: 5,
                offset: Offset(8.0, 8.0),
              )
            ],
            borderRadius: BorderRadius.circular(15),
            color: widget.isSelected ? kBlueColor : kWhiteColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
             widget.selectedIcon,
              size:40,
              color: widget.isSelected ?Colors.white : kBlueColor 

            ),
            // SvgPicture.asset(
            //     widget.isSelected ? widget.selectedIcon : widget.unselectedIcon),
            SizedBox(
              height: 9,
            ),
            Text(
              widget.operation,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: widget.isSelected ? kWhiteColor : kBlueColor),
            )
          ],
        ),
      ),
    );
  }
}





class OperationCard2 extends StatefulWidget {
  final String operation;
   final IconData selectedIcon;
   final IconData unselectedIcon;
  final bool isSelected;
  final String link;
  _DashboardState context;

  OperationCard2(
      {this.operation,
      this.selectedIcon,
      this.unselectedIcon,
      this.isSelected,
       this.link,
      this.context});

  @override
  _OperationCard2State createState() => _OperationCard2State();
}
class _OperationCard2State extends State<OperationCard2> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed(widget.link);
      },
          child: Container(
        margin: EdgeInsets.only(right: 16),
        width: 60,
        height: 25,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: kTenBlackColor,
                blurRadius: 10,
                spreadRadius: 5,
                offset: Offset(8.0, 8.0),
              )
            ],
            borderRadius: BorderRadius.circular(15),
            color: widget.isSelected ? Colors.indigo[900] : kWhiteColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Icon(
             widget.selectedIcon,
              size:20,
              color: widget.isSelected ?Colors.white : Colors.indigo[900]

            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.operation,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: widget.isSelected ? kWhiteColor : Colors.indigo[900]),
            )
          ],
        ),
      ),
    );
  }
}