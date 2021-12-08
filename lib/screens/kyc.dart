import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class KycPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KycPageState();
  }
}

class _KycPageState extends State<KycPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _middlenameController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();

  TextEditingController _surnameController = TextEditingController();

  TextEditingController _dobController = TextEditingController();

  TextEditingController _stateController = TextEditingController();
  TextEditingController _bvnController = TextEditingController();
  TextEditingController _lgController = TextEditingController();
  TextEditingController _genderController = TextEditingController();

  bool _obscureText = true;

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _gender;

  XFile uploadimage; //variable for choosed file

  Future<bool> getFileSize(File file) async {
    int bytes = await file.length();
    if (bytes <= 0) return false;
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    var size = (bytes / pow(1024, i));

    if (size > 100) {
      Toast.show(
          'Exceed maximum size 100KB, uploaded image size ${size.toStringAsFixed(2) + ' ' + suffixes[i]}',
          context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return false;
    } else {
      return true;
    }
  }

  Future<void> chooseImage() async {
    final ImagePicker _picker = ImagePicker();
    var choosedimage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);

    int bytes = await choosedimage.length();
    if (bytes <= 0) return false;
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    var size = (bytes / pow(1024, i));

    if (size > 100) {
      Toast.show(
          'Exceed maximum size 100KB, uploaded image size ${size.toStringAsFixed(2) + ' ' + suffixes[i]}',
          context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return false;
    } else {
      setState(() {
        uploadimage = choosedimage;
      });
    }
  }

  Future<dynamic> sendkyc() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      List<int> imageBytes = await File(uploadimage.path).readAsBytes();

      String baseimage = base64Encode(imageBytes);

      print(({
        "First_Name": _firstnameController.text,
        'Middle_Name': _middlenameController.text,
        'Last_Name': _lastnameController.text,
        "Date_of_Birth": _dobController.text,
        'Gender': _gender,
        "State_of_origin": _stateController.text,
        "Local_gov_of_origin": _lgController.text,
        "BVN": _bvnController.text,
        "passport_photogragh": baseimage
      }));
      String url = 'https://www.voicestelecom.com.ng/api/kyc/';
      var uri = Uri.parse(url);
      var request = MultipartRequest("POST", uri);
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': 'Token ${sharedPreferences.getString("token")}'
      };

      request.files.add(await MultipartFile.fromPath(
          'passport_photogragh', uploadimage.path));
      request.fields["First_Name"] = _firstnameController.text;
      request.fields['Middle_Name'] = _middlenameController.text;
      request.fields['Last_Name'] = _lastnameController.text;
      request.fields["Date_of_Birth"] = _dobController.text;
      request.fields['Gender'] = _gender;
      request.fields["State_of_origin"] = _stateController.text;
      request.fields["Local_gov_of_origin"] = _lgController.text;
      request.fields["BVN"] = _bvnController.text;
      request.headers.addAll(headers);

      var response = await request.send();

      print(response.statusCode);
      print(response.stream);

      response.stream.transform(utf8.decoder).listen((value) {
        var datares = jsonDecode(value);

        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() {
            _isLoading = false;
            AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.SUCCES,
              title: 'Succes',
              desc: datares['message'],
              btnOkOnPress: () {
                Navigator.of(context).pushNamed("/home");
              },
              btnOkIcon: Icons.check_circle,
            ).show();
          });
        } else if (response.statusCode == 500) {
          setState(() {
            _isLoading = false;
          });

          Toast.show("Unable to connect to server currently", context,
              backgroundColor: Colors.red,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
        } else {
          setState(() {
            _isLoading = false;
          });

          Toast.show(datares['message'], context,
              backgroundColor: Colors.red,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Toast.show('$error', context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:
            Text("KYC", style: TextStyle(color: Colors.white, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.indigo[900],
        elevation: 0.0,
      ),
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                            //show image here after choosing image
                            child: uploadimage == null
                                ? InkWell(
                                    onTap: () {
                                      chooseImage();
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(top: 20),
                                        padding: EdgeInsets.only(
                                            top: 4,
                                            left: 18,
                                            right: 18,
                                            bottom: 4),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 5)
                                            ]),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.cloud_upload_outlined,
                                              size: 100,
                                            ),
                                            Text(
                                                "Select Passport Photograh\nMaximum size of 100kb")
                                          ],
                                        )),
                                  )
                                : //if uploadimage is null then show empty container
                                Container(
                                    margin: EdgeInsets.only(top: 20),
                                    padding: EdgeInsets.only(
                                        top: 4, left: 18, right: 18, bottom: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 5)
                                        ]), //elese show image here
                                    child: SizedBox(
                                        height: 150,
                                        child: Image.file(File(uploadimage
                                            .path)) //load image from file
                                        ))),
                        uploadimage != null
                            ? Container(
                                child: RaisedButton.icon(
                                  onPressed: () {
                                    chooseImage(); // call choose image function
                                  },
                                  icon: Icon(Icons.image),
                                  label: Text("Change this Passport"),
                                  color: Colors.indigo[900],
                                  colorBrightness: Brightness.dark,
                                ),
                              )
                            : SizedBox(),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            validator: (String value) {
                              if (value.length == 0) {
                                return "This field is required";
                              }
                            },
                            obscureText: false,
                            controller: _firstnameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.supervised_user_circle_outlined,
                                color: Colors.grey,
                              ),
                              hintText: 'First Name',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            obscureText: false,
                            controller: _middlenameController,
                            validator: (String value) {
                              if (value.length == 0) {
                                return "This field is required";
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.verified_user_sharp,
                                color: Colors.grey,
                              ),
                              hintText: 'Middle Name',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            validator: (String value) {
                              if (value.length == 0) {
                                return "This field is required";
                              }
                              return null;
                            },
                            obscureText: false,
                            controller: _lastnameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.verified_user_sharp,
                                color: Colors.grey,
                              ),
                              hintText: 'SurName',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            validator: (String value) {
                              if (value.length == 0) {
                                return "This field is required";
                              }
                              return null;
                            },
                            obscureText: false,
                            controller: _bvnController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.settings_cell_rounded,
                                color: Colors.grey,
                              ),
                              hintText: 'NIN/BVN',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            validator: (String value) {
                              if (value.length == 0) {
                                return "This field is required";
                              }
                              return null;
                            },
                            obscureText: false,
                            controller: _stateController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.house_rounded,
                                color: Colors.grey,
                              ),
                              hintText: 'State of origin',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            validator: (String value) {
                              if (value.length == 0) {
                                return "This field is required";
                              }
                              return null;
                            },
                            obscureText: false,
                            controller: _lgController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.house,
                                color: Colors.grey,
                              ),
                              hintText: 'LG of origin',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            validator: (String value) {
                              if (value.length == 0) {
                                return "This field is required";
                              }
                              return null;
                            },
                            readOnly: true,
                            obscureText: false,
                            controller: _dobController,
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime(1998),
                                firstDate: DateTime(1800),
                                lastDate: DateTime(2021),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  _dobController.text = DateFormat('yyyy-MM-dd')
                                      .format(selectedDate);
                                }
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              ),
                              hintText: 'Date of Birth',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: DropDownFormField(
                            titleText: 'GENDER',
                            hintText: '',
                            value: _gender,
                            onSaved: (value) {
                              setState(() {
                                _gender = value;
                                print(_gender);
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                                print(_gender);
                              });
                            },
                            dataSource: [
                              {"display": "MALE", "value": "MALE"},
                              {"display": "FEMALE", "value": "FEMALE"}
                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              if (_gender == null) {
                                Toast.show("Select Your gender", context,
                                    backgroundColor: Colors.red,
                                    duration: Toast.LENGTH_SHORT,
                                    gravity: Toast.CENTER);
                                return;
                              }

                              if (uploadimage == null) {
                                Toast.show(
                                    "Pls upload your passport photograph",
                                    context,
                                    backgroundColor: Colors.red,
                                    duration: Toast.LENGTH_SHORT,
                                    gravity: Toast.CENTER);
                                return;
                              }
                              setState(() => _isLoading = true);
                              await sendkyc();
                            }
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.indigo[800],
                                    Colors.indigo[900],
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                'Submit'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        inAsyncCall: _isLoading,
      ),
    );
  }
}
