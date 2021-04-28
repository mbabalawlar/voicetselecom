import 'package:flutter/material.dart';
import 'src/Widget/bezierContainer.dart';
import 'dart:async';
import 'package:datavilla/screens/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'airtimefundcomfirm.dart';


class AirtimeFunding extends StatefulWidget {
   final String title;
  
   

  AirtimeFunding({Key key, this.title}) : super(key: key);

 
  @override
  _AirtimeFundingState createState() => _AirtimeFundingState();
}

class _AirtimeFundingState extends State<AirtimeFunding> {




  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _amountController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();



  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 
 
  String amountV;
  String phoneV;
  String _myActivity;
  double amount_to_receive = 0.0;
  int mtnpercent ;
  int glopercent ;
  int airtelpercent ;
  int mobiepercent ;
  int amount_fill = 0;
  //bool _obscureText = true;
  
  @override
  void initState() { 
    filldetails();
    super.initState();
   
   
  
  }

  

  void amount_receive(){
  
    if (_myActivity == "MTN"){
                  setState(() {
                     amount_to_receive = amount_fill * mtnpercent/100;
                  });
                  
                }


                 else if (_myActivity == "GLO"){
                  setState(() {
                     amount_to_receive = amount_fill * glopercent/100;
                  });
                  
                }

                 else if (_myActivity == "AIRTEL"){
                  setState(() {
                     amount_to_receive = amount_fill * airtelpercent/100;
                  });
                  
                }

                  else if (_myActivity == "9MOBILE"){
                  setState(() {
                     amount_to_receive = amount_fill * mobiepercent/100;
                  });
                  
                }
  }
 Future<dynamic> filldetails() async {
         SharedPreferences pref = await SharedPreferences.getInstance();

         setState(() {
              mtnpercent   =  pref.getInt("PercentageMTN");
              glopercent  =  pref.getInt("PercentageGLO");
              airtelpercent  =  pref.getInt("PercentageAIRTEL");
               mobiepercent  =  pref.getInt("Percentage9MOBILE");
           
         });
  }





  Widget _entryField(String title,myicon, mykey, String inputvalue, TextEditingController controll, { Function valid ,bool isPassword = false }) {
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
              controller:controll,
              validator: validate_Amount,
              keyboardType:mykey,
              onSaved: (String val) {
                    inputvalue = val;
                  },
              onChanged: (value) {
             

                setState(() {
                  amount_fill = int.parse(value) ;
                });

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
         if ( amount_fill > 0.0 && _myActivity != null  ) {
                                            
         
               Navigator.push(context,
                            new MaterialPageRoute(
                                builder: (context) =>  AirtimeFunding_Comfirm (amount:amount_fill, network: _myActivity,phone: phoneV,)));
     
        
        } },

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
          'Proceed',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }




  Widget _AirtimeFundingfieldsWidget() {
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
                  titleText: 'Network',
                  hintText: 'Network',
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
                    {"display": "MTN", "value":"MTN"},
                     {"display": "GLO", "value":"GLO"},
                      {"display": "AIRTEL", "value":"AIRTEL"},
                     {"display": "9MOBILE", "value":"9MOBILE"}
                  ],
                  textField: 'display',
                  valueField: 'value',
                ),
              



         
         _entryField("Amount",Icons.account_balance_wallet,TextInputType.number, amountV,_amountController),
           

            Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Enter Phone Number you are transfer airtime from",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              obscureText: false,
              controller: _phoneController,
              validator: validateMobile,
              keyboardType:TextInputType.number,
              onSaved: (String val) {
                  phoneV = val ;
                  },
              onChanged: (value) {
              
                setState(() {
                  phoneV = value ;
                });
             
                
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                   icon: Icon(Icons.phone_android),
                  filled: true,
                  hintText:"")
                  ),

                 
        ],
      ),
    ),
         Text(
            "Amount to Receive ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              margin: const EdgeInsets.all(2.0),
               padding: const EdgeInsets.fromLTRB(10, 15,100, 15),
              child: Text("₦$amount_to_receive",style:TextStyle(fontSize:15.0) ,),
              decoration: BoxDecoration(
                 
                  //color: Color(0xfff3f3f4),
                  
                  )
                  ) ,
       
                 
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
        title: Text("Airtime Funding Payment", style: TextStyle(color: Colors.white,fontSize:17.0)),
        centerTitle: true,
        backgroundColor: Colors.indigo[900],
        elevation: 0.0,
       
      ),
      body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child:Form(
                     key: _formKey,
                     autovalidate: true  ,
                     child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center ,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                            height: 20,
                          ), 
                          ),
                       
                         
                          _AirtimeFundingfieldsWidget(),
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
            )
          ),
     
      );
  }
}