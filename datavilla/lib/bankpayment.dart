import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankPagePayment extends StatefulWidget {
  final String title;

  BankPagePayment({Key key, this.title}) : super(key: key);

  @override
  _BankPagePaymentState createState() => _BankPagePaymentState();
}

class _BankPagePaymentState extends State<BankPagePayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _codeController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String account;
  String bank;
  List <dynamic> banks;
  String username;
  //bool _obscureText = true;

  @override
  void initState() {
    filldetails();
    super.initState();
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      account = pref.getString("account");
      bank = pref.getString("bank");
      banks = json.decode(pref.getString("banks"));
      username = pref.getString("username");
    });

    print(banks);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(" Bank Payment",
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
                        Container(
                            margin: EdgeInsets.fromLTRB(10.0, 20, 10.0, 0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.indigo[900],
                            ),
                            child: Center(
                                child: Text(
                              "AUTOMATED BANK FUNDING \n\nPay into the account below your wallet will be funded automatically",
                              style: TextStyle(color: Colors.white),
                            ))),
                        SizedBox(height: 10),
                        Center(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20),
                                Text(
                                  "$bank",
                                  style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Elecastle-$username",
                                  style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Account Number : $account",
                                  style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "$bank ₦50 charge  ",
                                  style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 40),
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(10.0, 20, 10.0, 0),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo[900],
                                  ),
                                  child: Center(
                                      child: Text(
                                    "MANUAL BANK FUNDING\n\You can deposit or transfer fund into our account stated above. Use your registered username as depositor's name, naration or remarks Your account will be funded as soon as your payment is confirmed.",
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                                SizedBox(height: 10),
                               Container(
                                 height: MediaQuery.of(context).size.height /2.9,
                                 child: ListView.builder(
                                  
  padding: const EdgeInsets.all(8),
  itemCount: banks.length,
  itemBuilder: (BuildContext context, int index) {
    return
      

      Card(
      child: Column(
      children:[
        
         SizedBox(height: 5),
                Text(
                  "Bank Name : ${banks[index]['bank_name']}",
                  style: TextStyle(
                      color: Colors.indigo[900],
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold),
                ),
                  Text(
                  "Name: ${banks[index]['account_name']}",
                  style: TextStyle(
                      color: Colors.indigo[900],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                 Text(
                  "Account Number: ${banks[index]['account_number']}",
                  style: TextStyle(
                      color: Colors.indigo[900],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
               
              
              

                                  
      ]
    ),
  );
      
               }             ),
                               ),
      // use it
    
                //                 Flexible(
                //                    child: ListView.builder(
                //                 padding: const EdgeInsets.all(8),
                //                 itemCount: banks.length,
                //                 itemBuilder: (BuildContext context, int index) {
                //                     return  
                                    
                //                        Text(
                //   "Account Name :KANIFE CLETUS NNANNA ",
                //   style: TextStyle(
                //       color: Colors.indigo[900],
                //       fontSize: 15.0,
                //       fontWeight: FontWeight.bold),
                // );
                
  //               Card(
    
     
  //     child: Column(
  //     children:[
        
  //                 Text(
  //                 "Account Name :KANIFE CLETUS NNANNA ",
  //                 style: TextStyle(
  //                     color: Colors.indigo[900],
  //                     fontSize: 15.0,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(height: 5),
  //               Text(
  //                 "First bank:  3049567383",
  //                 style: TextStyle(
  //                     color: Colors.indigo[900],
  //                     fontSize: 17.0,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(height: 5),
  //               Text(
  //                 "Gtbank:  0107137769",
  //                 style: TextStyle(
  //                     color: Colors.indigo[900],
  //                     fontSize: 17.0,
  //                     fontWeight: FontWeight.bold),
  //               ),

                                
  //     ]
  //   ),
  // );/                     
                                SizedBox(height: 5),
                                Text(
                                  "PLEASE NOTE THAT MINIMUM WALLET FUNDING VIA MANUAL BANK TRANSFER/DEPOSIT IS 1000#.",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed("/banknotice");
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
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
                                              Colors.indigo[900],
                                              Colors.indigo[900]
                                            ])),
                                    child: Text(
                                      'Send payment Notification',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
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
          inAsyncCall: _isLoading,
        ));
  }
}
