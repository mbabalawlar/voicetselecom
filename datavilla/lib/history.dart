import 'package:flutter/material.dart';

import 'datahistory.dart';
import 'airtimehistory.dart';
import 'cablehistory.dart';
import 'billhistory.dart';
import 'withdrawhistory.dart';
import 'airtime_funding_history.dart';
import 'result_history.dart';
import 'recharge_history.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 8,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Transactions",
                style: TextStyle(color: Colors.white, fontSize: 17.0)),
            centerTitle: true,
            backgroundColor: Colors.indigo[900],
            elevation: 0.0,
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.green,
              tabs: [
                Tab(
                    child: Column(
                  children: <Widget>[Icon(Icons.wifi), Text("Data")],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[Icon(Icons.phone_iphone), Text("Airtime")],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[Icon(Icons.tv), Text("Cablesub")],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[
                    Icon(Icons.lightbulb_outline),
                    Text("Electricity")
                  ],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[
                    Icon(Icons.attach_money),
                    Text("Withdraw")
                  ],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[
                    Icon(Icons.phone_iphone),
                    Text("Airtime Funding")
                  ],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[Icon(Icons.book), Text("Result Checker")],
                )),

                 Tab(
                    child: Column(
                  children: <Widget>[Icon(Icons.print), Text("Recharge Card")],
                )),
              ],
            ),
          ),
          body: Padding(
              padding: EdgeInsets.all(10.0),
              child: TabBarView(
                children: <Widget>[
                  DataHListView(),
                  AirtimeHListView(),
                  CableHListView(),
                  BillHListView(),
                  WithdrawViewListView(),
                  Airtime_fundingHListView(),
                  ResultHListView(),
                  RechargeHListView(),
                ],
              )),
        ));
  }
}
