import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'billreceipt.dart';

class BillH {
  final int id;
  final String phone;
  final String plan;
  final String amount;
  final DateTime date;
  final String status;
  final String token;

  BillH(
      {this.id,
      this.phone,
      this.plan,
      this.amount,
      this.date,
      this.status,
      this.token});

  factory BillH.fromJson(Map<String, dynamic> json) {
    return BillH(
      id: json['id'],
      phone: json["meter_number"],
      plan: json["package"],
      amount: json["amount"],
      token: json["token"],
      date: DateTime.parse(json["create_date"]),
      status: json["Status"],
    );
  }
}

class BillHListView extends StatefulWidget {
  @override
  _BillHListViewState createState() => _BillHListViewState();
}

class _BillHListViewState extends State<BillHListView> {
  SharedPreferences sharedPreferences;

  bool _isLoading = false;
  List mydata;

  CircleAvatar myicon(String status) {
    if (status == "successful") {
      return CircleAvatar(
          radius: 12.0, backgroundColor: Colors.green, child: Icon(Icons.done));
    } else if (status == "failed") {
      return CircleAvatar(
          radius: 12.0,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.cancel,
            color: Colors.red,
          ));
    } else if (status == "processing") {
      return CircleAvatar(
          radius: 12.0,
          backgroundColor: Colors.blue[500],
          child: Icon(Icons.rotate_left));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BillH>>(
      future: _fetchhistory(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<BillH> data = snapshot.data;
          return _BillHListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return ModalProgressHUD(
          child: SizedBox(),
          inAsyncCall: _isLoading,
        );
      },
    );
  }

  Future<List<BillH>> _fetchhistory() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    sharedPreferences = await SharedPreferences.getInstance();

    final url = 'https://www.elecastlesubng.com/api/billpayment/';
    final response = await get(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Token ${sharedPreferences.getString("token")}'
    });

    if (response.statusCode == 200) {
      if (this.mounted) {
        setState(() {
          var jsonResponse = json.decode(response.body);
          mydata = jsonResponse["results"];
          _isLoading = false;
        });
      }
      var jsonResponse = json.decode(response.body);
      print(jsonResponse["results"]);
      List resp = jsonResponse["results"];
      return resp.map((history) => new BillH.fromJson(history)).toList();
    } else {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      throw Exception('Failed to load BillH from API');
    }
  }

  ListView _BillHListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            Billreceipt(data: mydata[index])));
              },
              child: _tile(
                  data[index].id,
                  data[index].phone,
                  data[index].plan,
                  data[index].amount,
                  data[index].date,
                  data[index].status,
                  data[index].token));
        });
  }

  Card _tile(int id, String phone, String plan, String amount, DateTime date,
          String status, String token) =>
      Card(
        child: ListTile(
          //leading: FlutterLogo(size: 72.0),
          title: Text(
              "Ref :$id       ${DateFormat('yyyy-MM-dd – kk:mm a').format(date)}"),
          subtitle:
              Text('$plan  Puchase, ₦$amount with $phone \n Token $token'),
          isThreeLine: true,
          trailing: myicon(status),
        ),
      );
}
