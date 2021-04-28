import 'package:flutter/material.dart';
import 'src/Widget/bezierContainer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:datavilla/screens/validator.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'airtimereceipt.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'bottompin.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'dart:io' show Platform;



class BuyAirtime extends StatefulWidget {
  final String title;
  final String image;
  final int id;

  BuyAirtime({Key key, this.title, this.image, this.id}) : super(key: key);

  @override
  _BuyAirtimeState createState() => _BuyAirtimeState();
}

class _BuyAirtimeState extends State<BuyAirtime> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _phoneController = TextEditingController();

  TextEditingController _amountController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String phoneV;
  String networkV;
  String amountV;
  bool checkedValue = false;
  int amount_to_pay = 0;
  int mtnpercent ;
int glopercent ;
  int airtelpercent ;
 int mobiepercent ;
  int amount_fill = 0;
     String _myActivity2;
  String platform;

  //bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    filldetails();
  }

  



  void amount_pay(){

      if(_myActivity2 == "VTU"){
              if (widget.id == 1){
                  setState(() {
                     amount_to_pay = amount_fill - amount_fill * (100 - mtnpercent ) ~/100;
                  });
                  
                }


                 else if (widget.id == 2){
                  setState(() {
                     amount_to_pay = amount_fill - amount_fill * (100 -glopercent)~/100;
                  });
                  
                }

                 else if (widget.id == 4){
                  setState(() {
                     amount_to_pay = amount_fill - amount_fill * (100 -airtelpercent) ~/100;
                  });
                  
                }

                  else if (widget.id == 3){
                  setState(() {
                     amount_to_pay = amount_fill - amount_fill * (100 -mobiepercent) ~/100;
                  });
                  
                }

      }
  }
   void setValue(value) { setState(() {
    amount_fill = int.parse(value) ;
    });

    amount_pay();

    print(amount_to_pay);
    print(mtnpercent~/100);
                
  }

 Future<dynamic> filldetails() async {
         SharedPreferences pref = await SharedPreferences.getInstance();

         setState(() {
              mtnpercent   =  pref.getInt("TopupPercentageMTN");
              glopercent  =  pref.getInt("TopupPercentageGLO");
              airtelpercent  =  pref.getInt("TopupPercentageAIRTEL");
               mobiepercent  =  pref.getInt("TopupPercentage9MOBILE");
           
         });

     
  }




  Future<dynamic> _BuyAirtime(String phone, String amount, int network) async {
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
      String url = 'https://www.elecastlesubng.com/api/topup/';
      print(jsonEncode({"network": network, "amount": amount, "phone": phone}));
      Response response = await post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
            "network": network,
            "amount": amount,
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
                    builder: (BuildContext context) =>
                        AirtimeReceipt(data: data)),
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
      {Function valid,Function onchangefunc, bool isPassword = false}) {
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
              onChanged:onchangefunc,
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
     await _BuyAirtime(
            _phoneController.text,
            _amountController.text,
            widget.id,
          );
  }



  Widget _submitButton() {
    return InkWell(
      onTap:  () {
        if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
      showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
        return   Bottom_pin(
          title: "You are about to pucharse  ₦${_amountController.text} Airtime for ${_phoneController.text}",
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
          'Buy Airtime',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _BuyAirtimefieldsWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

Text(
                "Airtime Type",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),

              SizedBox(
                height: 10,
              ),
            DropDownFormField(
                 titleText: '',
                hintText: 'Select Airtime Type',
                value: _myActivity2,
                onSaved: (value) {
                 
                  setState(() {
                    _myActivity2 = value;
                    print(_myActivity2);
                  });
                },
                onChanged: (value) {
                   
                 

                  setState(() {
                    _myActivity2 = value;
                    print(_myActivity2);
                  });

          
                 
                },
                dataSource: [{ "display":"VTU","value":"VTU"},{"display":"SHARE AND SELL","value":"Share and Sell"}],
                textField: 'display',
                valueField: 'value',
              ),

              SizedBox(height:10),
             _myActivity2 != null ? _entryField("Amount ", Icons.account_balance_wallet,
                  TextInputType.number, amountV, _amountController,
                  valid: validateAmount, onchangefunc:setValue):SizedBox(),
              _entryField("Phone ", Icons.phone_iphone, TextInputType.number,
                  phoneV, _phoneController,
                  valid: validateMobile),
             _amountController != null ?   Text(
            "Amount to Pay ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ):SizedBox(),
          SizedBox(
            height: 10,
          ),
           _amountController!= null ?  Container(
              margin: const EdgeInsets.all(2.0),
               padding: const EdgeInsets.fromLTRB(10, 15,100, 15),
              child: Text("₦$amount_to_pay",style:TextStyle(fontSize:15.0) ,),
              decoration: BoxDecoration(
                 
                  //color: Color(0xfff3f3f4),
                  
                  )
                  ):SizedBox() ,
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
          title: Text("Buy Airtime",
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
                        _BuyAirtimefieldsWidget(),
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
