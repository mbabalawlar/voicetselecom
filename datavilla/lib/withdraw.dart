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
import 'bottompin.dart';



class Withdraw extends StatefulWidget {
  final String title;

  Withdraw({Key key, this.title}) : super(key: key);

  @override
  _withdrawState createState() => _withdrawState();
}

class _withdrawState extends State<Withdraw> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _amountController = TextEditingController();
  TextEditingController _accountnumberController = TextEditingController();
  TextEditingController _accountnameController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String amountV;
  String accountnumberV;
  String accountnameV;
  String _myActivity;

  //bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _withdraw(String amount, String bankname, String accountname,
      String accountnumber) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   setState(() {
            _isLoading = true;
  });
    try {
      String url = 'https://www.elecastlesubng.com/api/withdraw/';

      Response response = await post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
            "accountNumber": accountnumber,
            "accountName": accountname,
            "bankName": bankname,
            "amount": amount
          }));

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
                  '₦${responseJson["amount"]}   Withdraw request submitted succesfully, we will process it shortly',
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
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Colors.indigo[900],duration: Toast.LENGTH_SHORT, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

        }
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("Unable to connect to server currently", context,
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
   await _withdraw(_amountController.text, _myActivity,
              _accountnameController.text, _accountnumberController.text);
  }


  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
      showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
        return   Bottom_pin(
          title: "You are about to Withdraw   ₦${_amountController.text} to ${_accountnumberController.text} - ${_accountnameController.text} ",
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
          'Withdraw',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _withdrawfieldsWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  " ₦100 charge on Withdraw",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DropDownFormField(
                titleText: 'Bank Name',
                hintText: 'Select Bank',
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
                  {
                    "display": 'First Bank of Nigeria',
                    "value": 'First Bank of Nigeria'
                  },
                  {"display": 'UBA', "value": 'UBA'},
                  {
                    "display": 'Access(Diamond) Bank',
                    "value": 'Access (Diamond) Bank'
                  },
                  {"display": 'Wema Bank', "value": 'Wema Bank'},
                  {"display": 'Heritage Bank', "value": 'Heritage Bank'},
                  {"display": 'Polarise Bank', "value": 'Polarise Bank'},
                  {"display": 'Stanbic IBTC', "value": 'Stanbic IBTC'},
                  {"display": 'Sterling Bank', "value": 'Sterling Bank'},
                  {"display": 'Union Bank', "value": 'Union Bank'},
                  {"display": 'Zenith Bank', "value": 'Zenith Bank'},
                  {"display": 'Unity Bank', "value": 'Unity Bank'},
                  {"display": 'FCMBank', "value": 'FCMBank'},
                  {"display": 'GTBank', "value": 'GTBank'},
                  {"display": 'FIdelity Bank', "value": 'FIdelity Bank'},
                  {"display": 'ECO Bank', "value": 'ECO Bank'},
                ],
                textField: 'display',
                valueField: 'value',
              ),
              _entryField("Account Name", Icons.account_circle,
                  TextInputType.text, accountnameV, _accountnameController,
                  valid: name),
              _entryField(
                  "Account Number",
                  Icons.verified_user,
                  TextInputType.number,
                  accountnumberV,
                  _accountnumberController,
                  valid: accountnum),
              _entryField("Amount", Icons.account_balance_wallet,
                  TextInputType.number, amountV, _amountController,
                  valid: withdrawamount),
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
          title: Text("Withdraw ",
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
                        _withdrawfieldsWidget(),
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
