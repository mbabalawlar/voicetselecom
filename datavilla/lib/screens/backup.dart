import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:datavilla/payment.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    filldetails();
    walletupdate1();
    super.initState();

    call_Alert();
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        username = "Hey," + pref.getString("username");
        email = pref.getString("email");
        balance = "₦" + pref.getString("walletb") + ".0";
        bonus = "₦" + pref.getString("bonusb") + ".0";
        alert = pref.getString("alert");
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
    return ModalProgressHUD(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.indigo[900],
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                child: Text("$username",
                                    style: const TextStyle(
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 20)),
                                padding: EdgeInsets.fromLTRB(5, 10, 5, 1),
                              ),
                              /*    Padding(
                                      child: Text("Wallet: 5,000",
                                          style: const TextStyle(
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Poppins",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0)),
                                      padding: EdgeInsets.fromLTRB(5, 1, 5, 5),
                                    ),*/
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: CircleAvatar(
                            maxRadius: 23,
                            minRadius: 23,
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset(
                              "images/top-up.svg",
                              semanticsLabel: 'Logo',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              padding: EdgeInsets.all(15),
            ),
            Expanded(
              child: getSingleChildScrollView(),
            ),
          ],
        ),
      ),
      inAsyncCall: _isLoading,
    );
  }

  Widget getSingleChildScrollView() {
    String assetElectricity = 'images/electricity.svg';
    String assetRecharge = 'images/recharge.svg';
    String assetTransactions = 'images/transactions.svg';

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                color: Colors.indigo[900],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 8, 10, 7),
                          child: Text("$balance",
                              style: const TextStyle(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "AvenirNext",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15.0)),
                          decoration: new BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(30.0)),
                            color: Colors.white,
                          ),
                          padding:
                              new EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 8.0),
                        ),
                        Text("Wallet balance",
                            style: const TextStyle(
                                color: const Color(0xffffffff),
                                fontFamily: "AvenirNext",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0)),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 8, 10, 7),
                          child: Text("$bonus",
                              style: const TextStyle(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "AvenirNext",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15.0)),
                          decoration: new BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(30.0)),
                            color: Colors.white,
                          ),
                          padding:
                              new EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 8.0),
                        ),
                        Text("referal bonus",
                            style: const TextStyle(
                                color: const Color(0xffffffff),
                                fontFamily: "AvenirNext",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0)),
                      ],
                    ),
                    IconButton(
                        icon: Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          walletupdate();
                        })
                  ],
                ),
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0)),
                  color: Colors.indigo[900],
                ),
                width: MediaQuery.of(context).size.width - 20.0,
                padding: EdgeInsets.fromLTRB(5, 0, 16, 0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Row(
                      // This next line does the trick.
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              CheckoutMethodSelectable(
                                                email: email,
                                              )));
                                },
                                child: CircleAvatar(
                                  maxRadius: 26,
                                  minRadius: 26,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.credit_card,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Padding(
                                child: Text("ATM Funding",
                                    style: const TextStyle(
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "AvenirNext",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 10)),
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed("/bank");
                                },
                                child: CircleAvatar(
                                  maxRadius: 26,
                                  minRadius: 26,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.account_balance_wallet,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Padding(
                                child: Text("Bank Funding",
                                    style: const TextStyle(
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "AvenirNext",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 10)),
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed("/history");
                                },
                                child: CircleAvatar(
                                    maxRadius: 26,
                                    minRadius: 26,
                                    backgroundColor: Colors.white,
                                    child: SvgPicture.asset(
                                      assetTransactions,
                                      semanticsLabel: 'Logo',
                                      color: Colors.indigo[900],
                                      width: 22,
                                      height: 22,
                                    )),
                              ),
                              Padding(
                                child: Text("Transactions",
                                    style: const TextStyle(
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "AvenirNext",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 10)),
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed("/withdraw");
                                },
                                child: CircleAvatar(
                                  maxRadius: 26,
                                  minRadius: 26,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.money_off,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Padding(
                                child: Text("Withdraw",
                                    style: const TextStyle(
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "AvenirNext",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 10)),
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  child: Text(" QUICK PAYMENT",
                      style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                          fontFamily: "AvenirNext",
                          fontStyle: FontStyle.normal,
                          fontSize: 12)),
                  padding: EdgeInsets.fromLTRB(15, 8, 8, 8),
                ),
              ),
              Padding(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("/bill");
                                  },
                                  child: new CircleAvatar(
                                      maxRadius: 28,
                                      minRadius: 28,
                                      child: SvgPicture.asset(
                                        assetElectricity,
                                        semanticsLabel: 'Logo',
                                        width: 24,
                                        height: 24,
                                      ),
                                      backgroundColor: Colors.white),
                                ),
                                padding:
                                    const EdgeInsets.all(1.0), // borde width
                                decoration: new BoxDecoration(
                                  color:
                                      const Color(0x231873e8), // border color
                                  shape: BoxShape.circle,
                                )),
                            Flexible(
                              child: Padding(
                                child: Text("Electricity",
                                    style: const TextStyle(
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "AvenirNext",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12)),
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 15),
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed("/airtimenet");
                                  },
                                  child: new CircleAvatar(
                                      maxRadius: 28,
                                      minRadius: 28,
                                      child: SvgPicture.asset(
                                        assetRecharge,
                                        semanticsLabel: 'Logo',
                                        width: 24,
                                        height: 24,
                                      ),
                                      backgroundColor: Colors.white),
                                ),
                                padding:
                                    const EdgeInsets.all(1.0), // borde width
                                decoration: new BoxDecoration(
                                  color:
                                      const Color(0x231873e8), // border color
                                  shape: BoxShape.circle,
                                )),
                            Flexible(
                              child: Padding(
                                child: Text("Airtime",
                                    style: const TextStyle(
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "AvenirNext",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12)),
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 15),
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("/datanet");
                                  },
                                  child: new CircleAvatar(
                                      maxRadius: 28,
                                      minRadius: 28,
                                      child: Icon(
                                        Icons.wifi,
                                        size: 30,
                                        color: Colors.pink,
                                      ),
                                      backgroundColor: Colors.white),
                                ),
                                padding:
                                    const EdgeInsets.all(1.0), // borde width
                                decoration: new BoxDecoration(
                                  color:
                                      const Color(0x231873e8), // border color
                                  shape: BoxShape.circle,
                                )),
                            Flexible(
                              child: Padding(
                                child: Text("Data",
                                    style: const TextStyle(
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "AvenirNext",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12)),
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 15),
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed("/cablename");
                                  },
                                  child: new CircleAvatar(
                                      maxRadius: 28,
                                      minRadius: 28,
                                      child: Icon(
                                        Icons.tv,
                                        size: 30,
                                        color: Colors.blue,
                                      ),
                                      backgroundColor: Colors.white),
                                ),
                                padding:
                                    const EdgeInsets.all(1.0), // borde width
                                decoration: new BoxDecoration(
                                  color:
                                      const Color(0x231873e8), // border color
                                  shape: BoxShape.circle,
                                )),
                            Flexible(
                              child: Padding(
                                child: Text("Cable Tv",
                                    style: const TextStyle(
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "AvenirNext",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12)),
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 15),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed("/transfer");
                                  },
                                  child: new CircleAvatar(
                                      maxRadius: 28,
                                      minRadius: 28,
                                      child: Icon(
                                        Icons.account_balance_wallet,
                                        size: 30,
                                        color: Colors.green,
                                      ),
                                      backgroundColor: Colors.white),
                                ),
                                padding:
                                    const EdgeInsets.all(1.0), // borde width
                                decoration: new BoxDecoration(
                                  color:
                                      const Color(0x231873e8), // border color
                                  shape: BoxShape.circle,
                                )),
                            Flexible(
                              child: Padding(
                                child: Text("Transfer",
                                    style: const TextStyle(
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "AvenirNext",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12)),
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 15),
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("/bonus");
                                  },
                                  child: new CircleAvatar(
                                      maxRadius: 28,
                                      minRadius: 28,
                                      child: Icon(
                                        Icons.account_balance_wallet,
                                        size: 30,
                                        color: Colors.red,
                                      ),
                                      backgroundColor: Colors.white),
                                ),
                                padding:
                                    const EdgeInsets.all(1.0), // borde width
                                decoration: new BoxDecoration(
                                  color:
                                      const Color(0x231873e8), // border color
                                  shape: BoxShape.circle,
                                )),
                            Flexible(
                              child: Padding(
                                child: Text("Bonus to wallet",
                                    style: const TextStyle(
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "AvenirNext",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12)),
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 15),
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed("/airtimefundin");
                                  },
                                  child: new CircleAvatar(
                                      maxRadius: 28,
                                      minRadius: 28,
                                      child: Icon(
                                        Icons.track_changes,
                                        size: 30,
                                        color: Colors.orange,
                                      ),
                                      backgroundColor: Colors.white),
                                ),
                                padding:
                                    const EdgeInsets.all(1.0), // borde width
                                decoration: new BoxDecoration(
                                  color:
                                      const Color(0x231873e8), // border color
                                  shape: BoxShape.circle,
                                )),
                            Flexible(
                              child: Padding(
                                child: Text("Airtime to Cash",
                                    style: const TextStyle(
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "AvenirNext",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12)),
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 15),
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("/history");
                                  },
                                  child: new CircleAvatar(
                                      maxRadius: 28,
                                      minRadius: 28,
                                      child: Icon(
                                        Icons.history,
                                        size: 30,
                                      ),
                                      backgroundColor: Colors.white),
                                ),
                                padding:
                                    const EdgeInsets.all(1.0), // borde width
                                decoration: new BoxDecoration(
                                  color:
                                      const Color(0x231873e8), // border color
                                  shape: BoxShape.circle,
                                )),
                            Flexible(
                              child: Padding(
                                child: Text("Transaction",
                                    style: const TextStyle(
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "AvenirNext",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12)),
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 15),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed("/wallet");
                                    },
                                    child: new CircleAvatar(
                                        maxRadius: 28,
                                        minRadius: 28,
                                        child: Icon(
                                          Icons.account_balance_wallet,
                                          size: 30,
                                        ),
                                        backgroundColor: Colors.white),
                                  ),
                                  padding:
                                      const EdgeInsets.all(1.0), // borde width
                                  decoration: new BoxDecoration(
                                    color:
                                        const Color(0x231873e8), // border color
                                    shape: BoxShape.circle,
                                  )),
                              Flexible(
                                child: Padding(
                                  child: Text("Wallet Summary",
                                      style: const TextStyle(
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "AvenirNext",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12)),
                                  padding: EdgeInsets.fromLTRB(0, 8, 0, 15),
                                ),
                              )
                            ],
                          ),
                        ]),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(22, 8, 22, 8),
              ),
            ],
          ),
        );
      },
    );
  }
}
