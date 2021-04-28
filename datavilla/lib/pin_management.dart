import 'package:flutter/material.dart';
import 'src/Widget/bezierContainer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import './screens/validator.dart';





class PIn extends StatefulWidget {
  final String title;

  PIn({Key key, this.title}) : super(key: key);

  @override
  _PInState createState() => _PInState();
}

class _PInState extends State<PIn> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _new_password1Control = TextEditingController();
  TextEditingController _new_password2Control = TextEditingController();
  TextEditingController _old_passwordControl = TextEditingController();


  TextEditingController _new_passwordControl1 = TextEditingController();
  TextEditingController _new_passwordControl2 = TextEditingController();
  TextEditingController _old_passwordControl2 = TextEditingController();


  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  String oldpass;
  String newpass1;
  String newpass2;

  String oldpass1;
  String newpass11;
  String newpass22;
  bool _obscureText = true;

  //bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }



  Future<dynamic> _Change(String oldpass,
      String newpass1, String newpass2) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      String url = 'https://www.elecastlesubng.com/api/changepin?pin1=$newpass1&pin2=$newpass2&oldpin=$oldpass';
      
    
      Response response = await get(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          );
    

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
              desc: "pin Changed successfully",
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
            desc: responseJson["error"],
            btnCancelOnPress: () {},
            btnCancelText: "ok",
            
          ).show();
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Colors.indigo[900],duration: Toast.LENGTH_SHORT, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

        } else if (responseJson.containsKey("new_password2")) {
          AwesomeDialog(
            context: context,
            animType: AnimType.BOTTOMSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.ERROR,
            title: 'Oops!',
            desc: responseJson["new_password2"],
            btnCancelOnPress: () {},
            btnCancelText: "ok",
          ).show();
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Colors.indigo[900],duration: Toast.LENGTH_SHORT, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

        } else if (responseJson.containsKey("new_password1")) {
          AwesomeDialog(
            context: context,
            animType: AnimType.BOTTOMSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.ERROR,
            title: 'Oops!',
            desc: responseJson["new_password1"],
            btnCancelOnPress: () {
              Navigator.of(context).pushNamed("/home");
            },
            btnCancelText: "ok",
          ).show();
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Colors.indigo[900],duration: Toast.LENGTH_SHORT, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

        } else if (responseJson.containsKey("old_password")) {
          AwesomeDialog(
            context: context,
            animType: AnimType.BOTTOMSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.ERROR,
            title: 'Oops!',
            desc: responseJson["old_password"],
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





  Future<dynamic> _Reset(
      String newpass11, String newpass22,String oldpass1) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      String url = 'https://www.elecastlesubng.com/api/resetpin?password=$oldpass1&pin1=$newpass11&pin2=$newpass22';
      
     print('https://www.elecastlesubng.com/api/resetpin?password=$oldpass1&pin1=$newpass11&pin2=$newpass22');
      Response response = await get(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          );
    

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
              desc: "Pin Reset successfully",
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
            desc: responseJson["error"],
            btnCancelOnPress: () {},
            btnCancelText: "ok",
            
          ).show();
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Colors.indigo[900],duration: Toast.LENGTH_SHORT, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

        } else if (responseJson.containsKey("new_password2")) {
          AwesomeDialog(
            context: context,
            animType: AnimType.BOTTOMSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.ERROR,
            title: 'Oops!',
            desc: responseJson["new_password2"],
            btnCancelOnPress: () {},
            btnCancelText: "ok",
          ).show();
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Colors.indigo[900],duration: Toast.LENGTH_SHORT, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

        } else if (responseJson.containsKey("new_password1")) {
          AwesomeDialog(
            context: context,
            animType: AnimType.BOTTOMSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.ERROR,
            title: 'Oops!',
            desc: responseJson["new_password1"],
            btnCancelOnPress: () {
              Navigator.of(context).pushNamed("/home");
            },
            btnCancelText: "ok",
          ).show();
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Colors.indigo[900],duration: Toast.LENGTH_SHORT, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

        } else if (responseJson.containsKey("old_password")) {
          AwesomeDialog(
            context: context,
            animType: AnimType.BOTTOMSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.ERROR,
            title: 'Oops!',
            desc: responseJson["old_password"],
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
      TextEditingController control,{Function valid}) {
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
            obscureText: _obscureText,
            controller: control,
            keyboardType: mykey,
            validator: valid,
            onSaved: (String val) {
              inputvalue = val;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              icon: Icon(myicon),
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon

                  _obscureText ? Icons.visibility_off : Icons.visibility,

                  color: Colors.grey,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          setState(() => _isLoading = true);
          await _Change(_new_password1Control.text, _new_password2Control.text,
              _old_passwordControl.text);
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
          'Change Pin',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }



  Widget _submitButton2() {
    return InkWell(
      onTap: () async {
        if (_formKey2.currentState.validate()) {
          _formKey2.currentState.save();
          setState(() => _isLoading = true);
          await _Reset(_new_passwordControl1.text, _new_passwordControl2.text,
              _old_passwordControl2.text);
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
          'Reset Pin',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _ChangefieldsWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             
              _entryField("Old Pin ", Icons.verified_user,
                  TextInputType.text, newpass1, _new_password1Control,valid:pinvalid),
              _entryField(" Enter New Pin", Icons.verified_user,
                  TextInputType.text, newpass2, _new_password2Control,valid:pinvalid),
              _entryField("Re-enter New Pin", Icons.verified_user,
                  TextInputType.text, oldpass, _old_passwordControl,valid:pinvalid),
            ],
          ),
        )
      ],
    );
  }

 Widget _ResetfieldsWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             
              _entryField("New Pin ", Icons.verified_user,
                  TextInputType.text, newpass11, _new_passwordControl1,valid:pinvalid),
              _entryField(" Re-enter New Pin", Icons.verified_user,
                  TextInputType.text, newpass22, _new_passwordControl2,valid:pinvalid),
              _entryField("Account Password", Icons.verified_user,
                  TextInputType.text, oldpass1, _old_passwordControl2,valid:passvalid),
            ],
          ),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return 
    DefaultTabController(
        length: 2,
          child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Pin Management",
                style: TextStyle(color: Colors.white, fontSize: 17.0)),
            centerTitle: true,
            backgroundColor: Colors.indigo[900],
            elevation: 0.0,
             bottom: TabBar(
             isScrollable: true,
            indicatorColor:Colors.green,
               
                tabs: [
                  Tab(
                    child:Column(children: <Widget>[
                  
                    Text("Change Pin")

                  ],)
                    ),
                      Tab(
                    child:Column(children: <Widget>[
                   
                    Text("Reset Pin")

                  ],)
                    ),
                      
                    
                
                ],
         
        ),
          
          ),
          body: ModalProgressHUD(
            child: SingleChildScrollView(
                child: Container(
              height: MediaQuery.of(context).size.height,
              child: TabBarView(
            children: <Widget>[
                Stack(
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
                          
                          SizedBox(height:30),
                          Text("Change your Pin",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                          _ChangefieldsWidget(),
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

                Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: _formKey2,
                      autovalidate: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          
                           SizedBox(height:30),
                          Text("Reset your Pin",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                          _ResetfieldsWidget(),
                          SizedBox(
                            height: 20,
                          ),
                          _submitButton2(),
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
               
            ],
          )
      
              
              
            
            )),
            inAsyncCall: _isLoading,
          )),
    );
  }
}
