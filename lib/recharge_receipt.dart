import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';

class RechargeReceipt extends StatefulWidget {
  Map data;
  RechargeReceipt({this.data});

  @override
  _RechargeReceiptState createState() => _RechargeReceiptState();
}

class _RechargeReceiptState extends State<RechargeReceipt> {
  bool token = false;

  String generatedPdfFilePath;

  String htnldata() {
    print(
        "https://voicestelecom.com.ng/static/ogbam/images/${widget.data['network_name']}.jpg");
    String text = "";
    for (int x = 0; x < widget.data['data_pin'].length; x++) {
      text +=
          """
     <td>
                 <center><span style="padding-bottom:2px;"><b>${widget.data["name_on_card"]}  </b></span>
                 <br> 
    </center> <br>  <img src="https://elecastlesubng.com/static/ogbam/images/${widget.data['network_name']}.jpg">

                 <div class="content" style="padding-left: 10px;margin-top:-19px;"><span><b>REF:</b></span> &nbsp;&nbsp;  <span> <b>${widget.data["id"]}</b></span> <br>
                    <span><b>PIN:</b></span>&nbsp;&nbsp;<span style="font-size:11px"><b> ${widget.data["data_pin"][x]['fields']["pin"]}</b></span><br>
                    <span><b>S/N:</b></span>&nbsp;&nbsp;<span><b> ${widget.data["data_pin"][x]['fields']["serial"]}</b></span><br>
                    <span><b>Date:</b></span>&nbsp;&nbsp;<span><b>${DateFormat('yyyy-MM-dd – kk:mm a').format(DateTime.parse(widget.data['create_date']))} </b></span><br>
                </div>

                <div class="bottom">

                  <span class="amt"><b>₦${widget.data["data_pin"][x]['fields']['amount']}</b></span>


                 <center>
              
                          <span style="font-size:8px;"> <b> ${widget.data["data_pin"][x]['fields']["load_code"]}</b></span>
                   

                    </center>


                </div>

                </td>

               ${(x != widget.data['data_pin'].length - 1 && x + 1 == 4 || x + 1 == 8 || x + 1 == 16 || x + 1 == 20 || x + 1 == 24 || x + 1 == 28 || x + 1 == 32 || x + 1 == 36 || x + 1 == 40) ? " </tr> <tr>" : ""}


            """;
    }
    ;

    return text;
  }

  Future<void> generateExampleDocument() async {
    var htmlContent =
        """
   <!DOCTYPE html>
    <html>
      <head>
      
<style>
.table, tr, td {
  border: 1px solid black;
  border-style: dashed;
  padding:0px;

}


td{
    font-size:10px;
}

.amt{
    float:right;
    font-weight: bolder;
}

.content{
    padding-right:30px;
}
img{
   float:right;
   height: 35px;
   width: 35px;
}

.bottom{
    clear:both ;
}
</style>


      </head>
      <body>
     
         <table class=' w3-table-responsive' id="pins">


            <tr>
                ${htnldata()}

            </tr>

        </table>
     
       
      </body>
    </html>
    """;

    Random random = new Random();
    int randomNumber = random.nextInt(10000);
    var appDocDir = await getApplicationDocumentsDirectory();
    var targetPath = appDocDir.path;
    var targetFileName = "RechargeReceipt$randomNumber";

    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, targetPath, targetFileName);
    generatedPdfFilePath = generatedPdfFile.path;
    final params = SaveFileDialogParams(sourceFilePath: generatedPdfFilePath);
    final filePath = await FlutterFileDialog.saveFile(params: params);
  }

  void initState() {
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
        backgroundColor: Colors.green[700],
        elevation: 0.0,
      ),
      body: Container(
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
                            "${widget.data['id']}",
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
                            "Network",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "${widget.data['network_name']}",
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
                            "Previous Balance",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "₦${widget.data['previous_balance']}",
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
                            "₦${widget.data['after_balance']}",
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
                            "Quantity",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "${widget.data['quantity']}",
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
                              Colors.green[700],
                              Colors.green[700],
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Close'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                              Colors.green[700],
                              Colors.green[700],
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Download'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
    );
  }
}
