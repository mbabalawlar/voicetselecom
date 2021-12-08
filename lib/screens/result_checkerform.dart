import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'validator.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'result_checker_receipt.dart';
import '../bottompin.dart';

class ResultChecker extends StatefulWidget {
  final String title;

  ResultChecker({Key key, this.title}) : super(key: key);

  @override
  _ResultCheckerState createState() => _ResultCheckerState();
}

class _ResultCheckerState extends State<ResultChecker> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _examController = TextEditingController();
  TextEditingController _amount_to_pay_Controller = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SharedPreferences sharedPreferences;
  Map<dynamic, dynamic> exam;
  List<Map> _examlist = [
    {
      "name": "WAEC",
      "logo": "assets/waeclogo.jpeg",
    },
    {
      "name": "NECO",
      "logo": "assets/neco.jpeg",
    },
  ];

  @override
  void initState() {
    loadexam();
    super.initState();
    _quantityController.text = '1';
  }

  void setValue() {
    print(exam);
    if (_examController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      setState(() {
        _amount_to_pay_Controller.text = (exam[_examController.text]["amount"] *
                int.parse(_quantityController.text))
            .toString();
      });
    }
  }

  Future<dynamic> loadexam() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Map resJson = json.decode(sharedPreferences.getString("Exam"));

    setState(() {
      exam = resJson;
    });
  }

  Future<dynamic> _resultChecker(
    String exam,
    String quantity,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      String url = 'https://www.voicestelecom.com.ng/api/epin/';

      Response response = await post(Uri.parse(url),
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
            title: 'Error!',
            desc: responseJson["error"],
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

        Toast.show(
            "something went wrong please ,report to admin before try another transaction",
            context,
            backgroundColor: Colors.green[700],
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }
    } finally {
      Client().close();
    }
  }

  void databuy() async {
    await _resultChecker(_examController.text, _quantityController.text);
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Bottom_pin(
                    title:
                        "You are about to pucharse  ${_quantityController.text} pieces of ${_examController.text}  exam pin at ₦${_amount_to_pay_Controller.text}",
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
          'Generate Pin',
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
          title: Text("Result Checker pin",
              style: TextStyle(color: Colors.black, fontSize: 17.0)),
          centerTitle: true,
          backgroundColor: Colors.white,
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
                          controller: _examController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              // Based on passwordVisible state choose the icon

                              Icons.arrow_drop_down,
                            ),
                            labelText: "Select Exam",
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
                                            "Select Exam",
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
                                          itemCount: _examlist.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _examController.text =
                                                      _examlist[index]["name"];
                                                });
                                                setValue();
                                                Navigator.of(context).pop();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 5, 10, 5),
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        color: _examController
                                                                    .text ==
                                                                _examlist[index]
                                                                    ["name"]
                                                            ? Colors
                                                                .red.shade300
                                                            : Colors
                                                                .grey.shade300),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            AssetImage(
                                                                _examlist[index]
                                                                    ["logo"]),
                                                        radius: 30.0,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        _examlist[index]
                                                            ["name"],
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
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
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          validator: quantityvalid,
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
                        // _buydatafieldsWidget(),

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
              ],
            ),
          )),
          inAsyncCall: _isLoading,
        ));
  }
}
