import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:json_table/json_table.dart';
import 'package:intl/intl.dart';

class WalletSummary extends StatefulWidget {
  final String title;

  WalletSummary({Key key, this.title}) : super(key: key);

  @override
  _WalletSummaryState createState() => _WalletSummaryState();
}

class _WalletSummaryState extends State<WalletSummary> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  List mydata;

  @override
  void initState() {
    fetchhistory();
    super.initState();
  }

  static String dateformat(value) {
    return "${DateFormat('yyyy-MM-dd – kk:mm a').format(DateTime.parse(value))}";
  }

  static String amountformat(value) {
    return "₦$value";
  }

  var columns = [
    JsonTableColumn("ident", label: "Reference"),
    JsonTableColumn("product", label: "Product"),
    JsonTableColumn("amount", label: "Amount", valueBuilder: amountformat),
    JsonTableColumn("previous_balance",
        label: "Previous Balance", valueBuilder: amountformat),
    JsonTableColumn("after_balance",
        label: "After Balance", valueBuilder: amountformat),
    JsonTableColumn("create_date",
        label: "Date", defaultValue: "NA", valueBuilder: dateformat),
  ];

  Future fetchhistory() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences = await SharedPreferences.getInstance();
    try {
      final url = 'https://www.elecastlesubng.com/api/Wallet_summary/';
      final response = await get(url, headers: {
        "Content-Type": "application/json",
        'Authorization': 'Token ${sharedPreferences.getString("token")}'
      }).timeout(const Duration(seconds: 30));

      print(response.body);
      if (response.statusCode == 200) {
        if (this.mounted) {
          setState(() {
            mydata = jsonDecode(response.body) as List;
            _isLoading = false;
          });

          print(mydata);
        }
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        throw Exception('Failed to load DataH from API');
      }
    } on TimeoutException catch (e) {
      setState(() {
        _isLoading = false;
      });

      Toast.show("Oops ,request is taking much time to response, please retry",
          context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM);
    } on Error catch (e) {
      setState(() {
        _isLoading = false;
      });

      Toast.show("Oops ,Unexpected error occured", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM);
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Wallet Sumamry",
              style: TextStyle(color: Colors.white, fontSize: 17.0)),
          centerTitle: true,
          backgroundColor: Colors.indigo[900],
          elevation: 0.0,
        ),
        body: ModalProgressHUD(
          child: SingleChildScrollView(
            child: (mydata == null || mydata.isEmpty)?
            Container (
              height:MediaQuery.of(context).size.height,
              width:MediaQuery.of(context).size.width,
              
              child: Center(child: Text("You have not perform any Transaction",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold))),):
                JsonTable(
                    mydata,
                    columns: columns,
                    paginationRowCount: 25,
                    showColumnToggle: true,
                  )
                
          ),
          inAsyncCall: _isLoading,
        ));
  }
}
