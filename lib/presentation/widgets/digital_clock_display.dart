import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/theme_config.dart';

class DigitalClockDisplay extends ConsumerWidget {
  final String timeZoneId;
  final String displayName;
  final bool showDate;
  final bool is24Hour;
  final TextStyle? timeStyle;
  final TextStyle? dateStyle;
  final TextStyle? zoneStyle;

  const DigitalClockDisplay({
    Key? key,
    required this.timeZoneId,
    required this.displayName,
    this.showDate = true,
    this.is24Hour = true,
    this.timeStyle,
    this.dateStyle,
    this.zoneStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeString = ref.watch(timeZoneTimeProvider(timeZoneId));

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConfig.radiusLg),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ThemeConfig.primaryColor.withOpacity(0.1),
              ThemeConfig.primaryColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(ThemeConfig.radiusLg),
        ),
        padding: const EdgeInsets.all(ThemeConfig.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display Name
            Text(
              displayName,
              style: zoneStyle ??
                  Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ThemeConfig.primaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ThemeConfig.md),
            // Digital Time Display
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConfig.lg,
                vertical: ThemeConfig.md,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ThemeConfig.radiusMd),
                border: Border.all(
                  color: ThemeConfig.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  // Time in monospace font
                  Text(
                    timeString,
                    style: timeStyle ??
                        Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontFamily: 'Courier',
                          fontWeight: FontWeight.w700,
                          color: ThemeConfig.primaryColor,
                          letterSpacing: 2,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  if (showDate) ...
                    [
                      const SizedBox(height: ThemeConfig.md),
                      _DateDisplay(
                        timeZoneId: timeZoneId,
                        style: dateStyle,
                      ),
                    ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateDisplay extends ConsumerWidget {
  final String timeZoneId;
  final TextStyle? style;

  const _DateDisplay({
    required this.timeZoneId,
    this.style,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(currentTimeProvider);

    return Builder(
      builder: (context) {
        try {
          final tz = import_tz();
          final location = tz.getLocation(timeZoneId);
          final now = tz.TZDateTime.now(location);

          final weekday = [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday'
          ][now.weekday - 1];
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
          ][now.month - 1];
          final dateStr = '$weekday, ${now.day} $month ${now.year}';

          return Text(
            dateStr,
            style: style ??
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
            textAlign: TextAlign.center,
          );
        } catch (e) {
          return const SizedBox.shrink();
        }
      },
    );
  }

  dynamic import_tz() {
    return null; // Placeholder
  }
}
