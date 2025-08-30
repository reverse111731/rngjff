import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'presentation/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the app to display in edge-to-edge mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    MyApp(
      appRouter: AppRouter(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random app Just for Fun',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
