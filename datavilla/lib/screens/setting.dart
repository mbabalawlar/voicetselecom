import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:toast/toast.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String username;
  String email;
  String phone;

  @override
  void initState() {
    details();
    super.initState();
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

  Future<dynamic> details() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
      email = pref.getString("email");
      phone = pref.getString("phone");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: 'Account',
            tiles: [
              SettingsTile(
                  title: '$username', leading: Icon(Icons.verified_user)),
              SettingsTile(title: '$phone', leading: Icon(Icons.phone)),
              SettingsTile(title: '$email', leading: Icon(Icons.email)),
              SettingsTile(
                  title: 'My Referals',
                  leading: Icon(Icons.supervised_user_circle),
                  onTap: () {
                    Navigator.of(context).pushNamed("/referal");
                  }),
            ],
          ),
          SettingsSection(
            title: 'Security',
            tiles: [
              SettingsTile(
                  title: 'Change password',
                  leading: Icon(Icons.lock),
                  onTap: () {
                    Navigator.of(context).pushNamed("/changepassword");
                  }),
               SettingsTile(
                  title: 'KYC',
                  leading: Icon(Icons.face_sharp),
                  onTap: () {
                    Navigator.of(context).pushNamed("/kyc");
                  }),
                SettingsTile(
                  title: 'Pin Mangement',
                  leading: Icon(Icons.lock),
                  onTap: () {
                    Navigator.of(context).pushNamed("/pin");
                  }),
              SettingsTile(
                title: 'Sign out',
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  setlogout();
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'About',
            tiles: [
              SettingsTile(
                  title: 'About Elecastle',
                  leading: Icon(Icons.description),
                  onTap: () {
                    Navigator.of(context).pushNamed("/about");
                  }),
              SettingsTile(
                  title: 'Contact Us',
                  leading: Icon(Icons.contact_mail),
                  onTap: () {
                    Navigator.of(context).pushNamed("/contact");
                  }),
                 SettingsTile(
                  title: 'Visit Website',
                  leading: Icon(Icons.open_in_browser),
                  onTap: () {
                    Navigator.of(context).pushNamed("/website");
                  }),
            ],
          )
        ],
      ),
    );
  }
}
