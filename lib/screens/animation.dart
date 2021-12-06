import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAnimation extends StatefulWidget {
  MyAnimation({Key key})
      : super(
          key: key,
        );

  @override
  _MyAnimationState createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController _controller;
  String username;

  @override
  void initState() {
    super.initState();
    getusername();
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 2.1, end: 1.5).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //_controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      })
      ..addStatusListener((state) => print('$state'));
    _controller.forward();
  }

  Future<String> getusername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      username = pref.getString("username");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      animation: animation,
      username: username,
    );
  }
}
