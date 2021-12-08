import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './screens/validator.dart';
import 'src/Widget/bezierContainer.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import './screens/newdashboard.dart';

class CheckoutMethodSelectable extends StatefulWidget {
  String email;
  CheckoutMethodSelectable({this.email});

  @override
  _CheckoutMethodSelectableState createState() =>
      _CheckoutMethodSelectableState();
}

// Pay public key
class _CheckoutMethodSelectableState extends State<CheckoutMethodSelectable> {
  bool isGeneratingCode = false;
  String amountV;
  int amount_Charge = 0;
  bool _isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  var publicKey = "pk_live_2dad427f7a6f0f6e8d786ba80d43119863039222";
  final plugin = PaystackPlugin();

  @override
  void initState() {
    plugin.initialize(publicKey: publicKey);
    super.initState();
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
                inputvalue = val;
                setState(() {
                  amount_Charge =
                      int.parse(val) + (0.02 * int.parse(val)).round();
                });
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
          await chargeCard(_amountController.text, widget.email);
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
                colors: [
                  Color.fromRGBO(0, 0, 51, 1),
                  Color.fromRGBO(0, 0, 51, 1)
                ])),
        child: Text(
          'Pay',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _PaystactfieldsWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              _entryField("Amount ", Icons.account_balance_wallet,
                  TextInputType.number, amountV, _amountController,
                  valid: validateAmount),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Amount to Pay + Charge",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: const EdgeInsets.all(2.0),
                        padding: const EdgeInsets.fromLTRB(10, 15, 100, 15),
                        child: Text(
                          "N$amount_Charge",
                          style: TextStyle(fontSize: 15.0),
                        ),
                        decoration: BoxDecoration(

                            //color: Color(0xfff3f3f4),

                            )),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  createAccessCode(amount, email) async {
    // skTest -> Secret key
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer sk_live_6d20107845dbfd0596be38ece5c68b4c96eb1261'
    };
    Map data = {"amount": int.parse(amount) * 100, "email": email};
    String payload = json.encode(data);
    http.Response response = await http.post(
        Uri.parse('https://api.paystack.co/transaction/initialize'),
        headers: headers,
        body: payload);
    print(response.body);
    return jsonDecode(response.body);
  }

  Dialog successDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_box,
                color: Colors.green,
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                'Payment has successfully',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'been made',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Your payment has been successfully",
                style: TextStyle(fontSize: 13),
              ),
              Text("processed.", style: TextStyle(fontSize: 13)),
              SizedBox(height: 20),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => Dashboard()),
                      (Route<dynamic> route) => false);
                },
                color: Colors.green,
                child: Text("OK",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return successDialog(context);
      },
    );
  }

  Dialog errorDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 90,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Failed to process payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Error in processing payment, please try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 20),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => Dashboard()),
                      (Route<dynamic> route) => false);
                },
                color: Colors.red,
                child: Text("OK",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return errorDialog(context);
      },
    );
  }

  chargeCard(amount, email) async {
    Map accessCode = await createAccessCode(amount, email);

    setState(() {
      _isLoading = !_isLoading;
    });

    Charge charge = Charge()
      ..amount =
          int.parse(amount) * 100 + (0.02 * int.parse(amount) * 100).round()
      ..accessCode = accessCode["data"]["access_code"]
      ..email = email;
    CheckoutResponse response = await plugin.checkout(
      context,
      method:
          CheckoutMethod.selectable, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );
    if (response.status == true) {
      _showDialog();
    } else {
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Payment gateway",
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Color.fromRGBO(17, 35, 210, 1),
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
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _PaystactfieldsWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        _submitButton(),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Image.network(
                              'https://thebookmarketng.com/wp-content/uploads/2020/08/paystack-secured-300x147-1.png'),
                        ),
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
