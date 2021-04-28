import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'screens/result_checker_receipt.dart';

class ResultH {
  final int id;
  final String quantity;
  final String exam_name;
  final String amount;
    final String data;
  final DateTime date;
  final String status;

  ResultH({
    this.id,
    this.quantity,
    this.exam_name,
    this.amount,
    this.date,
    this.data,
    this.status,
  });

  factory ResultH.fromJson(Map<String, dynamic> json) {
    return ResultH(
      id: json['id'],
      quantity: json["quantity"].toString(),
      exam_name: json["exam_name"],
       data: json["data"],
      amount: json["amount"].toString(),
      date: DateTime.parse(json["create_date"]),
      status: json["Status"],
    );
  }
}

class ResultHListView extends StatefulWidget {
  @override
  _ResultHListViewState createState() => _ResultHListViewState();
}

class _ResultHListViewState extends State<ResultHListView> {
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
    return FutureBuilder<List<ResultH>>(
      future: _fetchhistory(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ResultH> data = snapshot.data;
          return _ResultHListView(data);
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

  Future<List<ResultH>> _fetchhistory() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    sharedPreferences = await SharedPreferences.getInstance();

    final url = 'https://www.elecastlesubng.com/api/epin/';
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
      return resp.map((history) => new ResultH.fromJson(history)).toList();
    } else {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      throw Exception('Failed to load ResultH from API');
    }
  }

  ListView _ResultHListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            ResultReceipt(data: mydata[index])));
              },
              child: _tile(
                  data[index].id,
                  data[index].quantity,
                  data[index].exam_name,
                  data[index].amount,
                  data[index].date,
                  data[index].status));
        });
  }

  Card _tile(int id, String quantity, String exam_name, String amount,
          DateTime date, String status) =>
      Card(
        child: ListTile(
          //leading: FlutterLogo(size: 72.0),
          title: Text(
              "Ref :$id       ${DateFormat('yyyy-MM-dd – kk:mm a').format(date)}"),
          subtitle: Text(
              'successfully purchased  $quantity pieces of $exam_name  epin, ₦$amount '),
          isThreeLine: true,
          trailing: myicon(status),
        ),
      );
}
