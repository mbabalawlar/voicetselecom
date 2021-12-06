import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import './screens/validator.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'billreceipt.dart';
import 'bottompin.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'componets/disco.dart';

class ElectPayment extends StatefulWidget {
  final String title;
  final String image;
  final int id;

  ElectPayment({Key key, this.title, this.image, this.id}) : super(key: key);

  @override
  _ElectPaymentState createState() => _ElectPaymentState();
}

class _ElectPaymentState extends State<ElectPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _discoController = TextEditingController();
  TextEditingController _meterController = TextEditingController();
  TextEditingController _metertypeController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool validate = false;
  List<dynamic> myplan;
  String platform;
  int _discoid;

  List<Map> _metertype = [
    {"name": "Prepaid", "value": "Prepaid"},
    {"name": "Postpaid", "value": "Postpaid"}
  ];

  //bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  void updateInformation(Map dataplan) {
    print(dataplan);
    setState(() {
      _discoController.text = dataplan["name"];
      _discoid = dataplan["value"];
    });
  }

  void moveToPlanPage() async {
    final Map dataplan = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => DiscoSlecetionBox(
                selecteddisco: _discoController.text,
              )),
    );

    updateInformation(dataplan);
  }

  Future<dynamic> _Validate(String meter, String id, String mtype) async {
    try {
      String url =
          'https://www.Bardetech.com/api/validatemeter?meternumber=$meter&&disconame=$id&&mtype=$mtype';
      print(url);
      Response response = await get(url);

      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);
        print(responseJson["name"]);

        if (this.mounted) {
          setState(() {
            _isLoading = false;
            _nameController.text = responseJson["name"];
            _addressController.text = responseJson["address"];

            if (responseJson["name"] != "INVALID METER NUMBER") {
              validate = true;
            } else {
              Toast.show("INVALID METER NUMBER", context,
                  backgroundColor: Colors.red[500],
                  duration: Toast.LENGTH_SHORT,
                  gravity: Toast.CENTER);
            }
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
            backgroundColor: Colors.green,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      } else if (response.statusCode == 400) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("unexpected error occured", context,
            backgroundColor: Colors.green,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("unexpected error occured", context,
            backgroundColor: Colors.green,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }
    } finally {
      Client().close();
    }
  }

  Future<dynamic> _ElectPaymentubmit(String disco, String amount, String meter,
      String mtype, String phone, String name, address) async {
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
      String url = 'https://www.voicestelecom.com.ng/api/billpayment/';

      Response response = await post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
            "disco_name": disco,
            "amount": amount,
            "meter_number": meter,
            "MeterType": mtype,
            "Customer_Phone": phone,
            "Platform": platform,
            "customer_name": name,
            "customer_address": address
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
                    builder: (BuildContext context) => Billreceipt(data: data)),
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
            backgroundColor: Colors.green,
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
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Color.fromRGBO(184, 9, 146,1),duration: Toast.LENGTH_SHORT,gravity:  Toast.CENTER);

        }
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("unexpected error occured", context,
            backgroundColor: Colors.green,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }
    } finally {
      Client().close();
    }
  }

  Widget _entryField(String title, myicon, mykey, String inputvalue,
      TextEditingController controll,
      {Function valid, bool isPassword = false}) {
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
    await _ElectPaymentubmit(
        _discoid.toString(),
        _amountController.text,
        _meterController.text,
        _metertypeController.text,
        _phoneController.text,
        _nameController.text,
        _addressController.text);
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
                        "You are about to pucharse  ₦${_amountController.text} Electricitity unit/token for ${_meterController.text} (${_nameController.text})",
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
                colors: [Colors.green, Colors.green])),
        child: Text(
          'Buy Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _validateButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          setState(() => _isLoading = true);
          await _Validate(_meterController.text, _discoController.text,
              _metertypeController.text);
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
                colors: [Colors.green, Colors.green])),
        child: Text(
          'Validate Meter',
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
          title: Text("Electricity Bill Payment",
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
                  Container(
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "How much would you like to pay ?",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: discovalidator,
                    enableInteractiveSelection: false,
                    showCursor: false,
                    readOnly: true,
                    textAlign: TextAlign.left,
                    controller: _discoController,
                    onTap: () async {
                      moveToPlanPage();
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
                      labelText: "Select Disco Company",
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
                    validator: metertypevalidator,
                    textAlign: TextAlign.left,
                    controller: _metertypeController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        // Based on passwordVisible state choose the icon

                        Icons.arrow_drop_down,
                      ),
                      labelText: "Meter Type",
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
                                      "Select Meter Type",
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
                                    itemCount: _metertype.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _metertypeController.text =
                                                _metertype[index]["name"];
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
                                                  color: _metertypeController
                                                              .text ==
                                                          _metertype[index]
                                                              ["name"]
                                                      ? Colors.red.shade300
                                                      : Colors.grey.shade300),
                                            ),
                                            child: Text(
                                              _metertype[index]["name"],
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
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: validateMeter,
                    textAlign: TextAlign.left,
                    controller: _meterController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Meter Number",
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
                    height: 15,
                  ),
                  TextFormField(
                    validator: validateBillAmount,
                    textAlign: TextAlign.left,
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Amount",
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
                    height: 15,
                  ),
                  TextFormField(
                    validator: validateMobile,
                    textAlign: TextAlign.left,
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Customer Phone",
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
                  validate
                      ? SizedBox(
                          height: 15,
                        )
                      : SizedBox(),
                  validate
                      ? TextFormField(
                          showCursor: true,
                          readOnly: true,
                          textAlign: TextAlign.left,
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Customer name",
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
                  SizedBox(
                    height: 15,
                  ),
                  validate
                      ? TextFormField(
                          showCursor: true,
                          readOnly: true,
                          textAlign: TextAlign.left,
                          controller: _addressController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Customer name",
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
                  SizedBox(
                    height: 20,
                  ),
                  validate ? _submitButton() : _validateButton(),
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
