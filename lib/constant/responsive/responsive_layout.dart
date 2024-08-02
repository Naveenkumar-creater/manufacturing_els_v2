import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Responsive extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  const Responsive({super.key, this.mobile, this.tablet, this.desktop});

 static bool isMobile(BuildContext context) => MediaQuery.of(context as BuildContext).size.width<576;
 static bool isTablet(BuildContext context)=> MediaQuery.of(context as BuildContext).size.width>=576 &&  MediaQuery.of(context as BuildContext).size.width<=992; 
 static bool isDesktop(BuildContext context)=> MediaQuery.of(context).size.width>=992; 

  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.of(context).size;
    if(size.width>1300){
      return desktop ?? Container();

    }
    else if(size.width>=768 && size.width<=1300){
      return tablet ?? Container();
    }
    else{
      return mobile ?? Container();
    }
}
}