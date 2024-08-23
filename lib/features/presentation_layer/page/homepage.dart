import 'package:flutter/material.dart';
import 'package:prominous/features/presentation_layer/responsive_screen/tablet_body.dart';

import '../responsive_screen/desktop_body.dart';
import '../responsive_screen/mobile_body.dart';
import '../../../constant/utilities/responsive_layout.dart';


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