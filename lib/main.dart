
import 'dart:ui';

import 'package:greenfield_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';

late final SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  } catch (_) {}

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) {
            return LanguageProvider();
          },
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (context) {
            return SettingsProvider();
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SessionManager>(
      create: (_) => SessionManager(prefs: prefs),
      child: Consumer<SessionManager>(
        builder: (context, SessionManager sessionNotifier, child) {
          Constant.session = Provider.of<SessionManager>(context);

          if (Constant.session
              .getData(SessionManager.appThemeName)
              .toString()
              .isEmpty) {
            Constant.session.setData(
                SessionManager.appThemeName, Constant.themeList[0], false);
            Constant.session.setBoolData(SessionManager.isDarkTheme,
                PlatformDispatcher.instance.platformBrightness == Brightness.dark, false);
          }

          // This callback is called every time the brightness changes from the device.
          PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
            if (Constant.session.getData(SessionManager.appThemeName) ==
                Constant.themeList[0]) {
              Constant.session.setBoolData(SessionManager.isDarkTheme,
                  PlatformDispatcher.instance.platformBrightness == Brightness.dark, true);
            }
          };

          return Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              Constant.session = Provider.of<SessionManager>(context);

              if (Constant.session
                  .getData(SessionManager.appThemeName)
                  .toString()
                  .isEmpty) {
                Constant.session.setData(
                    SessionManager.appThemeName, Constant.themeList[0], false);
                Constant.session.setBoolData(SessionManager.isDarkTheme,
                    PlatformDispatcher.instance.platformBrightness == Brightness.dark, false);
              }

              // This callback is called every time the brightness changes from the device.
              PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
                if (Constant.session.getData(SessionManager.appThemeName) ==
                    Constant.themeList[0]) {
                  Constant.session.setBoolData(SessionManager.isDarkTheme,
                      PlatformDispatcher.instance.platformBrightness == Brightness.dark, true);
                }
              };

              return MaterialApp(
                builder: (context, child) {
                  return ScrollConfiguration(
                    behavior: GlobalScrollBehavior(),
                    child: Directionality(
                      textDirection:
                      languageProvider.languageDirection.toLowerCase() ==
                          "rtl"
                          ? material.TextDirection.rtl
                          : material.TextDirection.ltr,
                      child: child!,
                    ),
                  );
                },
                onGenerateRoute: RouteGenerator.generateRoute,
                initialRoute: "/",
                scrollBehavior: ScrollGlowBehavior(),
                debugShowCheckedModeBanner: false,
                title: "eGrocer Seller Delivery Boy",
                theme: ColorsRes.setAppTheme(),
                home: SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}

