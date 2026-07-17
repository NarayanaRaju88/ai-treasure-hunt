import 'package:timezone/timezone.dart' as tz;

abstract class TimeZoneRepository {
  Future<List<String>> getAvailableTimeZones();
  Future<Map<String, String>> getTimeZonesByRegion(String region);
  DateTime getTimeInZone(String timeZoneId);
  String formatTime(DateTime time, {bool is24Hour = true});
}

class TimeZoneRepositoryImpl implements TimeZoneRepository {
  @override
  Future<List<String>> getAvailableTimeZones() async {
    try {
      // Initialize timezone data
      await tz.initializeTimeZones();
      return tz.timeZoneDatabase.locations.keys.toList();
    } catch (e) {
      throw Exception('Error loading time zones: $e');
    }
  }

  @override
  Future<Map<String, String>> getTimeZonesByRegion(String region) async {
    try {
      await tz.initializeTimeZones();
      final allZones = tz.timeZoneDatabase.locations.keys.toList();
      final regionZones = <String, String>{};

      for (var zone in allZones) {
        if (zone.startsWith(region)) {
          regionZones[zone] = zone.split('/').last.replaceAll('_', ' ');
        }
      }

      return regionZones;
    } catch (e) {
      throw Exception('Error loading time zones for region: $e');
    }
  }

  @override
  DateTime getTimeInZone(String timeZoneId) {
    try {
      tz.initializeTimeZones();
      final location = tz.getLocation(timeZoneId);
      return tz.TZDateTime.now(location);
    } catch (e) {
      throw Exception('Error getting time in zone: $e');
    }
  }

  @override
  String formatTime(DateTime time, {bool is24Hour = true}) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');

    if (is24Hour) {
      return '$hour:$minute:$second';
    } else {
      final period = time.hour >= 12 ? 'PM' : 'AM';
      final displayHour = (time.hour % 12 == 0 ? 12 : time.hour % 12)
          .toString()
          .padLeft(2, '0');
      return '$displayHour:$minute:$second $period';
    }
  }

  // Popular time zones
  static const Map<String, String> popularTimeZones = {
    'America/New_York': 'New York (EST/EDT)',
    'America/Los_Angeles': 'Los Angeles (PST/PDT)',
    'Europe/London': 'London (GMT/BST)',
    'Europe/Paris': 'Paris (CET/CEST)',
    'Asia/Tokyo': 'Tokyo (JST)',
    'Asia/Shanghai': 'Shanghai (CST)',
    'Asia/Hong_Kong': 'Hong Kong (HKT)',
    'Asia/Singapore': 'Singapore (SGT)',
    'Asia/Kolkata': 'India (IST)',
    'Australia/Sydney': 'Sydney (AEDT/AEST)',
    'Pacific/Auckland': 'Auckland (NZDT/NZST)',
    'UTC': 'UTC (Coordinated Universal Time)',
  };

  static Map<String, String> getPrefixedTimeZones() {
    final regions = <String, Map<String, String>>{};

    for (var entry in popularTimeZones.entries) {
      final region = entry.key.split('/').first;
      if (!regions.containsKey(region)) {
        regions[region] = {};
      }
      regions[region]![entry.key] = entry.value;
    }

    return popularTimeZones;
  }
}
