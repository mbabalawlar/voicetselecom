import 'package:flutter/material.dart';
import 'src/Widget/bezierContainer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:datavilla/screens/validator.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'billreceipt.dart';
import 'bottompin.dart';
import 'dart:io' show Platform;

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

  TextEditingController _meterController = TextEditingController();

  TextEditingController _amountController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int dropdownValue;
  String meterV;
  String amountV;
  String cableId;
  String phone;
  bool validate = false;
    String customername;
  String address;
  List<dynamic> planx;
  List<dynamic> myplan;
  String platform;

  String _myActivity;

  //bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    print(widget.image);
    print(widget.id);
  }

  Future<dynamic> _Validate(String meter, int id, String mtype) async {
    try {
      String url =
          'https://www.elecastlesubng.com/api/validatemeter?meternumber=$meter&&disconame=$id&&mtype=$mtype';
      print(url);
      Response response = await get(url);

      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);
        print(responseJson["name"]);

        if (this.mounted) {
          setState(() {
            _isLoading = false;
              customername = responseJson["name"];
            address = responseJson["address"];

            if (customername != "INVALID METER NUMBER") {
              validate = true;
            } else {
              Toast.show("INVALID_SMARTCARDNO", context,
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
            backgroundColor: Colors.indigo[900],
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      } else if (response.statusCode == 400) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("unexpected error occured", context,
            backgroundColor: Colors.indigo[900],
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("unexpected error occured", context,
            backgroundColor: Colors.indigo[900],
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }
    } finally {
      Client().close();
    }
  }

  Future<dynamic> _ElectPaymentubmit(String disco, String amount, String meter,
      String mtype, String phone,String customer_name,
      customer_address) async {
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
    platform ="IOS APP";
  });

}



    try {
      String url = 'https://www.elecastlesubng.com/api/billpayment/';


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
            "Platform":platform,
             "customer_name": customer_name,
            "customer_address": customer_address
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
            backgroundColor: Colors.indigo[900],
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
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Colors.indigo[900],duration: Toast.LENGTH_SHORT,gravity:  Toast.CENTER);

        }
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("unexpected error occured", context,
            backgroundColor: Colors.indigo[900],
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

  
   void databuy() async{
     await _ElectPaymentubmit(widget.id.toString(), _amountController.text,
              _meterController.text, _myActivity, _phoneController.text,  customername,
              address);
  }


  Widget _submitButton() {
    return InkWell(
      onTap:  () {
        if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
      showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
        return   Bottom_pin(
          title: "You are about to pucharse  ₦${_amountController.text} Electricitity unit/token for ${_meterController.text} ($customername)",
          onTap: databuy


          
        );

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
                colors: [Colors.indigo[900], Colors.indigo[900]])),
        child: Text(
          'Submit',
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
          await _Validate(_meterController.text, widget.id, _myActivity);
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
                colors: [Colors.indigo[900], Colors.indigo[900]])),
        child: Text(
          'Validate Meter',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _ElectPaymentfieldsWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Meter Type",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              DropDownFormField(
                titleText: 'Meter Type',
                hintText: 'Select Meter Type',
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
                },
                dataSource: [
                  {"display": "Prepaid", "value": "PREPAID"},
                  {"display": "Postpaid", "value": "POSTPAID"}
                ],
                textField: 'display',
                valueField: 'value',
              ),
              _entryField("Meter", Icons.scanner, TextInputType.number, meterV,
                  _meterController,
                  valid: validateMeter),
              _entryField("Amount", Icons.account_balance_wallet,
                  TextInputType.number, amountV, _amountController,
                  valid: validateBillAmount),
              _entryField("Customer Phone", Icons.phone_android,
                  TextInputType.number, phone, _phoneController,
                  valid: validateMobile),
              validate
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Customer Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
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
                                style: TextStyle(fontSize: 15.0),
                              ),
                              decoration: BoxDecoration(

                                  //color: Color(0xfff3f3f4),

                                  )),
                        ],
                      ),
                    )
                  : SizedBox(),
              validate
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Customer Address",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              margin: const EdgeInsets.all(2.0),
                              padding:
                                  const EdgeInsets.fromLTRB(10, 15, 100, 15),
                              child: Text(
                                "$address",
                                style: TextStyle(fontSize: 15.0),
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
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Bill Payment",
              style: TextStyle(color: Colors.white, fontSize: 17.0)),
          centerTitle: true,
          backgroundColor: Colors.indigo[900],
          elevation: 0.0,
        ),
        body: ModalProgressHUD(
          child: SingleChildScrollView(
              child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: _formKey,
                    autovalidate: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Center(
                              child: CircleAvatar(
                            backgroundImage: AssetImage(widget.image),
                            radius: 35.0,
                          )),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        _ElectPaymentfieldsWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        validate ? _submitButton() : _validateButton(),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -MediaQuery.of(context).size.height * .15,
                    right: -MediaQuery.of(context).size.width * .6,
                    child: BezierContainer())
              ],
            ),
          )),
          inAsyncCall: _isLoading,
        ));
  }
}
