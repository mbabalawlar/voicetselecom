import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ContactPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactPageState();
  }
}

class _ContactPageState extends State<ContactPage> {
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
          title: Text("Contact voicestelecom",
              style: TextStyle(color: Colors.black, fontSize: 17.0)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.of(context).pushNamed("/supportchat");
        //   },
        //   child: Icon(Icons.message),
        // ),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.green[700],
                          Colors.green[700],
                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: <Widget>[
                      Text(
                        'Contact Us',
                        style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(children: [
                        Icon(
                          Icons.timelapse,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "customer care service......8am to 10pm",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "+2347069923546",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "lagos, Nigeria",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        Icon(
                          Icons.mail,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "support@voicestelecom.com.ng",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ]),
                    ]))
              ],
            ),
          )
        ]))));
  }
}
