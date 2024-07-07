import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:main/Auth/Widget_Tree.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatehome();
  }

  _navigatehome() async {
    await Future.delayed(Duration(milliseconds: 5000), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => testWidgetTree(
                )));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: FadeIn(
      animate: true,
      duration: Duration(seconds: 1),
      child: FadeOut(
        animate: true,
        delay: Duration(milliseconds: 3500),
        duration: Duration(seconds: 5),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Color(0xFFF1F1F1),
          drawer: Drawer(
            elevation: 16,
          ),
          body: SafeArea(
            top: true,
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional(-0.04, -0.59),
                  child: Container(
                    width: 200,
                    height: 200,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                 const Align(
                  alignment: AlignmentDirectional(-0.09, -0.21),
                  child: Text(
                    'IngreChef',
                    style: TextStyle(
                      fontFamily: 'GreatVibes',
                      fontSize: 60,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
