import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initStorage() async {
  await Get.putAsync(SharedPreferences.getInstance);
}
