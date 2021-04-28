import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class WithdrawView {
  final String accountNumber;
  final String id;
  final String bankName;
  final String accountName;
  final String amount;
  final DateTime date;
  final String status;

  WithdrawView(
      {this.id,
      this.bankName,
      this.accountName,
      this.amount,
      this.date,
      this.status,
      this.accountNumber});

  factory WithdrawView.fromJson(Map<String, dynamic> json) {
    return WithdrawView(
      id: json['ident'],
      bankName: json['bankName'],
      accountName: json["accountName"],
      accountNumber: json["accountNumber"],
      amount: json["amount"],
      date: DateTime.parse(json["create_date"]),
      status: json["Status"],
    );
  }
}

class WithdrawViewListView extends StatefulWidget {
  @override
  _WithdrawViewListViewState createState() => _WithdrawViewListViewState();
}

class _WithdrawViewListViewState extends State<WithdrawViewListView> {
  SharedPreferences sharedPreferences;

  bool _isLoading = false;

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
    return FutureBuilder<List<WithdrawView>>(
      future: _fetchhistory(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<WithdrawView> data = snapshot.data;
          return _WithdrawViewListView(data);
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

  Future<List<WithdrawView>> _fetchhistory() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    sharedPreferences = await SharedPreferences.getInstance();

    final url = 'https://www.elecastlesubng.com/api/withdraw/';
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
      return resp.map((history) => new WithdrawView.fromJson(history)).toList();
    } else {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  ListView _WithdrawViewListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(
              data[index].id,
              data[index].accountName,
              data[index].bankName,
              data[index].amount,
              data[index].date,
              data[index].status,
              data[index].accountNumber);
        });
  }

  Card _tile(String id, String accountName, String bankName, String amount,
          DateTime date, String status, String accountNumber) =>
      Card(
        child: ListTile(
          //leading: FlutterLogo(size: 72.0),
          title: Text(
              "Ref :$id       ${DateFormat('yyyy-MM-dd – kk:mm a').format(date)}"),
          subtitle: Text(
              'Withdraw  Request of ₦$amount to with $bankName,   $accountNumber , $accountName'),

          trailing: myicon(status),
        ),
      );
}
