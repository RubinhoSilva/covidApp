import 'package:covid/src/services/push_notification.dart';
import 'package:get_it/get_it.dart';
import 'navigator.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => NavigationService());
}
