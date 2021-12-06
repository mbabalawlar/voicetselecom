import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Bulksmshistory {
  final String sendername;
  final String id;
  final double page;
  final String message;
  final double amount;
  final DateTime date;

  Bulksmshistory(
      {this.id,
      this.page,
      this.message,
      this.amount,
      this.date,
      this.sendername});

  factory Bulksmshistory.fromJson(Map<String, dynamic> json) {
    return Bulksmshistory(
      id: json['ident'],
      page: json['page'],
      message: json["message"],
      sendername: json["sendername"],
      amount: json["amount"],
      date: DateTime.parse(json["create_date"]),
    );
  }
}

class BulksmshistoryListView extends StatefulWidget {
  @override
  _BulksmshistoryListViewState createState() => _BulksmshistoryListViewState();
}

class _BulksmshistoryListViewState extends State<BulksmshistoryListView> {
  SharedPreferences sharedPreferences;

  bool _isLoading = false;

  Widget myicon() {
    return Container(
        padding: EdgeInsets.only(top: 2, bottom: 3, left: 5, right: 5),
        decoration: BoxDecoration(
            color: Colors.green[700], borderRadius: BorderRadius.circular(5)),
        child: Text(
          "successful",
          style: TextStyle(color: Colors.white, fontSize: 10),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Bulksmshistory>>(
      future: _fetchhistory(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Bulksmshistory> data = snapshot.data;
          return _BulksmshistoryListView(data);
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

  Future<List<Bulksmshistory>> _fetchhistory() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    sharedPreferences = await SharedPreferences.getInstance();

    final url = 'https://voicestelecom.com.ng/api/sendsms/';
    final response = await get(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Token ${sharedPreferences.getString("token")}'
    });

    if (response.statusCode == 200) {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      print("hhwehhdfhghhhhhhhhhhhhhhhhhh");
      List resp = jsonResponse;
      return resp
          .map((history) => new Bulksmshistory.fromJson(history))
          .toList();
    } else {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  ListView _BulksmshistoryListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].id, data[index].message, data[index].page,
              data[index].amount, data[index].date, data[index].sendername);
        });
  }

  Widget _tile(String id, String message, double page, double amount,
          DateTime date, String sendername) =>
      Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$message \nsendername $sendername"),
            Divider(
              color: Colors.green.shade200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                        'successfully sent ,  $page ${page > 1 ? 'pages used' : 'page used'} amount charge  ₦$amount,   ')),
                myicon()
              ],
            ),
            Divider(
              color: Colors.green.shade200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                        '${DateFormat('yyyy-MM-dd – kk:mm a').format(date)}')),
                // Expanded(child: Text("Transacton ID - $id ")),
              ],
            )
          ],
        ),
      );
}
