import 'package:flutter/material.dart';

class OperationModel {
  String name;
  IconData selectedIcon;
  IconData unselectedIcon;
  String link;
  OperationModel(this.name, this.selectedIcon, this.unselectedIcon, this.link);
}

List<OperationModel> datas = operationsData
    .map((item) => OperationModel(item['name'], item['selectedIcon'],
        item['unselectedIcon'], item['link']))
    .toList();

var operationsData = [
  {
    "name": "Buy\nData",
    "selectedIcon": Icons.wifi,
    "unselectedIcon": Icons.wifi,
    "link": "/datanet"
  },
  {
    "name": "Buy\nAirtime",
    "selectedIcon": Icons.phone_android,
    "unselectedIcon": Icons.phone_android,
    "link": "/airtimenet"
  },
  {
    "name": "Recharge\nPrinting",
    "selectedIcon": Icons.print,
    "unselectedIcon": Icons.print,
    "link": '/recharge'
  },
  {
    "name": "Bill\nPayment",
    "selectedIcon": Icons.lightbulb_outline,
    "unselectedIcon": Icons.lightbulb_outline,
    "link": "/bill"
  },
  {
    "name": "Cable\nSubscription",
    "selectedIcon": Icons.live_tv,
    "unselectedIcon": Icons.live_tv,
    "link": "/cablename"
  },
  {
    "name": "Result\nChecker",
    "selectedIcon": Icons.book,
    "unselectedIcon": Icons.book,
    "link": "/ResultChecker"
  },
  {
    "name": "Airtime to\nCash",
    "selectedIcon": Icons.track_changes,
    "unselectedIcon": Icons.track_changes,
    "link": "/airtimefundin"
  },
];

List<OperationModel> datas2 = operationsData2
    .map((item) => OperationModel(item['name'], item['selectedIcon'],
        item['unselectedIcon'], item['link']))
    .toList();

var operationsData2 = [
  {
    "name": "I've a\nComplain",
    "selectedIcon": Icons.chat_bubble_rounded,
    "unselectedIcon": Icons.chat_bubble_rounded,
    "link": "/complain"
  },
  {
    "name": "Fund Wallet\nATM",
    "selectedIcon": Icons.credit_card,
    "unselectedIcon": Icons.credit_card,
    "link": "/atm"
  },
  {
    "name": "Fund Wallet\nBank",
    "selectedIcon": Icons.branding_watermark,
    "unselectedIcon": Icons.branding_watermark,
    "link": "/bank"
  },
  {
    "name": "Wallet \nSummary",
    "selectedIcon": Icons.store,
    "unselectedIcon": Icons.store,
    "link": "/wallet"
  },
  {
    "name": "Transactions",
    "selectedIcon": Icons.history,
    "unselectedIcon": Icons.history,
    "link": "/history"
  },
  {
    "name": "Bonus to\nwallet",
    "selectedIcon": Icons.money_off,
    "unselectedIcon": Icons.money_off,
    "link": "/bonus"
  },
  {
    "name": "Visit\nwebsite",
    "selectedIcon": Icons.explore_outlined,
    "unselectedIcon": Icons.explore_outlined,
    "link": "/web"
  },
];
