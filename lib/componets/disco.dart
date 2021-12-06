import 'package:flutter/material.dart';

class DiscoSlecetionBox extends StatefulWidget {
  final String selecteddisco;

  DiscoSlecetionBox({Key key, this.selecteddisco}) : super(key: key);
  @override
  _DiscoSlecetionBoxState createState() => _DiscoSlecetionBoxState();
}

class _DiscoSlecetionBoxState extends State<DiscoSlecetionBox> {
  List<Map> _discolist = [
    {"value": 1, "name": "Ikeja Electric", "logo": "assets/ikeja.jpg"},
    {"value": 2, "name": "Eko Electric", "logo": "assets/eko.jpg"},
    {"value": 3, "name": "Abuja Electric", "logo": "assets/abuja.jpg"},
    {"value": 4, "name": "Kano Electric", "logo": "assets/kano.png"},
    {"value": 5, "name": "Enugu Electric", "logo": "assets/enugu.jpeg"},
    {
      "value": 6,
      "name": "Port Harcourt Electric",
      "logo": "assets/porthacout.jpg"
    },
    {"value": 7, "name": "Ibadan Electric", "logo": "assets/ibadan.png"},
    {"value": 8, "name": "Kaduna Electric", "logo": "assets/kaduna.jpg"},
    {"value": 9, "name": "Jos Electric", "logo": "assets/jos.jpeg"},
    {"value": 10, "name": "Benin Electric", "logo": "assets/benin.jpeg"},
    {"value": 11, "name": "Yola Electric", "logo": "assets/yola.jpg"},
  ];
  bool userInput = false;
  TextEditingController searchtext = TextEditingController();
  List _searchResult = [];

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _discolist.forEach((plan) {
      if (plan['name'].toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(plan);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.navigate_before,
                      size: 35.0,
                    ),
                  ),
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
                        onSaved: (String val) {},
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                        ),
                      ),
                    ),
                  ),
                  userInput
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              searchtext.text = " ";
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.cancel_outlined,
                              size: 25.0,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              )),
        ),
      ),
      body: _searchResult.length != 0 || searchtext.text.isNotEmpty
          ? ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, _searchResult[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                            color: widget.selecteddisco ==
                                    _searchResult[index]["name"]
                                ? Colors.red.shade300
                                : Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage(_searchResult[index]['logo']),
                            radius: 25.0,
                          ),
                          SizedBox(width: 15),
                          Text(
                            "${_searchResult[index]['name']} ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: _discolist.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, _discolist[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                            color: widget.selecteddisco ==
                                    _discolist[index]["name"]
                                ? Colors.red.shade300
                                : Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage(_discolist[index]['logo']),
                            radius: 25.0,
                          ),
                          SizedBox(width: 15),
                          Text(
                            "${_discolist[index]['name']} ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
