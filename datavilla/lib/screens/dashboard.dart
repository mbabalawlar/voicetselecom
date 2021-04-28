import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:in_app_update/in_app_update.dart';
import '../flutterwavepay.dart';
import 'package:flutter/services.dart';

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
  String img ="https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png";
  String account_id;
  bool _isLoading = false;
  AppUpdateInfo _updateInfo;
  bool _flexibleUpdateAvailable = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool notification_check = false;

  @override
  void initState() {
    checkForUpdate();
    filldetails();
    walletupdate1();
    super.initState();

    call_Alert();
    notification_check_func();
    
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
      print("error");
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        img  = pref.getString("img");
        username = pref.getString("username");
        user_type = pref.getString("user_type");
        email = pref.getString("email");
        balance = "₦" + pref.getString("walletb") + ".0";
        bonus = "₦" + pref.getString("bonusb") + ".0";
        alert = pref.getString("alert");
        notification = pref.getString("notification");
        account_id = pref.getString("account_id");
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
                Text('A new version of Elecastle app available on playstore'),
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

void notification_check_func(){
  print(notification_check);
  if (notification != null){
    
    setState((){
      notification_check = true;
    });
    
  }
  else{
   setState((){
      notification_check = false;
    });
  }

  print(notification_check);
}


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(21),
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 20),
                              Text(
                                "$username",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "What would you do like to do today ?",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                img,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      SendReceiveSwitch(),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => FlutterwavePay(
                                          email: email, username: username)));
                            },
                            //color: Color(0xFFff7bbd),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.credit_card),
                                SizedBox(width: 5),
                                Text("ATM Funding"),
                              ],
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/bank");
                            },
                            color: Colors.white,
                            //color: Color(0xFF4cd1fe),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.branding_watermark),
                                SizedBox(width: 5),
                                Text("Bank Funding"),
                              ],
                            ),
                          ),

                         
                        ],
                      )),
                      SizedBox(height:10),
                      //  Positioned(
                      //           left:10,
                      //           bottom:10,
                      //           child: GestureDetector(
                      //   child: Tooltip(
                      //     preferBelow: false,
                      //     message: "Copy",
                      //     child:Icon(
                      //             Icons.copy_sharp,
                      //             color: Colors.white,
                      //             size: 14,
                      //           ),
                      //   ),
                      //   onTap: () {
                      //     Clipboard.setData(
                      //         new ClipboardData(text: "$account_id"));
                      //     Toast.show('Account_ID copied.', context,
                      //         backgroundColor: Colors.indigo[900],
                      //         duration: Toast.LENGTH_SHORT,
                      //         gravity: Toast.BOTTOM);
                      //   },
                      // ),
                                
                                
                      //           ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Text("ACCOUNT ID: $account_id",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                              
                              SizedBox(width:5),
                              GestureDetector(
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
                              new ClipboardData(text: "$account_id"));
                          Toast.show('Account_ID copied.', context,
                              backgroundColor: Colors.indigo[900],
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        },
                      ),


                            ]
                          )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Services",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed("/datanet");
                              },
                              child: iconCircle(
                                  Color(0xFFff7bbd), "Buy Data", Icons.wifi)),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/airtimenet");
                            },
                            child: iconCircle(Color(0xFF6db4e0), "Buy Airtime",
                                Icons.phone_android),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/cablename");
                            },
                            child: iconCircle(
                                Color(0xFFc4a1ff), "Cable sub.", Icons.live_tv),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/bill");
                            },
                            child: iconCircle(Color(0xFF4cd1fe),
                                "Pay Elecricity", Icons.lightbulb_outline),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/history");
                            },
                            child: iconCircle(
                                Color(0xFF93dfdf), " History", Icons.history),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/referal");
                            },
                            child: iconCircle(Color(0xFF93dfdf), " My referral",
                                Icons.supervised_user_circle),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/transfer");
                            },
                            child: iconCircle(Color(0xFFfeb0d8), "Transfer",
                                Icons.attach_money),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/withdraw");
                            },
                            child: iconCircle(Color(0xFF5788f1), "Withdraw",
                                Icons.credit_card),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/wallet");
                            },
                            child: iconCircle(Color(0xFFfeb885),
                                "Wallet Summary", Icons.store),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/bonus");
                            },
                            child: iconCircle(Color(0xFFfeb885),
                                "Bonus to wallet", Icons.money_off),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/airtimefundin");
                            },
                            child: iconCircle(Color(0xFFfeb885),
                                "Airtime Funding", Icons.track_changes),
                          ),

                         
                        ],
                      ),

                        SizedBox(
                        height: 20,
                      ),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                         
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/coupon");
                            },
                            child: iconCircle(Color(0xFFfeb885),
                                "Coupon Payment", Icons.monetization_on_sharp
                          ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                notification_check? Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Notification",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            elevation: 15,
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text("$notification"),
                            ),
                          )
                        ])):SizedBox(),
              ],
            ),
          ],
        ),
      ),
      inAsyncCall: _isLoading,
    );
  }

  Widget SendReceiveSwitch() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(21.0),
      child: Column(
        children: <Widget>[
          Center(
              child: Text(
            "Current Package : $user_type ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "$balance",
                      style: TextStyle(
                          color: Colors.indigo[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      "Wallet ",
                      style: TextStyle(
                        color: Colors.indigo[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  walletupdate();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF5788f1),
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFF5788f1)],
                      stops: [0, 0.5],
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                    ),
                  ),
                  child: Icon(
                    Icons.refresh,
                    size: 30,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "$bonus",
                      style: TextStyle(
                          color: Colors.indigo[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      " Bonus ",
                      style: TextStyle(
                        color: Colors.indigo[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


Widget iconCircle(Color color, String text, IconData icon) {
  return Column(
    children: <Widget>[
      Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          gradient: LinearGradient(
            colors: [Colors.white, color],
            stops: [0, 0.5],
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
          ),
        ),
        child: Icon(
          icon,
          size: 40,
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        text,
        style: TextStyle(
            color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold),
      )
    ],
  );
}
