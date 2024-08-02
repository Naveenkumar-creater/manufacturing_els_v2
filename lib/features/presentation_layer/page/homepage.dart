import 'package:flutter/material.dart';
import 'package:prominous/constant/responsive/tablet_body.dart';

import '../../../constant/responsive/desktop_body.dart';
import '../../../constant/responsive/mobile_body.dart';
import '../../../constant/responsive/responsive_layout.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: const MobileScaffold(),
        tablet: const ResponsiveTabletHomepage(),
        desktop: const DesktopScaffold(),
      );
  }
}