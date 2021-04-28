
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'dart:async';
import 'dart:convert';
import 'package:datavilla/screens/validator.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'datareceipt.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';




class Bottom_pin extends StatefulWidget {
  final String title;
  var onTap;


  Bottom_pin({this.title, this.onTap});

  @override
  _Bottom_pinState createState() => _Bottom_pinState();
}

class _Bottom_pinState extends State<Bottom_pin> {
 final TextEditingController _pinPutController = TextEditingController();
  final TextEditingController _pinPutController2 = TextEditingController();
   final TextEditingController _pinPutController3 = TextEditingController();
   bool _isLoading= false;
  final FocusNode _pinPutFocusNode = FocusNode();
    final FocusNode _pinPutFocusNode2 = FocusNode();
      final FocusNode _pinPutFocusNode3 = FocusNode();
      String pin1;
      String pin2;
  String pin;
  bool isPin = false;


@override
  void initState() {
    
    filldetails();
    
    super.initState();

    
    
    
  }



  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }


  
  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        pin  = pref.getString("pin");
        
      });
      
    }

print("musa'");
print(pin);



    if (pin != null){
     setState(() {
       
       isPin = true;
     });
    }

  }

  Future<dynamic> _validate_pin(pin) async {
    setState(() {
            _isLoading= true;
          });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      String url = 'https://www.elecastlesubng.com//api/checkpin?pin=$pin';

      Response response = await get(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
        );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // if (this.mounted) {
        //   setState(() {
        //     _isLoading= false;
        //   });
        // }
        
        print("correct");
        Navigator.of(context).pop();
        await widget.onTap();

      } else if (response.statusCode == 500) {
        if (this.mounted) {
          setState(() {
            _isLoading= false;
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
            _isLoading= false;
             _pinPutController.text = "";
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
            desc: responseJson["error"],
            btnCancelOnPress: () {},
            btnCancelText: "ok",
          ).show();
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Colors.indigo[900],duration: Toast.LENGTH_SHORT,gravity:  Toast.CENTER);

        }
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading= false;
            _pinPutController.text = "";
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




  Future<dynamic> _set_pin(pin1,pin2) async {
    setState(() {
            _isLoading= true;
          });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   print(pin1);
   print(pin2);
       try {
      String url = 'https://www.elecastlesubng.com/api/pin?pin1=$pin1&pin2=$pin2';

      Response response = await get(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
        );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // if (this.mounted) {
        //   setState(() {
        //     _isLoading= false;
        //   });
        // }
        
      setState(() {
            _isLoading= false;
            isPin =true;

          });

          Toast.show("Transaction pin set successfully", context,
            backgroundColor: Colors.green,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);

      } else if (response.statusCode == 500) {
        if (this.mounted) {
          setState(() {
            _isLoading= false;
            _pinPutController2.text = "";
            _pinPutController2.text = "";


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
            _isLoading= false;
             _pinPutController2.text = "";
             _pinPutController3.text = "";
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
            desc: responseJson["error"],
            btnCancelOnPress: () {},
            btnCancelText: "ok",
          ).show();
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Colors.indigo[900],duration: Toast.LENGTH_SHORT,gravity:  Toast.CENTER);

        }
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading= false;
            _pinPutController.text = "";
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

  @override
  Widget build(BuildContext context) {
   var phonesize = MediaQuery.of(context).size;
   
        return  isPin? Container(
          padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            
                            borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)
                              )),
                          
                        child: Column(
                          children:[
                            Row(
                              
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:[
                                Text("Comfirm Transaction",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                                InkWell(onTap: (){Navigator.of(context).pop();},

                                child: Icon(Icons.cancel_sharp,color: Colors.red,))
                              ]
                            ),

                             Divider(height: 20,),
                             SizedBox(height:20),

                             Text(widget.title,style:TextStyle(fontSize: 17)),


                          Divider(color:Colors.grey,),
                            
                          SizedBox(height:10),
                             Text("ENTER PIN TO COMFIRM",style:TextStyle(fontWeight: FontWeight.bold)),

                            SizedBox(height:15),
                             Container(
                                padding: EdgeInsets.fromLTRB(phonesize.width * 0.17, 0, phonesize.width * 0.17,0),
                              child: PinPut(
                              validator: (s) {
                                if (s.contains('1')) return null;
                                return 'NOT VALID';
                              },
                              useNativeKeyboard: false,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              withCursor: true,
                              fieldsCount: 5,
                              obscureText: "●",
                              fieldsAlignment: MainAxisAlignment.spaceAround,
                              textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
                              eachFieldMargin: EdgeInsets.all(0),
                              eachFieldWidth: phonesize.width * 0.01,
                              eachFieldHeight: phonesize.height * 0.01,
                              onSubmit: (String pin) => _validate_pin(pin),
                              focusNode: _pinPutFocusNode,
                              controller: _pinPutController,
                              submittedFieldDecoration: _pinPutDecoration,
                              selectedFieldDecoration: _pinPutDecoration.copyWith(
                                color: Colors.white,
                                border: Border.all(
                                  width: 2,
                                  color: const Color.fromRGBO(160, 215, 220, 1),
                                ),
                              ),
                              followingFieldDecoration: _pinPutDecoration,
                              pinAnimationType: PinAnimationType.scale,
                            ),
                                            ),
SizedBox(height: phonesize.height * 0.01),
          _isLoading? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
           
            
           Text("Processing..."),
    SizedBox(width:2),
            CircularProgressIndicator(),
          ],
        ):Container(
            padding: EdgeInsets.fromLTRB(phonesize.width * 0.2, 0, phonesize.width * 0.2,phonesize.height * 0.01),
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            
              childAspectRatio: 1,
              padding: const EdgeInsets.all(2),
              physics: NeverScrollableScrollPhysics(),
              children: [
                ...[1, 2, 3, 4, 5, 6, 7, 8, 9, 0].map((e) {
                  return RoundedButton(
                    title: '$e',
                    onTap: () {
                      _pinPutController.text = '${_pinPutController.text}$e';
                    },
                  );
                }),
                RoundedButton(
                  title: '<-',
                  onTap: () {
                    if (_pinPutController.text.isNotEmpty) {
                      _pinPutController.text = _pinPutController.text
                          .substring(0, _pinPutController.text.length - 1);
                    }
                  },
                ),]
                          ),
          )
                           ]) ):Container(
          padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            
                            borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)
                              )),
                          
                        child: Column(
                          children:[
                            Row(
                              
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:[
                                Text("Comfirm Transaction",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                                InkWell(onTap: (){Navigator.of(context).pop();},

                                child: Icon(Icons.cancel_sharp,color: Colors.red,))
                              ]
                            ),

                             Divider(height: 20,color:Colors.grey),
                             SizedBox(height:20),

                             Center(child: Text("You have not set transaction pin , Please set Transaction pin to comfirm this Transaction",style:TextStyle(fontSize: 17))),
                             SizedBox(height:20),

                             SizedBox(height:10),
                             Text("ENTER PIN ",style:TextStyle(fontWeight: FontWeight.bold)),

                            SizedBox(height:15),
                             Container(
                                padding: EdgeInsets.fromLTRB(phonesize.width * 0.17, 0, phonesize.width * 0.17,0),
                              child: PinPut(
                              validator: (s) {
                                if (s.contains('1')) return null;
                                return 'NOT VALID';
                              },
                              useNativeKeyboard: true,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              withCursor: true,
                              fieldsCount: 5,
                              obscureText: "●",
                              
                              fieldsAlignment: MainAxisAlignment.spaceAround,
                              textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
                              eachFieldMargin: EdgeInsets.all(0),
                              eachFieldWidth: phonesize.width * 0.01,
                              eachFieldHeight: phonesize.height * 0.01,
                             onSubmit: (String pin) {
                                setState((){
                                  pin1=pin;
                                });
                                },
                              focusNode: _pinPutFocusNode2,
                              controller: _pinPutController2,
                              submittedFieldDecoration: _pinPutDecoration,
                              selectedFieldDecoration: _pinPutDecoration.copyWith(
                                color: Colors.white,
                                border: Border.all(
                                  width: 2,
                                  color: const Color.fromRGBO(160, 215, 220, 1),
                                ),
                              ),
                              followingFieldDecoration: _pinPutDecoration,
                              pinAnimationType: PinAnimationType.scale,
                            ),
                                            ),
                                            SizedBox(height:10),
                             Text("RE-ENTER PIN",style:TextStyle(fontWeight: FontWeight.bold)),

                            SizedBox(height:15),
                             Container(
                                padding: EdgeInsets.fromLTRB(phonesize.width * 0.17, 0, phonesize.width * 0.17,0),
                              child: PinPut(
                              validator: (s) {
                                if (s.contains('1')) return null;
                                return 'NOT VALID';
                              },
                              useNativeKeyboard:true,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              withCursor: false,
                              fieldsCount: 5,
                              obscureText: "●",
                              fieldsAlignment: MainAxisAlignment.spaceAround,
                              textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
                              eachFieldMargin: EdgeInsets.all(0),
                              eachFieldWidth: phonesize.width * 0.01,
                              eachFieldHeight: phonesize.height * 0.01,
                              onSubmit: (String pin) {
                                setState((){
                                  pin2=pin;
                                });
                                },
                              focusNode: _pinPutFocusNode3,
                              controller: _pinPutController3,
                              submittedFieldDecoration: _pinPutDecoration,
                              selectedFieldDecoration: _pinPutDecoration.copyWith(
                                color: Colors.white,
                                border: Border.all(
                                  width: 2,
                                  color: const Color.fromRGBO(160, 215, 220, 1),
                                ),
                              ),
                              followingFieldDecoration: _pinPutDecoration,
                              pinAnimationType: PinAnimationType.scale,
                            ),
                                            ),

                                          SizedBox(height:15),
                                       _isLoading? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                
                                  
                                Text("Processing..."),
                          SizedBox(width:2),
                                  CircularProgressIndicator(),
                                ],
                              ):InkWell(onTap:(){
                               _set_pin(pin1,pin2);
                                                            }   ,
                              child: Container(
                                    width: MediaQuery.of(context).size.width/3.5,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
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
                                            colors: [Colors.indigo, Colors.indigo])),
                                    child: Text(
                                      'Set pin',
                                      style: TextStyle(fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                             ),
                        
                          ]));

  
  }
}






class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  RoundedButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height:5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color.fromRGBO(25, 21, 99, 1),
        ),
        alignment: Alignment.center,
        child: Text(
          '$title',
          style: TextStyle(fontSize:20, color: Colors.white),
        ),
      ),
    );
  }
}