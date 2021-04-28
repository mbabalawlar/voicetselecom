import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Airtime_fundingH {
  final String network;
  final String id;
  final String phone;
  final String amount;
  final String r_amount;
  final DateTime date;
  final String status;

  Airtime_fundingH(
      {this.r_amount,
      this.id,
      this.phone,
      this.amount,
      this.date,
      this.status,
      this.network});

  factory Airtime_fundingH.fromJson(Map<String, dynamic> json) {
    return Airtime_fundingH(
      id: json['ident'],
      phone: json["mobile_number"],
      network: json["plan_network"],
      amount: json["amount"].toString(),
      r_amount: json["Receivece_amount"].toString(),
      date: DateTime.parse(json["create_date"]),
      status: json["Status"],
    );
  }
}

class Airtime_fundingHListView extends StatefulWidget {
  @override
  _Airtime_fundingHListViewState createState() =>
      _Airtime_fundingHListViewState();
}

class _Airtime_fundingHListViewState extends State<Airtime_fundingHListView> {
  SharedPreferences sharedPreferences;

  bool _isLoading = false;
  List mydata;

  @override
  void initState() {
    super.initState();
  }

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
    return FutureBuilder<List<Airtime_fundingH>>(
      future: _fetchhistory(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Airtime_fundingH> data = snapshot.data;
          return _Airtime_fundingHListView(data);
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

  Future<List<Airtime_fundingH>> _fetchhistory() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    sharedPreferences = await SharedPreferences.getInstance();

    final url = 'https://www.elecastlesubng.com/api/Airtime_funding/';
    final response = await get(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Token ${sharedPreferences.getString("token")}'
    });

    if (response.statusCode == 200) {
      if (this.mounted) {
        setState(() {
          var jsonResponse = json.decode(response.body);
          mydata = jsonResponse;
          _isLoading = false;
        });
      }
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      List resp = jsonResponse;
      return resp
          .map((history) => new Airtime_fundingH.fromJson(history))
          .toList();
    } else {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  ListView _Airtime_fundingHListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].id, data[index].r_amount, data[index].amount,
              data[index].date, data[index].status, data[index].network);
        });
  }

  Card _tile(String id, String receive_amount, String amount, DateTime date,
          String status, String network) =>
      Card(
        child: ListTile(
          //leading: FlutterLogo(size: 72.0),
          title: Text(
              "Ref :$id       ${DateFormat('yyyy-MM-dd – kk:mm a').format(date)}"),
          subtitle: Text(
              '₦$amount  $network Airtime Funding  to receive ₦$receive_amount'),

          trailing: myicon(status),
        ),
      );
}
