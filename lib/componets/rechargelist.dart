import 'package:flutter/material.dart';

class RechargeSlecetionBox extends StatefulWidget {
  final List<dynamic> plan;

  RechargeSlecetionBox({Key key, @required this.plan}) : super(key: key);
  @override
  _RechargeSlecetionBoxState createState() => _RechargeSlecetionBoxState();
}

class _RechargeSlecetionBoxState extends State<RechargeSlecetionBox> {
  bool userInput = false;
  TextEditingController searchtext = TextEditingController();
  List _searchResult = [];

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    widget.plan.forEach((plan) {
      if (plan['amount'].toLowerCase().contains(text.toLowerCase()))
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
                    Navigator.pop(context, {
                      "text":
                          "${_searchResult[index]['network_name']}   -   ₦${_searchResult[index]['amount']} ",
                      "value": "${_searchResult[index]['id']}",
                      "amount_to_pay": _searchResult[index]["amount_to_pay"]
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 18, 15, 18),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    )),
                    child: Text(
                      "${_searchResult[index]['network_name']}   -   ₦${_searchResult[index]['amount']} ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: widget.plan.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, {
                      "text":
                          "${widget.plan[index]['network_name']}   -   ₦${widget.plan[index]['amount']} ",
                      "value": "${widget.plan[index]['id']}",
                      "amount_to_pay": widget.plan[index]["amount_to_pay"]
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 18, 15, 18),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    )),
                    child: Text(
                      "${widget.plan[index]['network_name']}   -   ₦${widget.plan[index]['amount']} ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
