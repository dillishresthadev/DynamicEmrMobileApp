import 'package:dynamic_emr/app_main_nav.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/features/auth/presentation/screens/hospital_code_screen.dart';
import 'package:dynamic_emr/features/auth/presentation/screens/login_screen.dart';
import 'package:dynamic_emr/features/auth/presentation/screens/select_branch_screen.dart';
import 'package:dynamic_emr/features/auth/presentation/screens/select_financial_year_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/setting_screen.dart';
import 'package:dynamic_emr/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // customPageRoute function
    PageRouteBuilder customPageRoute(Widget page, RouteSettings settings) {
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        // transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //   const begin = Offset(1.0, 0.0); // Animation starts from right
        //   const end = Offset.zero; // Ends at the center
        //   const curve = Curves.easeInOut;
        //   var tween =
        //       Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        //   var offsetAnimation = animation.drive(tween);
        //   return SlideTransition(
        //     position: offsetAnimation,
        //     child: child,
        //   );
        // },
      );
    }

    switch (settings.name) {
      case RouteNames.splashScreen:
        return customPageRoute(SplashScreen(), settings);
      case RouteNames.hospitalCodeScreen:
        return customPageRoute(HospitalCodeScreen(), settings);
      case RouteNames.loginScreen:
        return customPageRoute(LoginScreen(), settings);
      case RouteNames.selectBranchScreen:
        return customPageRoute(SelectBranchScreen(), settings);
      case RouteNames.selectFiscalYearScreen:
        return customPageRoute(SelectFinancialYearScreen(), settings);
      case RouteNames.appMainNav:
        return customPageRoute(AppMainNav(), settings);
      case RouteNames.settingScreen:
        return customPageRoute(SettingScreen(), settings);
      default:
        return _errorRoute(settings);
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) =>
          const Scaffold(body: Center(child: Text('404: Page Not Found'))),
    );
  }
}
