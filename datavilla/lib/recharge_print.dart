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
import 'recharge_receipt.dart';



class RechargeCard extends StatefulWidget {
  final String title;
  final String image;
  final int id;
final  List<dynamic> plan;

  RechargeCard({Key key, this.title, this.image, this.id,this.plan}): super(key: key);

  @override
  _RechargeCardState createState() => _RechargeCardState();
}

class _RechargeCardState extends State<RechargeCard> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _nameontroller = TextEditingController();
   TextEditingController  _quantityController  = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String phoneV;
  String networkV;
  String amountV;
  String quantityV;
  bool checkedValue = false;
  double amount_to_pay = 0;
   double amount_select = 0;
  int mtnpercent ;
int glopercent ;
  int airtelpercent ;
 int mobiepercent ;
  int amount_fill = 0;
     String _myActivity2;
  String platform;
    List<dynamic> myplan;

  //bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    filldetails();

    myplan = widget.plan
        .map((net) => { "display":" ₦${net['amount']} ",
              "value": net["id"].toString()
            })
        .toList();
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




  Future<dynamic> _RechargeCard(String name, String amount, int network, String quantity) async {
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
      String url = 'https://www.elecastlesubng.com/api/rechargepin/';
      print(jsonEncode({"network": network, "amount": amount, "quantity": quantity,"name":name}));
      Response response = await post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
           "network": network,
            "network_amount":network,
            "quantity": int.parse(quantity),
            "name_on_card":name,
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
                        RechargeReceipt(data: data)),
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
     await _RechargeCard(
            _nameontroller.text,
            _amountController.text,
            widget.id,
            quantityV
          );
  }



  Widget _submitButton() {
    return InkWell(
      onTap:  () {
        if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
      showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
        return   Bottom_pin(
          title: "You are about to generate $quantityV piece of recharge card   ₦$amount_to_pay ",
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
          'Buy Pin',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _RechargeCardfieldsWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

Text(
                "Amount",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),

              SizedBox(
                height: 10,
              ),
            DropDownFormField(
                 titleText: '',
                hintText: 'Select Airtime Amount',
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


                   for (var a = 0; a< widget.plan.length; a++){
                      
                       if (widget.plan[a]["id"].toString() == _myActivity2){
                            
                            var net = widget.plan[a];
                            setState(() {
                              amount_select = net["amount_to_pay"];
                             
                            });
                       }
                  }

          
                 
                },
                dataSource:myplan,
                textField: 'display',
                valueField: 'value',
              ),

              SizedBox(height:10),
         
                 _myActivity2 != null?  _entryField("Quantity", Icons.scanner, TextInputType.number,
                  quantityV, _quantityController,
                  valid: quantityvalid2,onchangefunc:(value){
                  
                     setState(() {
                              quantityV = value;
                              amount_to_pay = value !=null ? amount_select * int.parse(value) : amount_select;
                            });
                  }):SizedBox(),

              _entryField("Name on Card ", Icons.verified_user, TextInputType.text,
                  phoneV, _nameontroller,
                  valid: validatename),
            quantityV != null ?   Text(
            "Amount to Pay ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ):SizedBox(),
          SizedBox(
            height: 10,
          ),
          quantityV != null ?  Container(
              margin: const EdgeInsets.all(2.0),
               padding: const EdgeInsets.fromLTRB(10, 15,100, 15),
              child: Text("₦$amount_to_pay",style:TextStyle(fontSize:15.0) ,),
              decoration: BoxDecoration(
                 
                  //color: Color(0xfff3f3f4),
                  
                  )
                  ):SizedBox() ,
             
              
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
          title: Text("Recharge Card Printing",
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
                        _RechargeCardfieldsWidget(),
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
