import 'package:expatrio_login_app/authentication/provider/auth_notifier.dart';
import 'package:expatrio_login_app/authentication/presentation/login_page.dart';
import 'package:expatrio_login_app/tax_data/provider/tax_data_notifier.dart';
import 'package:expatrio_login_app/tax_data/presentation/tax_data_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider;

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthNotifier()),
      ChangeNotifierProvider(create: (context) => TaxDataNotifier()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        unselectedWidgetColor: Colors.green,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        canvasColor: Colors.transparent,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromRGBO(65, 171, 158, 1),
          selectionColor: Color.fromRGBO(65, 171, 158, 1),
          selectionHandleColor: Color.fromRGBO(65, 171, 158, 1),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: createMaterialColor(Colors.white))
            .copyWith(
          secondary: createMaterialColor(const Color.fromRGBO(65, 171, 158, 1)),
        ),
        // add theme for filled button
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromRGBO(65, 171, 158, 1)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        primaryColorDark: Colors.white,
      ),
      home: const LoginPage(),
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
