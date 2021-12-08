import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'recharge_receipt.dart';

class RechargeH {
  final int id;
  final String quantity;
  final String network_name;
  final String amount;
  final List<dynamic> data;
  final DateTime date;
  final String name_on_card;

  RechargeH({
    this.id,
    this.quantity,
    this.network_name,
    this.amount,
    this.date,
    this.data,
    this.name_on_card,
  });

  factory RechargeH.fromJson(Map<String, dynamic> json) {
    return RechargeH(
      id: json['id'],
      quantity: json["quantity"].toString(),
      network_name: json["network_name"],
      data: json["data_pin"],
      amount: json["amount"].toString(),
      date: DateTime.parse(json["create_date"]),
      name_on_card: json["name_on_card"],
    );
  }
}

class RechargeHListView extends StatefulWidget {
  @override
  _RechargeHListViewState createState() => _RechargeHListViewState();
}

class _RechargeHListViewState extends State<RechargeHListView> {
  SharedPreferences sharedPreferences;

  bool _isLoading = false;
  List mydata;

  CircleAvatar myicon(String name_on_card) {
    if (name_on_card == "successful") {
      return CircleAvatar(
          radius: 12.0,
          backgroundColor: Colors.green[700],
          child: Icon(Icons.done));
    } else if (name_on_card == "failed") {
      return CircleAvatar(
          radius: 12.0,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.cancel,
            color: Colors.red,
          ));
    } else if (name_on_card == "processing") {
      return CircleAvatar(
          radius: 12.0,
          backgroundColor: Colors.green[700],
          child: Icon(Icons.rotate_left));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RechargeH>>(
      future: _fetchhistory(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<RechargeH> data = snapshot.data;
          return _RechargeHListView(data);
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

  Future<List<RechargeH>> _fetchhistory() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    sharedPreferences = await SharedPreferences.getInstance();

    final url = 'https://www.voicestelecom.com.ng/api/rechargepin';
    final response = await get(Uri.parse(url), headers: {
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

      List resp = jsonResponse["results"];
      return resp.map((history) => new RechargeH.fromJson(history)).toList();
    } else {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      throw Exception('Failed to load RechargeH from API');
    }
  }

  ListView _RechargeHListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            RechargeReceipt(data: mydata[index])));
              },
              child: _tile(
                  data[index].id,
                  data[index].quantity,
                  data[index].network_name,
                  data[index].amount,
                  data[index].date,
                  data[index].name_on_card));
        });
  }

  Card _tile(int id, String quantity, String network_name, String amount,
          DateTime date, String name_on_card) =>
      Card(
        child: ListTile(
          //leading: FlutterLogo(size: 72.0),
          title: Text(
              "Ref :$id       ${DateFormat('yyyy-MM-dd – kk:mm a').format(date)}"),
          subtitle: Text(
              'successfully purchased  $quantity pieces of $network_name  Recharge card pin, ₦$amount '),
          isThreeLine: true,
          trailing: myicon(name_on_card),
        ),
      );
}
