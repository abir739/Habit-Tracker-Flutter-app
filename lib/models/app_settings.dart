import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 1)
class AppSettings extends HiveObject {
  @HiveField(0)
  DateTime? firstLaunchDate;

  @HiveField(1)
  bool darkMode = false;

  @HiveField(2)
  String language = 'en';
}
