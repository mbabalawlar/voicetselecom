import 'package:flutter/material.dart';
import 'cablesub.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CableName extends StatefulWidget {
  @override
  _CableNameState createState() => _CableNameState();
}

class _CableNameState extends State<CableName> {
  List<dynamic> gotv;
  List<dynamic> dstv;
  List<dynamic> startime;
  List<dynamic> cablename;
  SharedPreferences sharedPreferences;
  bool _isLoading = false;

  void initState() {
    loadplan();
    super.initState();
  }

  loadplan() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map resJson = json.decode(sharedPreferences.getString("Cableplan"));
    print(sharedPreferences.getString("Cableplan"));

    if (this.mounted) {
      setState(() {
        cablename = resJson["cablename"].map((net) => net["id"]).toList();
        gotv = resJson["GOTVPLAN"];
        dstv = resJson["DSTVPLAN"];
        startime = resJson["STARTIME"];

        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Select Decoder",
            style: TextStyle(color: Colors.white, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0.0,
      ),
      body: ModalProgressHUD(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20.0),
              Expanded(
                  child: GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => CableS(
                                    image: "assets/gotv.jpeg",
                                    id: cablename[0],
                                    plan: gotv)));
                      },
                      child: Material(
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/gotv.jpeg"),
                            radius: 10.0,
                          ),
                          elevation: 50,
                          borderRadius: BorderRadius.circular(10)

                          //borderRadius: BorderRadius.circular(30),

                          ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => CableS(
                                    image: "assets/dstv.jpeg",
                                    id: cablename[1],
                                    plan: dstv)));
                      },
                      child: Material(
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/dstv.jpeg"),
                            radius: 10.0,
                          ),
                          elevation: 50,
                          borderRadius: BorderRadius.circular(10)

                          //borderRadius: BorderRadius.circular(30),

                          ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => CableS(
                                    image: "assets/startime.jpeg",
                                    id: cablename[2],
                                    plan: startime)));
                      },
                      child: Material(
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/startime.jpeg"),
                            radius: 30.0,
                          ),
                          elevation: 50,
                          borderRadius: BorderRadius.circular(10)

                          //borderRadius: BorderRadius.circular(30),

                          ),
                    ),
                  ]))
            ]),
        inAsyncCall: _isLoading,
      ),
    );
  }
}
