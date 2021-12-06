import 'package:flutter/material.dart';

class MsorgSlecetionBox extends StatefulWidget {
  final Map<dynamic, dynamic> plan;
  final String plantype;

  MsorgSlecetionBox({Key key, @required this.plan, this.plantype: "ALL"})
      : super(key: key);
  @override
  _MsorgSlecetionBoxState createState() => _MsorgSlecetionBoxState();
}

class _MsorgSlecetionBoxState extends State<MsorgSlecetionBox> {
  bool userInput = false;
  TextEditingController searchtext = TextEditingController();
  List _searchResult = [];

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    widget.plan[widget.plantype].forEach((plan) {
      if (plan['plan'].toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(plan);
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.plan);
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
                          "${_searchResult[index]['plan']}  ${widget.plan[widget.plantype][index]['plan_type'] == null ? '' : widget.plan[widget.plantype][index]['plan_type']}   -   ₦${_searchResult[index]['plan_amount']} ${_searchResult[index]['month_validate']}",
                      "value": "${_searchResult[index]['id']}"
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
                      "${_searchResult[index]['plan']}  ${_searchResult[index]['plan_type'] == null ? '' : _searchResult[index]['plan_type']}   -   ₦${_searchResult[index]['plan_amount']} ${_searchResult[index]['month_validate']}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: widget.plan[widget.plantype].length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, {
                      "text":
                          "${widget.plan[widget.plantype][index]['plan']}  ${widget.plan[widget.plantype][index]['plan_type'] == null ? '' : widget.plan[widget.plantype][index]['plan_type']}   -   ₦${widget.plan[widget.plantype][index]['plan_amount']} ${widget.plan[widget.plantype][index]['month_validate']}",
                      "value": "${widget.plan[widget.plantype][index]['id']}"
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
                      "${widget.plan[widget.plantype][index]['plan']}  -   ₦${widget.plan[widget.plantype][index]['plan_amount']} ${widget.plan[widget.plantype][index]['month_validate']}",
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
