import 'package:timezone/timezone.dart' as tz;

class TimeZoneModel {
  final String name;
  final String timeZoneId;
  final String abbreviation;
  final int offsetInHours;

  TimeZoneModel({
    required this.name,
    required this.timeZoneId,
    required this.abbreviation,
    required this.offsetInHours,
  });

  DateTime getCurrentTime() {
    final location = tz.getLocation(timeZoneId);
    return tz.TZDateTime.now(location);
  }

  String getFormattedTime({bool is24Hour = true}) {
    final time = getCurrentTime();
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

  String getFormattedDate() {
    final time = getCurrentTime();
    final weekday = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ][time.weekday - 1];
    final month = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][time.month - 1];
    return '$weekday, ${time.day} $month ${time.year}';
  }

  copyWith({
    String? name,
    String? timeZoneId,
    String? abbreviation,
    int? offsetInHours,
  }) {
    return TimeZoneModel(
      name: name ?? this.name,
      timeZoneId: timeZoneId ?? this.timeZoneId,
      abbreviation: abbreviation ?? this.abbreviation,
      offsetInHours: offsetInHours ?? this.offsetInHours,
    );
  }
}

class ClockModel {
  final String name;
  final TimeZoneModel timeZone;
  final int position; // For ordering in display

  ClockModel({
    required this.name,
    required this.timeZone,
    required this.position,
  });

  copyWith({
    String? name,
    TimeZoneModel? timeZone,
    int? position,
  }) {
    return ClockModel(
      name: name ?? this.name,
      timeZone: timeZone ?? this.timeZone,
      position: position ?? this.position,
    );
  }
}
