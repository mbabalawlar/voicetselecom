import 'package:datavilla/cablereceipt.dart';
import 'package:flutter/material.dart';
import 'src/Widget/bezierContainer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:datavilla/screens/validator.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'bottompin.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io' show Platform;

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

  TextEditingController _meterController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int dropdownValue;
  String meterV;
  String cableId;
  bool validate = false;
  String customername;
  List<dynamic> planx;
  List<dynamic> myplan;
  String plan_text;
  String _myActivity;
  String platform;

  //bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    print(widget.image);
    print(widget.id);

    myplan = widget.plan
        .map((net) => {
              "display": "${net['package']} =  ₦${net['plan_amount']}  ",
              "value": net["id"].toString()
            })
        .toList();
  }


  
                

  Future<dynamic> _Validate(String meter, int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      String ab;

      switch (id) {
        case 1:
          {
            ab = "GOTV";
          }
          break;
        case 2:
          {
            ab = "DSTV";
          }
          break;

        case 3:
          {
            ab = "STARTIME";
          }
          break;
      }

      String url =
          'https://www.elecastlesubng.com/api/validateiuc?smart_card_number=$meter&&cablename=$ab';
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
            if (customername != "INVALID_SMARTCARDNO") {
              validate = true;
            } else {
              Toast.show("INVALID_SMARTCARDNO", context,
                  backgroundColor: Colors.indigo[900],
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
    platform ="IOS APP";
  });

}


    try {
      String url = 'https://www.elecastlesubng.com/api/cablesub/';
      print(jsonEncode({
        "cablename": cablename,
        "cableplan": cableplan,
        "smart_card_number": meter
      }));
      Response response = await post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
            "cablename": cablename,
            "cableplan": cableplan,
            "smart_card_number": meter,
            "Platform":platform
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
      }else if (response.statusCode == 500) {
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
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Colors.indigo[900],duration: Toast.LENGTH_SHORT, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

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
      await _cableSubmit(
              widget.id.toString(), _myActivity, _meterController.text);
        
  }


  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
      showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
        return   Bottom_pin(
          title: "You are about to subscribe $plan_text for ${_meterController.text}",
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
          await _Validate(
            _meterController.text,
            widget.id,
          );
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


                   for (var a = 0; a< widget.plan.length; a++){
                      
                       if (widget.plan[a]["id"].toString() == _myActivity){
                            
                            var net = widget.plan[a];
                            setState(() {
                              
                              plan_text = "${net['package']} =  ₦${net['plan_amount']}  ";
                            });
                       }
                  }
                },
                dataSource: myplan,
                textField: 'display',
                valueField: 'value',
              ),

              /*  DropdownButtonFormField<dynamic>(
      "value": dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),

      onChanged: (dynamic newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: widget.plan.map((net) =>  net["id"] ).toList().map<DropdownMenuItem<dynamic>>((dynamic value) {
        return DropdownMenuItem<dynamic>(
          "value": value,
          child: Text('${ myplan} GB ====== ₦320') ,
        );
      }).toList(),
    ),


       */

              _entryField("Cable Number", Icons.scanner, TextInputType.number,
                  meterV, _meterController,
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
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Cable Subscription",
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
                        _CableSfieldsWidget(),
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
