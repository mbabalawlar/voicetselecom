import 'package:flutter/material.dart';
import './screens/validator.dart';
import 'src/Widget/bezierContainer.dart';
import './screens/newdashboard.dart';
import 'package:uuid/uuid.dart';
import 'package:monnify_flutter_sdk/monnify_flutter_sdk.dart';
import 'payment.dart';

class FlutterwavePay extends StatefulWidget {
  String email;
  String username;

  FlutterwavePay({this.email, this.username});

  @override
  _FlutterwavePayState createState() => _FlutterwavePayState();
}

// Pay public key
class _FlutterwavePayState extends State<FlutterwavePay> {
  BuildContext mContext;

  @override
  void initState() {
    super.initState();
    initializeSdk();
  }

  Future<void> initializeSdk() async {
    try {
      if (await MonnifyFlutterSdk.initialize(
          'MK_PROD_WJ86WQCVZY', '835629168417', ApplicationMode.LIVE)) {
        _showToast("SDK initialized!");
      }
    } catch (e, s) {
      print("Error initializing sdk");
      print(e);
      print(s);

      _showToast("Failed to init sdk!");
    }
  }

  void _showToast(String message) {
    print("hey");
  }

  bool isGeneratingCode = false;
  String amountV;
  var uuid = Uuid();
  double amount_Charge = 0;

  bool _isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();

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
                      double.parse(val) + (0.015 * double.parse(val));
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
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    CheckoutMethodSelectable(email: widget.email)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.green[700],
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
        ),
        child: Text(
          'Pay with Paystack',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _submitButton2() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          setState(() => _isLoading = true);
          await initPayment(
              widget.email, _amountController.text, widget.username);
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
          'Continue with Payment',
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
                      "Amount to Pay + charge  ",
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

  Future<void> initPayment(email, amount, username) async {
    TransactionResponse transactionResponse;

    try {
      transactionResponse =
          await MonnifyFlutterSdk.initializePayment(Transaction(
        double.parse(amount) + (0.015 * double.parse(amount)),
        "NGN",
        "$username",
        "$email",
        uuid.v1(),
        "Wallet funding",
        metaData: {"ip": "196.168.45.22", "device": "mobile"},
        paymentMethods: [PaymentMethod.CARD],
      ));

      print(transactionResponse.transactionStatus.toString());
    } catch (error, stacktrace) {
      // handleError(error);
      print(stacktrace);

      _showToast("Failed to init payment!");
    }
  }

  // beginPayment(email, amount, username) async {
  //   // Get a reference to RavePayInitializer
  //   var initializer = RavePayInitializer(
  //       amount: double.parse(amount) + (0.015 * double.parse(amount)),
  //       publicKey: "FLWPUBK-24a9edff12ff335b22d6120992fe6e59-X",
  //       encryptionKey: "76cee3a7858f5fd898926359")
  //     ..country = "NG"
  //     ..currency = "NGN"
  //     ..email = email
  //     ..fName = username
  //     ..lName = username
  //     ..narration = ""
  //     ..txRef = uuid.v1()
  //     ..subAccounts = []
  //     ..acceptMpesaPayments = false
  //     ..acceptAccountPayments = true
  //     ..acceptCardPayments = true
  //     ..acceptAchPayments = false
  //     ..acceptGHMobileMoneyPayments = false
  //     ..acceptUgMobileMoneyPayments = false
  //     ..staging = false
  //     ..isPreAuth = false
  //     ..displayFee = true;

  //   // Initialize and get the transaction result
  //   RaveResult response = await RavePayManager()
  //       .prompt(context: context, initializer: initializer);

  //   print(response);
  //   print(response?.message);

  //   try {
  //     if (response?.message == "Approved. Successful") {
  //       _showDialog(response?.message);
  //     } else {
  //       _showErrorDialog(response?.message);
  //       print(response?.message);
  //     }
  //   } catch (error, stacktrace) {
  //     // handleError(error);
  //     print(stacktrace);
  //   }
  // }

  Dialog successDialog(context, msg) {
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
                color: Colors.green[700],
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
                "$msg",
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
                color: Colors.green[700],
                child: Text("OK",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return successDialog(context, msg);
      },
    );
  }

  Dialog errorDialog(context, msg) {
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
                "$msg",
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

  void _showErrorDialog(msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return errorDialog(context, msg);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("ATM Payment",
            style: TextStyle(color: Colors.black, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
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
                    _submitButton2(),
                    Center(
                      child: Image.asset(
                        'assets/monnify.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // _submitButton(),
                    Expanded(
                      flex: 2,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
