import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import './screens/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'airtimefundcomfirm.dart';

class AirtimeFunding extends StatefulWidget {
  final String title;

  AirtimeFunding({Key key, this.title}) : super(key: key);

  @override
  _AirtimeFundingState createState() => _AirtimeFundingState();
}

class _AirtimeFundingState extends State<AirtimeFunding> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _amountController = TextEditingController();
  TextEditingController _networkController = TextEditingController();
  TextEditingController _amount_to_pay_Controller = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String amountV;
  String phoneV;
  String _myActivity;
  double amount_to_receive = 0.0;
  int mtnpercent;
  int glopercent;
  int airtelpercent;
  int mobiepercent;
  int amount_fill = 0;
  bool checkedValue = false;
  SharedPreferences sharedPreferences;
  //bool _obscureText = true;

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

  @override
  void initState() {
    filldetails();
    super.initState();
  }

  void setValue() {
    if (_networkController.text.isNotEmpty &&
        _amountController.text.isNotEmpty) {
      var percent = topuppercent[_networkController.text]["percent"];

      var amount_v = int.parse(_amountController.text);

      setState(() {
        _amount_to_pay_Controller.text =
            (amount_v - amount_v * (100 - percent) ~/ 100).toString();
      });
    }
  }

  Future<dynamic> filldetails() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var topuppercentjson =
        json.decode(sharedPreferences.getString("percentage"));

    setState(() {
      topuppercent = topuppercentjson;
    });
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();

          print(int.parse(_amountController.text));
          print(_networkController.text);
          print(_phoneController.text);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AirtimeFunding_Comfirm(
                      amount: int.parse(_amountController.text),
                      network: _networkController.text,
                      phone: _phoneController.text,
                      fundwallet: checkedValue)));
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
          'Proceed',
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
        title: Text("Airtime Funding",
            style: TextStyle(color: Colors.black, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
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
                                      setState(() {
                                        networkobject = _networklist[index];
                                        _networkController.text =
                                            _networklist[index]["name"];

                                        _network = _networklist[index]["id"];
                                      });
                                      setValue();
                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              color: _networkController.text ==
                                                      _networklist[index]
                                                          ["name"]
                                                  ? Colors.red.shade300
                                                  : Colors.grey.shade300),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  _networklist[index]["logo"]),
                                              radius: 30.0,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              _networklist[index]["name"],
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w400),
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
              SizedBox(height: 15),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                validator: validate_Amount2,
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
                  labelText: "Phone Number you are transfer airtime from",
                  hintText: "",
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
                        labelText: "Amount to Receive",
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
              CheckboxListTile(
                title: Text(
                    "Check if you want to use it to fund wallet else transfer to bank "),
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              SizedBox(
                height: 20,
              ),
              _submitButton(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
