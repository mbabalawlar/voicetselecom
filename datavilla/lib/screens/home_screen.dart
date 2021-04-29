import 'package:datavilla/screens/setting.dart';
import 'package:flutter/material.dart';
import 'dashboard2.dart';
import '../airtimenetwork.dart';
import '../datanetwork.dart';
import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:shared_preferences/shared_preferences.dart';





class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> widgets = [Dashboard(), DataNet(), AirtimeNet(), Setting()];
  void changeIndex(int newIndex) => setState(() => currentIndex = newIndex);
    String username;



  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        username = pref.getString("username");
       
      });
    }
  }

Future<void> share() async {
  await FlutterShare.share(
    title: 'We Provide Awesome Services at elecastlesubng.com',
    text:
        'We use cutting-edge technology to run our services. Our data delivery and wallet funding is automated, airtime top-up and data purchase are automated and get delivered to you almost instantly. We offer instant recharge of Airtime, Databundle, CableTV (DStv, GOtv & Startimes), Electricity Bill Payment and Airtime to cash.',
    linkUrl: 'https://www.elecastlesubng.com/referal=$username',
  );
}

_launchURL() async {
    const url =
        'https://api.whatsapp.com/send?phone=2349031611147';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

Widget _social_Account() {
        return SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22),
          backgroundColor: Colors.indigo,
          visible: true,
          curve: Curves.bounceIn,
          children: [
                // FAB 1
                SpeedDialChild(
                child: Icon(Icons.chat_sharp),
                backgroundColor: Colors.indigo,
                onTap: () {
                  _launchURL();
                },
                label: 'Whatsapp',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.indigo),
                

                SpeedDialChild(
                child: Icon(Icons.chat_bubble),
                backgroundColor: Colors.indigo,
                onTap: () {
                 Navigator.of(context).pushNamed("/supportchat");
                  
                },
                label: 'Live Chat',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.indigo),
               
                SpeedDialChild(
                child: Icon(Icons.share),
                backgroundColor: Colors.indigo,
                onTap: () {
                  share();
                },
                label: 'Share',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.indigo)
          ],
        );
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Scaffold(
                body: widgets[currentIndex],
                floatingActionButton: _social_Account(),
                bottomNavigationBar: bottomNavbar(
                    onTap: changeIndex, currentIndex: currentIndex)),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConnectionStatusBar(),
          ),
        ],
      ),
    );
  }
}

Widget bottomNavbar({@required onTap, @required currentIndex}) {
  return BottomNavigationBar(
    onTap: onTap,
    currentIndex: currentIndex,
    unselectedLabelStyle: TextStyle(fontFamily: 'product-sans'),
    selectedLabelStyle: TextStyle(fontFamily: 'product-sans'),
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black38,
    type: BottomNavigationBarType.fixed,
    items: [
      BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          title: Text(
            'Home',
          )),
      BottomNavigationBarItem(
          icon: Icon(Icons.wifi, color: Colors.grey),
          title: Text(
            'Data',
          )),
      BottomNavigationBarItem(
          icon: Icon(Icons.phone_android, color: Colors.grey),
          title: Text(
            'Airtime',
          )),
      BottomNavigationBarItem(
          icon: Icon(Icons.settings, color: Colors.grey),
          title: Text(
            'Setting',
          ))
    ],
  );
}
