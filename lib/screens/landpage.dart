import 'constants/widgets.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(0, 0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.network(
                    'https://images.unsplash.com/photo-1544489305-d60f2a2c34e4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80',
                  ).image,
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0, 0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.withOpacity(0.1), Colors.black],
                  stops: [0, 1],
                  begin: AlignmentDirectional(0, -1),
                  end: AlignmentDirectional(0, 1),
                ),
                shape: BoxShape.rectangle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0, 0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 40, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome To',
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Voices',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.green,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.06,
                                fontWeight: FontWeight.w900,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Telecoms',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.032,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                // TextSpan(
                                //   text: 'data',
                                //   style: TextStyle(
                                //     fontFamily: 'Nunito',
                                //     color: Colors.green[700],
                                //     fontSize:
                                //         MediaQuery.of(context).size.height *
                                //             0.05,
                                //     fontWeight: FontWeight.w900,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                'LOGIN',
                                style: TextStyle(color: Colors.green[900]),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(20),
                                primary: Colors.white,
                                textStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                ),
                                side: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: Text('CREATE ACCOUNT'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(20),
                                primary: Colors.green[900],
                                textStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                ),
                                side: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
