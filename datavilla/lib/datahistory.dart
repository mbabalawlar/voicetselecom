import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'datareceipt.dart';

class DataH {
  final String network;
  final int id;
  final String phone;
  final String plan;
  final String amount;
  final DateTime date;
  final String status;

  DataH(
      {this.id,
      this.phone,
      this.plan,
      this.amount,
      this.date,
      this.status,
      this.network});

  factory DataH.fromJson(Map<String, dynamic> json) {
    return DataH(
      id: json['id'],
      phone: json["mobile_number"],
      plan: json["plan_name"],
      network: json["plan_network"],
      amount: json["plan_amount"],
      date: DateTime.parse(json["create_date"]),
      status: json["Status"],
    );
  }
}

class DataHListView extends StatefulWidget {
  @override
  _DataHListViewState createState() => _DataHListViewState();
}

class _DataHListViewState extends State<DataHListView> {
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
    return FutureBuilder<List<DataH>>(
      future: _fetchhistory(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DataH> data = snapshot.data;
          return _dataHListView(data);
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

  Future<List<DataH>> _fetchhistory() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    sharedPreferences = await SharedPreferences.getInstance();

    final url = 'https://www.elecastlesubng.com/api/data/';
    final response = await get(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Token ${sharedPreferences.getString("token")}'
    });

    if (response.statusCode == 200) {
      if (this.mounted) {
        setState(() {
          var jsonResponse = json.decode(response.body);
          mydata = jsonResponse["results"];
          // print(jsonResponse["results"][0]);
          _isLoading = false;
        });
      }
      var jsonResponse = json.decode(response.body);

      List resp = jsonResponse["results"];
      return resp.map((history) => new DataH.fromJson(history)).toList();
    } else {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      throw Exception('Failed to load DataH from API');
    }
  }

  ListView _dataHListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            DataReceipt(data: mydata[index])));
              },
              child: _tile(
                  data[index].id,
                  data[index].phone,
                  data[index].plan,
                  data[index].amount,
                  data[index].date,
                  data[index].status,
                  data[index].network));
        });
  }

  Card _tile(int id, String phone, String plan, String amount, DateTime date,
          String status, String network) =>
      Card(
        child: ListTile(
          //leading: FlutterLogo(size: 72.0),
          title: Text(
              "Ref :$id  ${DateFormat('yyyy-MM-dd – kk:mm a').format(date)}"),
          subtitle: Text('$plan Data $network Puchase, ₦$amount with $phone'),

          trailing: myicon(status),
        ),
      );
}
