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
          title: Text("Contact us"),
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
            height: MediaQuery.of(context).size.height / 4.4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo[800],
                  Colors.indigo[900],
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "elecastlesubng",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
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
                        'Contact Us',
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ListTile(
                        title: Text(
                          "Monday-Saturday  (9:00 AM – 6.00 PM)",
                          style: TextStyle(
                              color: Colors.indigo[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: Text(
                          "Customer care: +2348146319528",
                          style: TextStyle(
                              color: Colors.indigo[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        leading: Icon(
                          Icons.phone,
                          color: Colors.indigo[900],
                          size: 30,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Whatsapp: : +2348146319528",
                          style: TextStyle(
                              color: Colors.indigo[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        leading: Icon(
                          Icons.phone,
                          color: Colors.indigo[900],
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: Text(
                          "Mail: elecastlesubng@gmail.com",
                          style: TextStyle(
                              color: Colors.indigo[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ]))
              ],
            ),
          )
        ]))));
  }
}
