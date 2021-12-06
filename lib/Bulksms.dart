import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io' show Platform;
import 'bottompin.dart';

class Bulksms extends StatefulWidget {
  @override
  _BulksmsState createState() => _BulksmsState();
}

class _BulksmsState extends State<Bulksms> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _sender = TextEditingController();
  TextEditingController _message = TextEditingController();
  TextEditingController _numbers = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var platform;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _submitdata() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (Platform.isAndroid) {
      setState(() {
        platform = "Android APP";
      });
    } else if (Platform.isIOS) {
      setState(() {
        platform = "IOS APP";
      });
    }

    try {
      String url = 'https://www.voicestelecom.com.ng/api/sendsms/';
      print({
        "sender": _sender.text,
        "recetipient": _numbers.text,
        "message": _message.text,
        "Platform": platform,
        "DND": true
      });
      Response response = await post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
            "sender": _sender.text,
            "recetipient": _numbers.text,
            "message": _message.text,
            "Platform": platform,
            "DND": true
          }));

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        //var responseJson = json.decode(response.body);

        if (this.mounted) {
          setState(() {
            _isLoading = false;
            print(response.body);

            AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.SUCCES,
              title: 'Success',
              desc: 'Message succesfully sent',
              btnOkOnPress: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/home", (route) => false);
              },
              btnOkIcon: Icons.check_circle,
            ).show();
          });
        }
      } else if (response.statusCode == 500) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print(response.body);

        Toast.show("Unable to connect to server currently", context,
            backgroundColor: Colors.green[700],
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      } else if (response.statusCode == 400) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        Map responseJson = json.decode(response.body);
        if (responseJson.containsKey("error")) {
          AwesomeDialog(
            context: context,
            animType: AnimType.BOTTOMSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.ERROR,
            title: 'Oops!',
            desc: responseJson["error"],
            btnCancelOnPress: () {},
            btnCancelText: "ok",
          ).show();
        }
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("Unable to connect to server currently", context,
            backgroundColor: Colors.green[700],
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }
    } finally {
      Client().close();
    }
  }

  void senddata() async {
    await _submitdata();
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();

          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Bottom_pin(
                    title: "Are you sure you want to send this bulk sms",
                    onTap: senddata);
              });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.green[700], Colors.green[700]])),
        child: Text(
          'Send',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Bulk SMS",
            style: TextStyle(color: Colors.black, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          child: ModalProgressHUD(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _sender,
                  keyboardType: TextInputType.text,
                  validator: (String value) {
                    if (value.length == 0) {
                      return "This field is required";
                    }
                    return null;
                  },
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    labelText: "Sender Name",
                    hintStyle: TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 0.1,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(25),
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _message,
                  keyboardType: TextInputType.text,
                  validator: (String value) {
                    if (value.length == 0) {
                      return "This field is required";
                    }
                    return null;
                  },
                  textAlign: TextAlign.left,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: "Message",
                    hintStyle: TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 0.1,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(25),
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _numbers,
                  keyboardType: TextInputType.number,
                  validator: (String value) {
                    if (value.length == 0) {
                      return "This field is required";
                    }
                    return null;
                  },
                  maxLines: 10,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    labelText: "Recipients",
                    hintStyle: TextStyle(fontSize: 16),
                    hintText:
                        "Type or Paste up to 10,000 phone numbers here (080... or 23480...) separate with comma ,NO SPACES!",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 0.1,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(25),
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "Type or Paste up to 10,000 phone numbers here (080... or 23480...) separate with comma ,NO SPACES! i.e 09045232743,08169314399"),
                SizedBox(
                  height: 20,
                ),
                _submitButton(),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
        inAsyncCall: _isLoading,
      )),
    );
  }
}
