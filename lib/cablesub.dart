import './cablereceipt.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import './screens/validator.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'bottompin.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'componets/cableplan.dart';

class CableS extends StatefulWidget {
  final String title;
  final String image;
  final int id;
  final List<dynamic> plan;

  CableS({Key key, this.title, this.image, this.id, this.plan})
      : super(key: key);

  @override
  _CableSState createState() => _CableSState();
}

class _CableSState extends State<CableS> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _iucController = TextEditingController();
  TextEditingController _planController = TextEditingController();
  TextEditingController _cableController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int dropdownValue;
  String meterV;
  int cableId;
  bool validate = false;
  String customername;
  List<dynamic> planx;
  List<dynamic> myplan;
  String plan_text;
  String _myActivity;
  String platform;
  SharedPreferences sharedPreferences;
  Map<dynamic, dynamic> cableplans;
  String _planid;
  Map cableobject;

  List<Map> _cablelist = [
    {
      "name": "GOTV",
      "logo": "assets/gotv.jpeg",
      "id": 1,
    },
    {
      "name": "DSTV",
      "logo": "assets/dstv.jpeg",
      "id": 2,
    },
    {
      "name": "STARTIME",
      "logo": "assets/startime.jpeg",
      "id": 3,
    },
  ];
  //bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    loadplan();
  }

  loadplan() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Map resJson = json.decode(sharedPreferences.getString("Cableplan"));

    if (this.mounted) {
      setState(() {
        cableplans = resJson;
      });
    }

    print(cableplans["GOTVPLAN"]);
  }

  void updateInformation(Map dataplan) {
    print(dataplan);
    setState(() {
      _planController.text = dataplan["text"];
      _planid = dataplan["value"];
    });
  }

  void moveToPlanPage() async {
    print(cableplans);
    final Map dataplan = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => CableplanSlecetionBox(
              plan: cableplans["${_cableController.text}PLAN"])),
    );

    updateInformation(dataplan);
  }

  Future<dynamic> _Validate(String meter, String ab) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      String url =
          'https://www.voicestelecom.com.ng/api/validateiuc?smart_card_number=$meter&&cablename=$ab';
      print(url);
      Response response = await get(Uri.parse(url));

      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);
        print(responseJson["name"]);

        if (this.mounted) {
          setState(() {
            _isLoading = false;
            _nameController.text = responseJson["name"];
            if (customername != "INVALID_SMARTCARDNO") {
              validate = true;
            } else {
              Toast.show("INVALID_SMARTCARDNO", context,
                  backgroundColor: Colors.green[700],
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
            backgroundColor: Colors.green[700],
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      } else if (response.statusCode == 400) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("unexpected error occured", context,
            backgroundColor: Colors.green[700],
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("unexpected error occured", context,
            backgroundColor: Colors.green[700],
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }
    } finally {
      Client().close();
    }
  }

  Future<dynamic> _cableSubmit(
      String cablename, String cableplan, String meter) async {
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
      String url = 'https://www.voicestelecom.com.ng/api/cablesub/';
      print(jsonEncode({
        "cablename": cablename,
        "cableplan": cableplan,
        "smart_card_number": meter
      }));
      Response response = await post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
            "cablename": cablename,
            "cableplan": cableplan,
            "smart_card_number": meter,
            "Platform": platform,
            "customer_name": customername,
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
                        CablesubReceipt(data: data)),
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
            backgroundColor: Colors.red,
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

        Toast.show("unexpected error occured", context,
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
    await _cableSubmit(cableId.toString(), _planid, _iucController.text);
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
                        "You are about to subscribe ${_planController.text} for ${_iucController.text}",
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
          'Pay Now',
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
          await _Validate(_iucController.text, _cableController.text);
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
          'Validate Cable Number',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _CableSfieldsWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Plan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              DropDownFormField(
                titleText: 'plans',
                hintText: 'Select Plan',
                value: _myActivity,
                onSaved: (value) {
                  setState(() {
                    _myActivity = value;
                    print(_myActivity);
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _myActivity = value;
                    print(_myActivity);
                  });

                  for (var a = 0; a < widget.plan.length; a++) {
                    if (widget.plan[a]["id"].toString() == _myActivity) {
                      var net = widget.plan[a];
                      setState(() {
                        plan_text =
                            "${net['package']} =  ₦${net['plan_amount']}  ";
                      });
                    }
                  }
                },
                dataSource: myplan,
                textField: 'display',
                valueField: 'value',
              ),
              _entryField("Cable Number", Icons.scanner, TextInputType.number,
                  meterV, _iucController,
                  valid: validateMeter),
              validate
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Customer Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              margin: const EdgeInsets.all(2.0),
                              padding:
                                  const EdgeInsets.fromLTRB(10, 15, 100, 15),
                              child: Text(
                                "$customername",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              decoration: BoxDecoration(

                                  //color: Color(0xfff3f3f4),

                                  )),
                        ],
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        )
      ],
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
          title: Text("Cable Subscription",
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
                    showCursor: true,
                    readOnly: true,
                    validator: cablevalidate,
                    textAlign: TextAlign.left,
                    controller: _cableController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        // Based on passwordVisible state choose the icon

                        Icons.arrow_drop_down,
                      ),
                      labelText: "Select Cable",
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
                                      "Select cable Provider",
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
                                    itemCount: _cablelist.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _planController.text = "";
                                            cableobject = _cablelist[index];
                                            _cableController.text =
                                                _cablelist[index]["name"];

                                            cableId = _cablelist[index]["id"];
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
                                                  color: _cableController
                                                              .text ==
                                                          _cablelist[index]
                                                              ["name"]
                                                      ? Colors.red.shade300
                                                      : Colors.grey.shade300),
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      _cablelist[index]
                                                          ["logo"]),
                                                  radius: 30.0,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  _cablelist[index]["name"],
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
                    validator: cableplanvalidate,
                    enableInteractiveSelection: false,
                    showCursor: false,
                    readOnly: true,
                    textAlign: TextAlign.left,
                    controller: _planController,
                    onTap: () async {
                      if (_cableController.text.isNotEmpty) {
                        moveToPlanPage();
                      } else {
                        Toast.show("Pls select cable provider", context,
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
                      labelText: "Select Plan",
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
                    validator: iucvalidate,
                    textAlign: TextAlign.left,
                    controller: _iucController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "IUC/Smartcard Number",
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

                  validate ? _submitButton() : _validateButton(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )),
          inAsyncCall: _isLoading,
        ));
  }
}
