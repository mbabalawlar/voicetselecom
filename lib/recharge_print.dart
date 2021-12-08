import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import './screens/validator.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'bottompin.dart';
import 'dart:io' show Platform;
import 'recharge_receipt.dart';
import 'package:flutter/cupertino.dart';
import 'componets/rechargelist.dart';

class RechargeCard extends StatefulWidget {
  final String title;
  final String image;
  final int id;
  final List<dynamic> plan;

  RechargeCard({Key key, this.title, this.image, this.id, this.plan})
      : super(key: key);

  @override
  _RechargeCardState createState() => _RechargeCardState();
}

class _RechargeCardState extends State<RechargeCard> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _networkController = TextEditingController();
  TextEditingController _planController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _amount_to_pay_Controller = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _network;
  String planV;
  String platform;
  Map plans;
  Map networkobject;
  String _planid;
  double amount_to_pay;
  SharedPreferences sharedPreferences;

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

  void initState() {
    loadplan();
    _quantityController.text = '1';
    super.initState();
  }

  void setValue() {
    if (_planController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      setState(() {
        _amount_to_pay_Controller.text =
            (amount_to_pay * int.parse(_quantityController.text)).toString();
      });
    }
  }

  void updateInformation(Map dataplan) {
    print(dataplan);
    setState(() {
      _planController.text = dataplan["text"];
      _planid = dataplan["value"];
      amount_to_pay = dataplan["amount_to_pay"];
    });
  }

  void moveToPlanPage() async {
    final Map dataplan = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => RechargeSlecetionBox(
              plan: plans["${_networkController.text.toLowerCase()}_pin"])),
    );

    updateInformation(dataplan);
    setValue();
  }

  loadplan() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Map resJson = json.decode(sharedPreferences.getString("recharge"));

    if (this.mounted) {
      setState(() {
        plans = resJson;
      });
    }
  }

  Future<dynamic> _RechargeCard(
      String name, String amount, int network, String quantity) async {
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
      String url = 'https://www.voicestelecom.com.ng/api/rechargepin/';
      print(jsonEncode({
        "network": network,
        "amount": amount,
        "quantity": quantity,
        "name": name
      }));
      Response response = await post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
            "network": network,
            "network_amount": amount,
            "quantity": int.parse(quantity),
            "name_on_card": name,
            "Platform": platform,
          }));

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        //var responseJson = json.decode(response.body);

        if (this.mounted) {
          setState(() {
            _isLoading = false;
            print(response.body);

            Map data = json.decode(response.body);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        RechargeReceipt(data: data)),
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

  void databuy() async {
    await _RechargeCard(
        _nameController.text, _planid, _network, _quantityController.text);
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
                        "You are about to generate ${_quantityController.text} piece of recharge card   ₦${_amount_to_pay_Controller.text} ",
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
          'Buy Pin',
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
          title: Text("Buy Recharge Pins",
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
                                          setValue();
                                          setState(() {
                                            _planController.text = "";
                                            _amount_to_pay_Controller.text = "";
                                            networkobject = _networklist[index];
                                            _networkController.text =
                                                _networklist[index]["name"];

                                            _network =
                                                _networklist[index]["id"];
                                          });
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
                    validator: planvalidator,
                    enableInteractiveSelection: false,
                    showCursor: false,
                    readOnly: true,
                    textAlign: TextAlign.left,
                    controller: _planController,
                    onTap: () async {
                      if (_networkController.text.isNotEmpty) {
                        moveToPlanPage();
                      } else {
                        Toast.show("Pls select network provider", context,
                            backgroundColor: Colors.green[700],
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.CENTER);
                      }
                    },
                    // onSaved: (String val) {
                    //   phoneV = val;
                    // },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        // Based on passwordVisible state choose the icon

                        Icons.arrow_drop_down,
                      ),
                      labelText: "Select Amount",
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
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    validator: quantityvalid2,
                    onChanged: (String value) {
                      setValue();
                    },
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      labelText: "Quantity ",
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
                  _amount_to_pay_Controller.text.isNotEmpty
                      ? SizedBox(height: 15)
                      : SizedBox(),
                  _amount_to_pay_Controller.text.isNotEmpty
                      ? TextFormField(
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
                        )
                      : SizedBox(),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    validator: validatename,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      labelText: "Name on Card",
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
