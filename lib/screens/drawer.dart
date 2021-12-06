import 'newdashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'login.dart';

class MyDrawer extends AnimatedWidget {
  MyDrawer({Key key, Animation<double> animation, String username})
      : super(key: key, listenable: animation);

  setlogout(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("token");

    Toast.show("Account logout successfully", context,
        backgroundColor: Colors.green[700],
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.CENTER);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return Container(
        color: Colors.green[900],
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
                height: 100,
                child: Image.asset(
                  'images/voicestelecom.png',
                  width: MediaQuery.of(context).size.width * 0.5,
                )),
            // ListTile(
            //   leading: CircleAvatar(
            //     radius: 30,
            //     backgroundImage: NetworkImage(
            //       "https://www.pngkey.com/png/detail/114-1149878_setting-user-avatar-in-specific-size-without-breaking.png",
            //     ),
            //   ),
            //   title: Text(
            //     'Welcome musa',
            //     style: TextStyle(
            //       fontFamily: 'Futura',
            //       fontSize: 17,
            //       color: const Color(0xffffffff),
            //       letterSpacing: 0.323,
            //       fontWeight: FontWeight.w700,
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.list, color: Colors.white),
                        title: Text(
                          "Pricing",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/pricing");
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings, color: Colors.white),
                        title: Text(
                          "Settings",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/setting");
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.white),
                        title: Text(
                          "About us",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/about");
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.contact_phone, color: Colors.white),
                        title: Text(
                          "Contact Us",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/contact");
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.chat, color: Colors.white),
                        title: Text(
                          "Log Complaint",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/complain");
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.web, color: Colors.white),
                        title: Text(
                          "Affilliate Website",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/rsite");
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.upgrade, color: Colors.white),
                        title: Text(
                          "Upgrade package",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/upgrade");
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.money, color: Colors.white),
                        title: Text(
                          "Airtime to Cash",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/airtimefundin");
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout, color: Colors.white),
                        title: Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          setlogout(context);
                        },
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.navigate_before, color: Colors.white),
                        title: Text(
                          "Close",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(children: [
                      Positioned(
                        left: MediaQuery.of(context).size.width -
                            MediaQuery.of(context).size.width / animation.value,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height / 1.3,
                                child: AbsorbPointer(child: Dashboard())),
                          ),
                        ),
                      ),
                    ]),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
