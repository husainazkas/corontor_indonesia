import 'package:corontor_indonesia/constants/routes.dart';
import 'package:corontor_indonesia/constants/shared_prefs.dart';
import 'package:corontor_indonesia/ui/home_page.dart';
import 'package:corontor_indonesia/ui/login_page.dart';
import 'package:corontor_indonesia/ui/profile_page.dart';
import 'package:corontor_indonesia/ui/register_page.dart';
import 'package:corontor_indonesia/ui/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SharedPreferences _sharedPrefs = Get.find();

  ThemeMode get _themeMode {
    return _sharedPrefs.getBool(SharedPrefs.isDarkMode) ??
            Get.isPlatformDarkMode
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  Locale get _locale {
    String? localeName = _sharedPrefs.getString(SharedPrefs.locale);
    if (localeName != null) {
      return Locale(localeName);
    }
    return Locale(Get.deviceLocale?.languageCode ?? 'en');
  }

  void _onInit() async {
    if (_sharedPrefs.getBool(SharedPrefs.isDarkMode) == null) {
      await _sharedPrefs.setBool(
          SharedPrefs.isDarkMode, Get.isPlatformDarkMode);
    }

    if (_sharedPrefs.getString(SharedPrefs.locale) == null) {
      await _sharedPrefs.setString(SharedPrefs.locale, _locale.languageCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return GetMaterialApp(
      title: 'Corona Monitor',
      theme: ThemeData.light().copyWith(
        appBarTheme: themeData.appBarTheme.copyWith(
          backgroundColor: Colors.white,
          iconTheme: themeData.iconTheme.copyWith(color: Colors.black),
          textTheme: themeData.textTheme.apply(bodyColor: Colors.black),
        ),
      ),
      darkTheme: ThemeData.dark(),
      onInit: _onInit,
      themeMode: _themeMode,
      initialRoute: _auth.currentUser != null ? Routes.home : Routes.login,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      getPages: [
        GetPage(name: Routes.home, page: () => HomePage()),
        GetPage(name: Routes.login, page: () => LoginPage()),
        GetPage(name: Routes.register, page: () => RegisterPage()),
        GetPage(name: Routes.settings, page: () => SettingsPage()),
        GetPage(name: Routes.profile, page: () => ProfilePage()),
      ],
    );
  }
}
