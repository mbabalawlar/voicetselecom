import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("About voicestelecom",
              style: TextStyle(color: Colors.black, fontSize: 17.0)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: <Widget>[
                      Text(
                        'Welcome to  voicestelecom',
                        style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'We offer instant recharge of Airtime, Databundle, CableTV (DStv, GOtv & Startimes), Electricity Bill Payment and Airtime to Cash.',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'We Provide Awesome Services',
                        style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'We use cutting-edge technology to run our services. Our data delivery and wallet funding is automated, airtime top-up and data purchase are automated and get delivered to you almost instantly.We offer instant recharge of Airtime, Databundle, CableTV (DStv, GOtv & Startimes), Electricity Bill Payment and Airtime to cash.',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'About voicestelecom',
                        style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'This is a telecommunication industry playing a major role in distribution, selling affordable and most cheapest data, airtime, Dstv subscription, Gotv subscription, Startimes subscription, Convert Airtime to Cash and Electricity subscription.',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Text(
                        'Certain things are hard; making payments shouldn\'t be one of them.  voicestelecom helps you make payments for services you enjoy right from the comfort of your home or office. The experience of total convenience,fast service delivery and easy payment is just at your fingertips.',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'We are 100% Secure',
                        style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Your e-wallet is the safest, easiest and fastest means of carrying out transactions with us. Your funds are secured with your e-wallet PIN and can be kept for you for as long as you want. You can also withdraw it any time.',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Text(
                        'Our customers are premium to us, hence satisfying them is our topmost priority. Our customer service is just a click away and You get 100% value for any transaction you carry with us.',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ]))
              ],
            ),
          )
        ]))));
  }
}
