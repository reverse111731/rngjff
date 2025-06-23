import 'package:flutter/material.dart';
import '/presentation/screens/index.dart';

class AppRouter {
  // Currently this is not working properly, need to fix it
  Route? generateRoute(RouteSettings screens) {
    // For Global state, to pass state from 1 screen to the next
    // final GlobalKey<ScaffoldState>? key = screens.arguments as GlobalKey<ScaffoldState>?;
    switch (screens.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SelectionPage(
            title: "Selection Page",
          ),
        );
    }
    return null;
  }
}
