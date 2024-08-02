import 'package:flutter/material.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_login_page.dart';
import 'package:prominous/features/presentation_layer/page/prominous_login_page.dart';

import '../../../constant/responsive/desktop_body.dart';
import '../../../constant/responsive/responsive_layout.dart';


class LoginPageLayout extends StatelessWidget {
  const LoginPageLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: const LoginPageMobile(),
        tablet: const ProminousLoginPage(),
        desktop: const DesktopScaffold(),
      );
  }
}