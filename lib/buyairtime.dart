import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import './screens/validator.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'airtimereceipt.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'bottompin.dart';
import 'dart:io' show Platform;
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

class BuyAirtime extends StatefulWidget {
  final String title;
  final String image;
  final int id;

  BuyAirtime({Key key, this.title, this.image, this.id}) : super(key: key);

  @override
  _BuyAirtimeState createState() => _BuyAirtimeState();
}

class _BuyAirtimeState extends State<BuyAirtime> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _networkController = TextEditingController();
  TextEditingController _airtimetypeController = TextEditingController();
  TextEditingController _amount_to_pay_Controller = TextEditingController();

  TextEditingController _amountController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String phoneV;
  String networkV;
  String amountV;
  bool checkedValue = false;
  String platform;
  SharedPreferences sharedPreferences;
  List<dynamic> previousphones;
  int _network;
  Map networkobject;
  Map topuppercent;
  List<Map> _networklist = [
    {
      "name": "MTN",
      "logo": "assets/mtn.jpg",
      "id": 1,
    },
    {
      "name": "GLO",
      "logo": "assets/glo.jpg",
      "id": 2,
    },
    {
      "name": "AIRTEL",
      "logo": "assets/airtel.jpg",
      "id": 4,
    },
    {
      "name": "9MOBILE",
      "logo": "assets/9mobile.jpg",
      "id": 3,
    }
  ];

  List<Map> _airtimetype = [
    {"name": "VTU", "value": "VTU"},
    {"name": "Share and Sell", "value": "Share and Sell"}
  ];

  @override
  void initState() {
    super.initState();
    filldetails();
    getpreviousphones();
  }

  Future<dynamic> filldetails() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var topuppercentjson =
        json.decode(sharedPreferences.getString("topuppercentage"));

    setState(() {
      topuppercent = topuppercentjson;
    });
  }

  setpreviousphones(previousphone) {
    print(previousphone);
    setState(() {
      networkobject = previousphone;
      _networkController.text = previousphone["name"];
      _network = previousphone["id"];
      _phoneController.text = previousphone["phone"];
    });
  }

  getpreviousphones() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("storedphoneairtime") != null) {
      var storedphoneairtime =
          json.decode(sharedPreferences.getString("storedphoneairtime"));
      print(storedphoneairtime);

      setState(() {
        previousphones = storedphoneairtime;
      });
    }
  }

  savecontact() async {
    sharedPreferences = await SharedPreferences.getInstance();
    networkobject["phone"] = _phoneController.text;
    var net = networkobject;
    print(net);

    if (sharedPreferences.getString("storedphoneairtime") != null) {
      var storedphoneairtime =
          json.decode(sharedPreferences.getString("storedphoneairtime"));

      var existingList = storedphoneairtime
          .takeWhile((i) => i["phone"] != _phoneController.text)
          .toList();

      if (existingList.length >= 5) {
        var lastfour =
            existingList.getRange(existingList.length - 4, existingList.length);
        var netlist = [...lastfour, net];
        sharedPreferences.setString("storedphoneairtime", json.encode(netlist));
      } else {
        var netlist = [...existingList, net];
        sharedPreferences.setString("storedphoneairtime", json.encode(netlist));
      }
    } else {
      var netlist = [];
      netlist.add(net);
      print(netlist);
      sharedPreferences.setString("storedphoneairtime", json.encode(netlist));
    }

    getpreviousphones();
  }

  final FlutterContactPicker _contactPicker = new FlutterContactPicker();

  void setValue() {
    if (_networkController.text.isNotEmpty &&
        _airtimetypeController.text.isNotEmpty &&
        _amountController.text.isNotEmpty) {
      var percent =
          topuppercent[_networkController.text][_airtimetypeController.text];

      var amount_v = int.parse(_amountController.text);

      setState(() {
        _amount_to_pay_Controller.text =
            (amount_v - amount_v * (100 - percent) ~/ 100).toString();
      });
    }
  }

  Future<dynamic> _BuyAirtime(
      String phone, String amount, int network, String airtime_type) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });

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
      String url = 'https://www.voicestelecom.com.ng/api/topup/';
      print({
        "network": network,
        "amount": amount,
        "mobile_number": phone,
        "Ported_number": checkedValue,
        "Platform": platform,
        "airtime_type": airtime_type
      });
      Response response = await post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
            "network": network,
            "amount": amount,
            "mobile_number": phone,
            "Ported_number": checkedValue,
            "Platform": platform,
            "airtime_type": airtime_type
          }));

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        savecontact();

        if (this.mounted) {
          setState(() {
            _isLoading = false;
            print(response.body);

            Map data = json.decode(response.body);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        AirtimeReceipt(data: data)),
                (Route<dynamic> route) => false);
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
            desc: responseJson["error"][0],
            btnCancelOnPress: () {},
            btnCancelText: "ok",
          ).show();
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Color.fromRGBO(184, 9, 146,1),duration: Toast.LENGTH_SHORT, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

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

  Widget _entryField(String title, myicon, mykey, String inputvalue,
      TextEditingController controll,
      {Function valid, Function onchangefunc, bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              obscureText: isPassword,
              controller: controll,
              validator: valid,
              keyboardType: mykey,
              onSaved: (String val) {
                inputvalue = val;
              },
              onChanged: onchangefunc,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  icon: Icon(myicon),
                  filled: true)),
        ],
      ),
    );
  }

  void databuy() async {
    await _BuyAirtime(_phoneController.text, _amountController.text, _network,
        _airtimetypeController.text);
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
                    title:
                        "You are about to pucharse  ₦${_amountController.text} Airtime for ${_phoneController.text}",
                    onTap: databuy);
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
          'Buy Airtime',
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
          title: Text("Airtime Topup",
              style: TextStyle(color: Colors.black, fontSize: 17.0)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: ModalProgressHUD(
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  previousphones != null
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.timelapse,
                                    color: Colors.green[700],
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Recent Beneficiary",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: previousphones.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          setpreviousphones(
                                              previousphones[index]);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: previousphones[
                                                            index]['name'] ==
                                                        "MTN"
                                                    ? Colors.green.shade100
                                                    : previousphones[index]
                                                                ['name'] ==
                                                            "AIRTEL"
                                                        ? Colors.red.shade100
                                                        : previousphones[index]
                                                                    ['name'] ==
                                                                "GLO"
                                                            ? Colors
                                                                .green.shade100
                                                            : Colors.black12,
                                                radius: 30.0,
                                                child: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      previousphones[index]
                                                          ['logo']),
                                                  radius: 20.0,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                previousphones[index]['phone'],
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                )),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    showCursor: true,
                    readOnly: true,
                    validator: networkvalidator,
                    textAlign: TextAlign.left,
                    controller: _networkController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        // Based on passwordVisible state choose the icon

                        Icons.arrow_drop_down,
                      ),
                      labelText: "Select Network",
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
                    onTap: () {
                      showModalBottomSheet(
                        elevation: 0,
                        context: context,
                        backgroundColor: Colors.transparent,
                        clipBehavior: Clip.hardEdge,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            // height: MediaQuery.of(context).size.height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      "Select Network Provider",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade600),
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.shade500,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _networklist.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            networkobject = _networklist[index];
                                            _networkController.text =
                                                _networklist[index]["name"];

                                            _network =
                                                _networklist[index]["id"];
                                          });
                                          setValue();
                                          Navigator.of(context).pop();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                  color: _networkController
                                                              .text ==
                                                          _networklist[index]
                                                              ["name"]
                                                      ? Colors.red.shade300
                                                      : Colors.grey.shade300),
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      _networklist[index]
                                                          ["logo"]),
                                                  radius: 30.0,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  _networklist[index]["name"],
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 15),

                  TextFormField(
                    showCursor: true,
                    readOnly: true,
                    validator: airtimtypevalidator,
                    textAlign: TextAlign.left,
                    controller: _airtimetypeController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        // Based on passwordVisible state choose the icon

                        Icons.arrow_drop_down,
                      ),
                      labelText: "Airtime Type",
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
                    onTap: () {
                      showModalBottomSheet(
                        elevation: 0,
                        context: context,
                        backgroundColor: Colors.transparent,
                        clipBehavior: Clip.hardEdge,
                        builder: (BuildContext context) {
                          return Container(
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            // height: MediaQuery.of(context).size.height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      "Select Airtime Type",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade600),
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.shade500,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _airtimetype.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _airtimetypeController.text =
                                                _airtimetype[index]["name"];
                                          });

                                          setValue();
                                          Navigator.of(context).pop();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                  color: _airtimetypeController
                                                              .text ==
                                                          _airtimetype[index]
                                                              ["name"]
                                                      ? Colors.red.shade300
                                                      : Colors.grey.shade300),
                                            ),
                                            child: Text(
                                              _airtimetype[index]["name"],
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(height: 15),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    validator: validateAmount,
                    onChanged: (String value) {
                      setValue();
                    },
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      labelText: "Amount ",
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

                  SizedBox(height: 15),
                  TextFormField(
                    validator: validateMobile,
                    textAlign: TextAlign.left,
                    controller: _phoneController,
                    onSaved: (String val) {
                      phoneV = val;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon

                          Icons.contact_mail,

                          color: Colors.grey,
                        ),
                        onPressed: () async {
                          Contact contact =
                              await _contactPicker.selectContact();
                          print("selected contact");
                          var phoneget = contact.phoneNumbers[0]
                              .replaceAll(" ", "")
                              .replaceAll("-", "")
                              .replaceAll("(", "")
                              .replaceAll(")", "")
                              .replaceAll("+234", "0");
                          print(phoneget);
                          print(contact.phoneNumbers[0]);
                          setState(() {
                            _phoneController.text = phoneget;
                          });
                        },
                      ),
                      labelText: "Phone",
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

                  SizedBox(height: 15),
                  TextFormField(
                    showCursor: true,
                    readOnly: true,
                    controller: _amount_to_pay_Controller,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      labelText: "Amount to Pay",
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
                  // _buydatafieldsWidget(),
                  SizedBox(
                    height: 15,
                  ),
                  CheckboxListTile(
                    title: Text("Bypass number validator for ported number"),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
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
          )),
          inAsyncCall: _isLoading,
        ));
  }
}
