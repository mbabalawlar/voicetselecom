import 'package:flutter/material.dart';
//import 'signup.dart';
import 'src/Widget/bezierContainer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:datavilla/screens/validator.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'datareceipt.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'bottompin.dart';
import 'dart:io' show Platform;



class BuyData extends StatefulWidget {
  final String title;
  final String image;
  final int id;
  final  Map<dynamic, dynamic> plan;

  BuyData({Key key, this.title, this.image, this.id, this.plan})
      : super(key: key);

  @override
  _BuyDataState createState() => _BuyDataState();
}

class _BuyDataState extends State<BuyData> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int dropdownValue;
  String phoneV;
  bool checkedValue = false;
  String networkV;
  List<dynamic> planx;
  List<dynamic> myplan;
  String plan_text;
  String _myActivity;
   String _myActivity2;
  String platform,user_type;
bool is_type = false;
 SharedPreferences pref ;



  @override
  void initState() {
    super.initState();
filldetails();
    // myplan = widget.plan["ALL"]
    //     .map((net) => { "display":"${net['plan']} == ₦${net['plan_amount']} ${net['plan_type'] == null ? '' :net['plan_type'] } ${net['month_validate']} ",
    //           "value": net["id"].toString()
    //         })
    //     .toList();

       
  }


  Future<dynamic> filldetails() async {
   
   setState(() async{
      pref = await SharedPreferences.getInstance();

   });

    if ( pref.getString("user_type") == "Affilliate"){

 myplan = widget.plan["ALL"]
        .map((net) => { "display":"${net['plan']} == ₦${net['Affilliate_price']} ${net['plan_type'] == null ? '' :net['plan_type'] } ${net['month_validate']} ",
              "value": net["id"].toString()
            })
        .toList();
    }
    if ( pref.getString("user_type") == "TopUser"){
      

       myplan = widget.plan["ALL"]
        .map((net) => { "display":"${net['plan']} == ₦${net['TopUser_price']} ${net['plan_type'] == null ? '' :net['plan_type'] } ${net['month_validate']} ",
              "value": net["id"].toString()
            })
        .toList();
    }

    else{

  setState(() {   
        
        myplan = widget.plan["ALL"]
        .map((net) => { "display":"${net['plan']} == ₦${net['plan_amount']} ${net['plan_type'] == null ? '' :net['plan_type'] } ${net['month_validate']} ",
              "value": net["id"].toString()
            })
        .toList();
    
      });
    }
   


  }


  Future<dynamic> _buyData(String phone, String plan, int network) async {
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
      String url = 'https://www.elecastlesubng.com/api/data/';

      Response response = await post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
            "network": network,
            "plan": plan.toString(),
            "mobile_number": phone,
            "Ported_number": checkedValue,
            "Platform":platform,
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
                    builder: (BuildContext context) => DataReceipt(data: data)),
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

        Toast.show("Uexpected error occured", context,
            backgroundColor: Colors.indigo[900],
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }
    } finally {
      Client().close();
    }
  }

  void databuy() async{
    await _buyData(
            _phoneController.text,
            _myActivity,
            widget.id,
          );
  }

  Widget _entryField(
      String title, String inputvalue, TextEditingController controll,
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
              onSaved: (String val) {
                inputvalue = val;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true)),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
      showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
        return   Bottom_pin(
          title: "You are about to pucharse $plan_text data for ${_phoneController.text}",
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

  Widget _buydatafieldsWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

 widget.id == 1? Text(
                "Data Type",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ):SizedBox(),
              SizedBox(
                height: 10,
              ),
             widget.id == 1? DropDownFormField(
                 titleText: '',
                hintText: 'Select Data Type',
                value: _myActivity2,
                onSaved: (value) {
                 
                  setState(() {
                    _myActivity2 = value;
                    print(_myActivity2);
                  });
                },
                onChanged: (value) {
                    setState(() {
                    
                    is_type = false;
                    _myActivity = "";
                  });

                  print(widget.plan[value]);
                  
              
 if ( pref.getString("user_type") == "Affilliate"){
 setState(() {
    myplan = widget.plan[value]
        .map((net) => { "display":
                       "${net['plan']} == ₦${net['Affilliate_price']}  ${net['plan_type'] == null ? '' :net['plan_type'] } ${net['month_validate']} ",
              "value": net["id"].toString()
            })
        .toList();
});

 }
    else if ( pref.getString("user_type") == "TopUser"){

      setState(() {
    myplan = widget.plan[value]
        .map((net) => { "display":
                       "${net['plan']} == ₦${net['TopUser_price']}   ${net['plan_type'] == null ? '' :net['plan_type'] } ${net['month_validate']} ",
              "value": net["id"].toString()
            })
        .toList();
});

 }

 else{

  setState(() {   
        
        myplan = widget.plan[value]
        .map((net) => { "display":"${net['plan']} == ₦${net['plan_amount']} ${net['plan_type'] == null ? '' :net['plan_type'] } ${net['month_validate']} ",
              "value": net["id"].toString()
            })
        .toList();
    
      });
    }
   
print(myplan);

                  setState(() {
                    _myActivity2 = value;
                    print(_myActivity2);
                  });

                  
                  setState(() {
                    
                    is_type = true;
                  });

               
                  
                 
                },
                dataSource: [{ "display":"SME","value":"SME"},{ "display":"GIFTING","value":"GIFTING"}],
                textField: 'display',
                valueField: 'value',
              ):SizedBox(),

              SizedBox(height:10)
,
              (is_type || widget.id !=1 )? Text(
                "Plan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ):SizedBox(),
              SizedBox(
                height: 10,
              ),
               is_type ? DropDownFormField(
                 titleText: '',
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

                  for (var a = 0; a< widget.plan["ALL"].length; a++){
                      
                       if (widget.plan["ALL"][a]["id"].toString() == _myActivity){
                            
                            var net = widget.plan["ALL"][a];
                            setState(() {
                              
                              plan_text = "${net['plan_network']} ${net['plan']}  at ₦${net['plan_amount']} ${net['plan_type']} ${net['month_validate']} ";
                            });
                       }
                  }
                

              
                 
                },
                dataSource: myplan,
                textField: 'display',
                valueField: 'value',
              ):SizedBox(),

              _entryField("Phone ", phoneV, _phoneController,
                  valid: validateMobile),
              CheckboxListTile(
                title: Text("Bypass number validator for ported number"),
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              )
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
          title: Text("Buy Data",
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
                        _buydatafieldsWidget(),
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

