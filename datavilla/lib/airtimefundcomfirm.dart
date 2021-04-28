import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;



class AirtimeFunding_Comfirm extends StatefulWidget {
  String network;
  String phone;
  int amount;

  AirtimeFunding_Comfirm({Key key, this.network, this.amount, this.phone})
      : super(key: key);

  @override
  _AirtimeFunding_ComfirmState createState() => _AirtimeFunding_ComfirmState();
}

class _AirtimeFunding_ComfirmState extends State<AirtimeFunding_Comfirm> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _codeController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double amount_to_receive = 0.0;
  String mtnadmin;
  String gloadmin;
  String airteladmin;
  String mobieadmin;
  int amount_fill = 0;
  var platform;

  //bool _obscureText = true;

  @override
  void initState() {
    filldetails();
    super.initState();
  }

  Widget Instruction() {
    if (widget.network == "MTN") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            "Kindly transfer the sum of ₦${widget.amount} to the phone number shown below",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "$mtnadmin",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "PLEASE NOTE: Due to certain restriction, We cannot automatically deduct airtime, you have to manually transfer the airtime to the phone number above, Thank you ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[400],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "How to transfer airtime on ${widget.network}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.network} Transfer - Default PIN : 0000",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "To Create a new PIN, Dial: *600*0000*NEWPIN*NEWPIN#",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "E.g, *600*0000*5555*5555# ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Dial *600*$mtnadmin*${widget.amount}*5555#   to send the Airtime,Change 5555 to your pin if your already have pin ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              )),
          SizedBox(
            height: 30,
          ),
          Text(
            "Only Click Submit after you have transfer the airtime to avoid your account been Ban",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(
            height: 40,
          ),
          _submitButton(),
          Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        ],
      );
    } else if (widget.network == "GLO") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            "Kindly transfer the sum of ₦${widget.amount} to the phone number shown below",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "${gloadmin}",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "PLEASE NOTE: Due to certain restriction, eRechage does not automatically deduct airtime, you have to manually transfer the airtime to the phone number above, Thank you ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[400],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "How to transfer airtime on ${widget.network}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.network} Transfer - Default PIN : 0000",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "To Create a new PIN, Dial *132*0000*NEWPIN*NEWPIN#",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "E.g, *132*0000*55555*55555# ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Dial **131**${gloadmin}*${widget.amount}*5555#  to send the Airtime, Change 5555 to your pin if your already have pin ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              )),
          SizedBox(
            height: 30,
          ),
          Text(
            "Only Click Submit after you have transfer the airtime to avoid your account been Ban",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(
            height: 40,
          ),
          _submitButton(),
          Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        ],
      );
    } else if (widget.network == "AIRTEL") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            "Kindly transfer the sum of ₦${widget.amount} to the phone number shown below",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "${airteladmin}",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "PLEASE NOTE: Due to certain restriction, eRechage does not automatically deduct airtime, you have to manually transfer the airtime to the phone number above, Thank you ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[400],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "How to transfer airtime on ${widget.network}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.network} Transfer - Default PIN : 0000",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "To Create a new PIN, *432*4*1*1234*NEWPIN*NEWPIN#",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "E.g, *432*4*1*1234*5555*5555# ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Dial *432*1*${airteladmin}*${widget.amount}*5555#  to send the Airtime, Change 5555 to your pin if your already have pin ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              )),
          SizedBox(
            height: 30,
          ),
          Text(
            "Only Click Submit after you have transfer the airtime to avoid your account been Ban",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(
            height: 40,
          ),
          _submitButton(),
          Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        ],
      );
    } else if (widget.network == "9MOBILE") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            "Kindly transfer the sum of ₦${widget.amount} to the phone number shown below",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "${mobieadmin}",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "PLEASE NOTE: Due to certain restriction, eRechage does not automatically deduct airtime, you have to manually transfer the airtime to the phone number above, Thank you ",
            style: GoogleFonts.lato(fontStyle: FontStyle.italic),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[400],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "How to transfer airtime on ${widget.network}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.network} Transfer - Default PIN : 0000",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "To Create a new PIN, Dial: *247*0000*NEWPIN#",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "E.g, *247*0000*5555# ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Dial *223*5555*${mobieadmin}*${widget.amount}#  to send the Airtime , Change 5555 to your pin if your already have pin",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              )),
          SizedBox(
            height: 30,
          ),
          Text(
            "Only Click Submit after you have transfer the airtime to avoid your account been Ban",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(
            height: 40,
          ),
          _submitButton(),
          Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        ],
      );
    }
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getString("AdminNumberMTN"));
    setState(() {
      mtnadmin = pref.getString("AdminNumberMTN");
      gloadmin = pref.getString("AdminNumberGLO");
      airteladmin = pref.getString("AdminNumberAIRTEL");
      mobieadmin = pref.getString("AdminNumber9MOBILE");
    });
  }

  Future<dynamic> _airtimeFunding_Comfirm() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();



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
      String url = 'https://www.elecastlesubng.com/api/Airtime_funding/';
      String net;
      if (widget.network == "MTN") {
        net = "1";
      } else if (widget.network == "GLO") {
        net = "2";
      } else if (widget.network == "AIRTEL") {
        net = "4";
      } else if (widget.network == "9MOBILE") {
        net = "3";
      }

      print(net);

      Response response = await post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
            "amount": widget.amount,
            "network": net,
            "mobile_number": widget.phone,
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

            AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.SUCCES,
              title: 'Success',
              desc:
                  'Your Request has been submitted successfuly , we will process it shortly, \n Thank You',
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
            btnCancelOnPress: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/airtimefundin", (route) => false);
            },
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comfirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you have transfer the airtime to the number?'),
                SizedBox(
                  height: 10,
                ),
                Text(
                    'Note: if you click submit without been transfer , you account will be ban.',
                    style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes Submit'),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() => _isLoading = true);
                await _airtimeFunding_Comfirm();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        _showMyDialog();
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

  Widget _AirtimeFunding_ComfirmfieldsWidget() {
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
              Instruction()
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
          title: Text("Airtime Funding Payment",
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
                    child: Instruction(),
                  ),
                ),
              ],
            ),
          )),
          inAsyncCall: _isLoading,
        ));
  }
}
