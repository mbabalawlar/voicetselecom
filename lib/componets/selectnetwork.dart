import 'package:flutter/material.dart';

class Network extends StatefulWidget {
  @override
  _NetworkState createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var phonesize = MediaQuery.of(context).size;

    return SingleChildScrollView(
        child: Container(
            height: phonesize.height,
            padding: EdgeInsets.fromLTRB(
                phonesize.width * 0.02,
                phonesize.height * 0.03,
                phonesize.width * 0.03,
                phonesize.height * 0.02),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("SELECT NETWORK",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.cancel_sharp,
                      color: Colors.red,
                    ))
              ]),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(height: phonesize.height * 0.01),
            ])));
  }
}
