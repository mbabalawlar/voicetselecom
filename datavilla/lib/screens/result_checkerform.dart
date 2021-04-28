import 'package:flutter/material.dart';
import 'bezierContainer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:datavilla/screens/validator.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'result_checker_receipt.dart';

class ResultChecker extends StatefulWidget {
  final String title;

  ResultChecker({Key key, this.title}) : super(key: key);

  @override
  _ResultCheckerState createState() => _ResultCheckerState();
}

class _ResultCheckerState extends State<ResultChecker> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _amountController = TextEditingController();
  TextEditingController _accountnumberController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String amountV;
  String quantityV;
  String _myActivity;
  double amount_to_receive;
  double waec;
  double neco;
  bool is_amount = false;

  @override
  void initState() {
    filldetails();
    super.initState();
    _quantityController.text = '1';
  }

  void amount_receive() {
    print(_quantityController.text);
    if (_myActivity == "WAEC") {
      setState(() {
        if (_quantityController.text == null) {
          amount_to_receive = waec;
        } else {
          amount_to_receive = waec * int.parse(_quantityController.text);
        }
        check_amount_to_receive();
      });
    } else if (_myActivity == "NECO") {
      setState(() {
        if (_quantityController.text == null) {
          amount_to_receive = neco;
        } else {
          amount_to_receive = neco * int.parse(_quantityController.text);
        }
        check_amount_to_receive();
      });
    }
  }

  bool check_amount_to_receive() {
    if (amount_to_receive != null) {
      setState(() {
        is_amount = true;
      });
    } else {
      setState(() {
        is_amount = false;
      });
    }
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      waec = pref.getDouble("WAEC");
      neco = pref.getDouble("NECO");
    });
  }

  Future<dynamic> _ResultChecker(
    String exam,
    String quantity,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      String url = 'https://www.elecastlesubng.com/api/epin/';

      Response response = await post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body:
              jsonEncode({"exam_name": exam, "quantity": int.parse(quantity)}));

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        //var responseJson = json.decode(response.body);

        if (this.mounted) {
          setState(() {
            _isLoading = false;
            print(response.body);
            Map responseJson = json.decode(response.body);

            AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.SUCCES,
              title: 'Success',
              desc:
                  'You successfully purchased  ${responseJson["quantity"]} pieces of  ${responseJson["exam_name"]}  Epin ',
              btnOkOnPress: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            ResultReceipt(data: responseJson)));
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

        Toast.show(
            "something went wrong please ,report to admin before try another transaction",
            context,
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
            title: 'Error!',
            desc: responseJson["error"][0],
            btnCancelOnPress: () {},
            btnCancelText: "ok",
          ).show();
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Colors.indigo[900],duration: Toast.LENGTH_SHORT, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

        }
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show(
            "something went wrong please ,report to admin before try another transaction",
            context,
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
              onChanged: (String val) {
                amount_receive();
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

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          setState(() => _isLoading = true);
          await _ResultChecker(_myActivity, _quantityController.text);
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
          'Generate Pin',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _ResultCheckerfieldsWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              DropDownFormField(
                titleText: 'Exam Name',
                hintText: 'Select exam',
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
                    amount_receive();

                    print(_myActivity);
                  });
                },
                dataSource: [
                  {"display": 'WAEC', "value": 'WAEC'},
                  {"display": 'NECO', "value": 'NECO'},
                ],
                textField: 'display',
                valueField: 'value',
              ),
              _entryField("Quantity", Icons.scanner, TextInputType.number,
                  quantityV, _quantityController,
                  valid: quantityvalid),
              is_amount
                  ? Text(
                      "Amount ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              is_amount
                  ? Container(
                      margin: const EdgeInsets.all(2.0),
                      padding: const EdgeInsets.fromLTRB(10, 15, 100, 15),
                      child: Text(
                        "₦$amount_to_receive",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      decoration: BoxDecoration(

                          //color: Color(0xfff3f3f4),

                          ))
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
          title: Text("Result  Checker ",
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
                          child: SizedBox(
                            height: 20,
                          ),
                        ),
                        _ResultCheckerfieldsWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        _submitButton(),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -MediaQuery.of(context).size.height * .22,
                    right: -MediaQuery.of(context).size.width * .6,
                    child: BezierContainer())
              ],
            ),
          )),
          inAsyncCall: _isLoading,
        ));
  }
}
