import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';

class Billreceipt extends StatefulWidget {
  Map data;
  Billreceipt({this.data});

  @override
  _BillreceiptState createState() => _BillreceiptState();
}

class _BillreceiptState extends State<Billreceipt> {
  bool token = false;

  String generatedPdfFilePath;

  check_mtype() {
    if (widget.data["MeterType"] == "Prepaid") {
      setState(() {
        token = true;
      });
    }
  }

  Future<void> generateExampleDocument() async {
    var htmlContent = """
   <!DOCTYPE html>
    <html>
      <head>
        <style>
        table, th, td {
          border: 1px solid black;
          border-collapse: collapse;
        }
        th, td, p {
          padding: 20px;
          text-align: left;
        }
        </style>
      </head>
      <body>
     
     <center>  <h2> elecastlesubng Bill Payment Receipt</h2></center>  
     <p style='color:red'>Note: No token for POSTPAID Meter it automatically activate your meter</p>
        
        <table style="width:100%">
           

  <tr>

      <td><b>reference</b></td>
      <td id="ref">${widget.data['ident']}</td>
  </tr>

  <tr>
    <tr>

        <td><b>Disco Name</b></td>
        <td id ="plan">${widget.data['package']}</td>
  
    </tr>

      <tr>

        <td><b>Customer Name</b></td>
        <td id ="plan">${widget.data['customer_name']}</td>
  
    </tr>

      <tr>

        <td><b>Customer Address</b></td>
        <td id ="plan">${widget.data['customer_address']}</td>
  
    </tr>

      <td><b> Amount</b></td>
      
      <td > <span></span>₦<span id="amt">${widget.data['amount']}</span></td>
  </tr>

  <tr>

      <td><b>Paid Amount</b></td>
      <td > <span></span>₦<span id="paid">${widget.data['paid_amount']}</span></td>
  </tr>

  <tr>

      <td><b>Previous Balance</b></td>
      <td><span></span>₦<span id="before">${widget.data['balance_before']}</span></td>
  </tr>

  <tr>
        <td><b> New Balance </b></td>
      <td> <span></span>₦<span id="after">${widget.data['balance_after']}</span></td>
  </tr>
  
  <tr>

      <td><b>Meter Number</b></td>
      <td id="num"> ${widget.data['meter_number']}</td>
  </tr>

  <tr>

    <td><b>Meter Type</b></td>
    <td id="type">${widget.data['MeterType']} </td>
</tr>

  <tr id="tokenrow">

    <td><b>Token</b></td>
    <td id="token"> ${widget.data['token']}</td>

</tr>
 



  <tr>

      <td><b>Status</b></td>
      <td id ="status">${widget.data['Status']}</td>
  </tr>


  <tr>

      <td><b>Date</b></td>
      <td id ="date">${DateFormat('yyyy-MM-dd – kk:mm a').format(DateTime.parse(widget.data['create_date']))}</td>
  </tr>

        </table>
        
       
      </body>
    </html>
    """;

    Random random = new Random();
    int randomNumber = random.nextInt(10000);
    var appDocDir = await getApplicationDocumentsDirectory();
    var targetPath = appDocDir.path;
    var targetFileName = "billpaymentReceipt$randomNumber";

    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, targetPath, targetFileName);
    generatedPdfFilePath = generatedPdfFile.path;
    final params = SaveFileDialogParams(sourceFilePath: generatedPdfFilePath);
    final filePath = await FlutterFileDialog.saveFile(params: params);
  }

  void initState() {
    check_mtype();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Transaction Receipt",
            style: TextStyle(color: Colors.white, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.indigo[900],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Column(
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 30),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Reference",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "${widget.data['ident']}",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Disco Name",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "${widget.data['package']}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Customer Name",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "${widget.data['customer_name']}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Customer Address",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "${widget.data['customer_address']}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Amount",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "₦${widget.data['amount']}",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Paid Amount",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "₦${widget.data['paid_amount']}",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Previous Balance",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "₦${widget.data['balance_before']}",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "New Balance",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "₦${widget.data['balance_after']}",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Meter Type",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "${widget.data['MeterType']}",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Meter Number",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "${widget.data['meter_number']}",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          ]),
                      SizedBox(height: 10),
                      token ? Divider() : SizedBox(),
                      token
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                  Text(
                                    "Token",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "${widget.data['token']}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ])
                          : SizedBox(),
                      SizedBox(height: 10),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Status",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "${widget.data['Status']}",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Date",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "${DateFormat('yyyy-MM-dd – kk:mm a').format(DateTime.parse(widget.data['create_date']))}",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Divider(),
                    ]),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/home", (route) => false);
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.indigo[800],
                                Colors.indigo[900],
                              ],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: Text(
                            'Close'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        generateExampleDocument();
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.indigo[800],
                                Colors.indigo[900],
                              ],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: Text(
                            'Download'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
