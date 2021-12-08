import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'airtimereceipt.dart';

class AirtimeH {
  final String network;
  final int id;
  final String phone;
  final String amount;
  final DateTime date;
  final String status;

  AirtimeH(
      {this.id, this.phone, this.amount, this.date, this.status, this.network});

  factory AirtimeH.fromJson(Map<String, dynamic> json) {
    return AirtimeH(
      id: json['id'],
      phone: json["mobile_number"],
      network: json["plan_network"],
      amount: json["plan_amount"],
      date: DateTime.parse(json["create_date"]),
      status: json["Status"],
    );
  }
}

class AirtimeHListView extends StatefulWidget {
  @override
  _airtimeHListViewState createState() => _airtimeHListViewState();
}

class _airtimeHListViewState extends State<AirtimeHListView> {
  SharedPreferences sharedPreferences;

  bool _isLoading = false;
  List mydata;
  List mydata2;
  bool userInput = false;
  TextEditingController searchtext = TextEditingController();
  List<AirtimeH> _searchResult = [];
  List<AirtimeH> AirtimeHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchhistory();
  }

  Widget myicon(String status) {
    if (status == "successful") {
      return Container(
          padding: EdgeInsets.only(top: 2, bottom: 3, left: 5, right: 5),
          decoration: BoxDecoration(
              color: Colors.green[700], borderRadius: BorderRadius.circular(5)),
          child: Text(
            "successful",
            style: TextStyle(color: Colors.white, fontSize: 10),
          ));
    } else if (status == "failed") {
      return Container(
          padding: EdgeInsets.only(top: 2, bottom: 3, left: 5, right: 5),
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(5)),
          child: Text(
            "failed",
            style: TextStyle(color: Colors.white, fontSize: 10),
          ));
    } else if (status == "processing") {
      return Container(
          padding: EdgeInsets.only(top: 2, bottom: 3, left: 5, right: 5),
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(5)),
          child: Text(
            "processing",
            style: TextStyle(color: Colors.white, fontSize: 10),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
              child: Text(
            "Recent Airtime Transactions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          )),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.all(6),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: searchtext,
                        obscureText: false,
                        onChanged: (String val) {
                          onSearchTextChanged(val);
                          if (val.length >= 1) {
                            setState(() {
                              userInput = true;
                            });
                          } else {
                            setState(() {
                              userInput = false;
                            });
                          }
                        },
                        textAlign: TextAlign.left,
                        onSaved: (String val) {},
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search.....',
                        ),
                      ),
                    ),
                  ),
                  searchtext.text.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              searchtext.text = "";
                              _searchResult.clear();
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.cancel_outlined,
                              size: 20.0,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          _searchResult.length != 0 || searchtext.text.isNotEmpty
              ? Expanded(child: _airtimeHListView(_searchResult))
              : Expanded(child: _airtimeHListView(AirtimeHistory)),
        ],
      ),
      inAsyncCall: _isLoading,
    );
  }

  Future<List<AirtimeH>> _fetchhistory() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    sharedPreferences = await SharedPreferences.getInstance();

    final url = 'https://www.voicestelecom.com.ng/api/topup/';
    final response = await get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Token ${sharedPreferences.getString("token")}'
    });

    if (response.statusCode == 200) {
      if (this.mounted) {
        var jsonResponse = json.decode(response.body);

        List resp = jsonResponse["results"];

        setState(() {
          _isLoading = false;
          mydata = resp;
          AirtimeHistory =
              resp.map((history) => new AirtimeH.fromJson(history)).toList();
        });
      }
    } else {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      throw Exception('Failed to load AirtimeH from API');
    }
  }

  Future<List<AirtimeH>> _searchhistory(String query) async {
    setState(() {
      _isLoading = true;
    });

    sharedPreferences = await SharedPreferences.getInstance();

    final url = 'https://www.voicestelecom.com.ng/api/topup/?search=$query';
    final response = await get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Token ${sharedPreferences.getString("token")}'
    });

    print(json.decode(response.body));

    if (response.statusCode == 200) {
      if (json.decode(response.body).length >= 1) {
        var jsonResponse = json.decode(response.body);
        List resp = jsonResponse;
        setState(() {
          _isLoading = false;
          mydata2 = resp;
          _searchResult =
              resp.map((history) => new AirtimeH.fromJson(history)).toList();
        });
        setState(() {
          _isLoading = false;
        });
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });

      throw Exception('Failed to load AirtimeH from API');
    }
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      // setState(() {});
      return;
    }

    _searchhistory(text);

    // setState(() {});
  }

  ListView _airtimeHListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => AirtimeReceipt(
                            data: mydata2 != null
                                ? mydata2[index]
                                : mydata[index])));
              },
              child: _tile(
                  data[index].id,
                  data[index].phone,
                  data[index].amount,
                  data[index].date,
                  data[index].status,
                  data[index].network));
        });
  }

  Widget _tile(int id, String phone, String amount, DateTime date,
          String status, String network) =>
      Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child:
                        Text('₦$amount  $network Airtime Topup  with $phone')),
                myicon(status)
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
