import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petani_film_v2/routes.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';
import 'package:petani_film_v2/shared/widget/applovin_ads_widget.dart';

void main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // CachedNetworkImage.logLevel = CacheManagerLogLevel.none;
  // await Hive.initFlutter();
  // Hive.registerAdapter(UserAdapter());
  // await Hive.openBox<User>('userBox');

  // OneSignalServices().oneSignalInit();
  // SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Constants.showAds ? initializePlugin() : null;
    Constants.showAds ? ApplovinAdsWidget().initializeInterstitialAds() : null;
  }

  Future<void> initializePlugin() async {
    Map? configuration = await AppLovinMAX.initialize(Constants.applovinSdkKey);
    if (configuration != null) {}
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // REMOVE
    // FlutterNativeSplash.remove();
    // REMOVE
    return MaterialApp.router(
      title: 'Petani Film',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        textTheme: GoogleFonts.nunitoTextTheme().apply(
          bodyColor: Constants.whiteColor,
        ),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Constants.whiteColor,
          ),
          foregroundColor: Constants.whiteColor,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Constants.blackColor,
        ),
        scaffoldBackgroundColor: Constants.blackColor.withOpacity(0.5),
      ),
      routerConfig: mainRouter,
    );
  }
}
