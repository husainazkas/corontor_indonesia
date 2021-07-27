import 'package:corontor_indonesia/constants/shared_prefs.dart';
import 'package:corontor_indonesia/utils/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SharedPreferences _sharedPrefs = Get.find();

  late bool _isDark;
  late Locale _currentLocale;

  @override
  void initState() {
    _isDark = _sharedPrefs.getBool(SharedPrefs.isDarkMode)!;
    _currentLocale = Locale(_sharedPrefs.getString(SharedPrefs.locale)!);
    super.initState();
  }

  String _languageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'id':
        return 'Bahasa Indonesia';
      default:
        return 'Unknown locale: $locale';
    }
  }

  Future<void> _changeLocale(newLocale) async {
    await _sharedPrefs.setString(SharedPrefs.locale, newLocale.languageCode);
    Get.updateLocale(newLocale!);
    _currentLocale = newLocale;
    Get.back();
    print(
        '$_currentLocale, $newLocale, ${_sharedPrefs.getString(SharedPrefs.locale)}');
  }

  Future<void> _changeThemeMode(bool enablingDark) async {
    await _sharedPrefs.setBool(SharedPrefs.isDarkMode, enablingDark);
    Get.changeThemeMode(enablingDark ? ThemeMode.dark : ThemeMode.light);
    _isDark = enablingDark;
    print(
        '$_isDark, $enablingDark, ${_sharedPrefs.getBool(SharedPrefs.isDarkMode)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                ListTile(
                  title: Text(context.l10n.language),
                  subtitle: Text(_languageName(_currentLocale)),
                  trailing: Icon(Icons.arrow_drop_down),
                  onTap: () {
                    Get.dialog(AlertDialog(
                      title: Text(
                          '${context.l10n.select} ${context.l10n.language}'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: AppLocalizations.supportedLocales.map((e) {
                          return RadioListTile<Locale>(
                              title: Text(_languageName(e)),
                              value: e,
                              groupValue: _currentLocale,
                              onChanged: _changeLocale);
                        }).toList(),
                      ),
                    ));
                  },
                ),
                SwitchListTile(
                  value: _isDark,
                  onChanged: _changeThemeMode,
                  title: Text(context.l10n.darkMode),
                  subtitle: Text(context.l10n.darkModeDisabled),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
