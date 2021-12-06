import 'package:flutter/material.dart';
import 'bulksmshistory.dart';
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
        length: 9,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("Transactions",
                style: TextStyle(color: Colors.black, fontSize: 17.0)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.green[700],
              tabs: [
                Tab(
                    child: Column(
                  children: <Widget>[
                    Icon(Icons.wifi),
                    Text("Data",
                        style: TextStyle(
                          color: Colors.black,
                        ))
                  ],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[
                    Icon(Icons.phone_iphone),
                    Text("Airtime",
                        style: TextStyle(
                          color: Colors.black,
                        ))
                  ],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[
                    Icon(Icons.tv),
                    Text("Cablesub",
                        style: TextStyle(
                          color: Colors.black,
                        ))
                  ],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[
                    Icon(Icons.lightbulb_outline),
                    Text("Electricity",
                        style: TextStyle(
                          color: Colors.black,
                        ))
                  ],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[
                    Icon(Icons.attach_money),
                    Text("Withdraw",
                        style: TextStyle(
                          color: Colors.black,
                        ))
                  ],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[
                    Icon(Icons.phone_iphone),
                    Text("Airtime Funding",
                        style: TextStyle(
                          color: Colors.black,
                        ))
                  ],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[
                    Icon(Icons.book),
                    Text("Result Checker",
                        style: TextStyle(
                          color: Colors.black,
                        ))
                  ],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[
                    Icon(Icons.print),
                    Text("Recharge Card",
                        style: TextStyle(
                          color: Colors.black,
                        ))
                  ],
                )),
                Tab(
                    child: Column(
                  children: <Widget>[
                    Icon(Icons.print),
                    Text("Bulk SMS",
                        style: TextStyle(
                          color: Colors.black,
                        ))
                  ],
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
                  BulksmshistoryListView(),
                ],
              )),
        ));
  }
}
