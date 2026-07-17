# Digital Clock Feature Documentation

## Overview

The Digital Clock feature allows users to display and manage multiple world clocks with support for different time zones. This feature is perfect for teams working across multiple locations or anyone who needs to track time in different parts of the world.

## Features

### Core Functionality
- ✅ Display current time in multiple time zones
- ✅ 24/12 hour format toggle
- ✅ Date display with day of week
- ✅ Add/remove clocks dynamically
- ✅ Reorder clocks via drag and drop
- ✅ Rename clocks for custom labels
- ✅ Real-time updates (updates every second)
- ✅ 50+ popular time zones pre-configured
- ✅ Supports all IANA time zones

### UI Features
- Beautiful gradient card design
- Monospace font for digital time display
- Smooth animations
- Responsive layout
- Dark/Light mode support
- Emoji indicators for regions

## Architecture

### Files Structure

```
lib/
├── domain/
│   ├── models/
│   │   └── timezone_model.dart          # TimeZoneModel, ClockModel
│   └── repositories/
│       └── timezone_repository.dart     # TimeZoneRepository interface
├── core/
│   ├── providers/
│   │   └── timezone_provider.dart       # Riverpod providers
│   └── constants/
│       └── popular_timezones.dart       # Pre-configured time zones
└── presentation/
    ├── screens/
    │   └── clock/
    │       └── clock_screen.dart        # Main clock screen
    └── widgets/
        └── digital_clock_display.dart   # Clock display widget
```

## Models

### TimeZoneModel

Represents a single time zone.

```dart
class TimeZoneModel {
  final String name;                    // e.g., "Coordinated Universal Time"
  final String timeZoneId;              // e.g., "UTC"
  final String abbreviation;            // e.g., "UTC"
  final int offsetInHours;              // UTC offset

  DateTime getCurrentTime()              // Get current time in this zone
  String getFormattedTime({...})        // Get formatted time string
  String getFormattedDate()             // Get formatted date string
}
```

### ClockModel

Represents a clock display instance.

```dart
class ClockModel {
  final String name;                    // Display name (e.g., "Tokyo Office")
  final TimeZoneModel timeZone;         // Associated timezone
  final int position;                   // Display order
}
```

## Providers (Riverpod)

### timeZoneRepositoryProvider
```dart
final timeZoneRepositoryProvider = Provider<TimeZoneRepository>((ref) {
  return TimeZoneRepositoryImpl();
});
```

### selectedTimeZonesProvider
Manages the list of clocks shown to the user.

```dart
final selectedTimeZonesProvider =
    StateNotifierProvider<SelectedTimeZonesNotifier, List<ClockModel>>((ref) {
  return SelectedTimeZonesNotifier();
});
```

### currentTimeProvider
Streams the current time (updates every second).

```dart
final currentTimeProvider = StreamProvider<DateTime>((ref) async* {
  while (true) {
    yield DateTime.now();
    await Future.delayed(const Duration(seconds: 1));
  }
});
```

### timeFormat24HourProvider
Toggles between 24-hour and 12-hour format.

```dart
final timeFormat24HourProvider = StateProvider<bool>((ref) => true);
```

### timeZoneTimeProvider
Gets formatted time for a specific time zone.

```dart
final timeZoneTimeProvider =
    Provider.family<String, String>((ref, timeZoneId) {
  // Returns formatted time string
});
```

## Usage

### Adding to Navigation

Update `lib/presentation/routes/app_router.dart`:

```dart
GoRoute(
  path: 'clock',
  builder: (context, state) => const ClockScreen(),
),
```

### Using in Home Screen

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../clock/clock_screen.dart';

FloatingActionButton(
  onPressed: () => context.go('/clock'),
  child: const Icon(Icons.schedule),
),
```

### Programmatic Usage

```dart
// Get all selected clocks
final clocks = ref.watch(selectedTimeZonesProvider);

// Add a new clock
ref.read(selectedTimeZonesProvider.notifier).addClockModel(
  ClockModel(
    name: 'Tokyo',
    timeZone: TimeZoneModel(
      name: 'Japan Standard Time',
      timeZoneId: 'Asia/Tokyo',
      abbreviation: 'JST',
      offsetInHours: 9,
    ),
    position: 0,
  ),
);

// Toggle time format
ref.read(timeFormat24HourProvider.notifier).state = false; // 12-hour format

// Get formatted time for a timezone
final timeString = ref.watch(timeZoneTimeProvider('Asia/Tokyo'));
```

## Time Zones Supported

### Americas
- America/New_York (EST/EDT)
- America/Chicago (CST/CDT)
- America/Denver (MST/MDT)
- America/Los_Angeles (PST/PDT)
- America/Toronto (EST/EDT)
- America/Mexico_City (CST)
- America/Sao_Paulo (BRT)
- America/Buenos_Aires (ART)
- And more...

### Europe
- Europe/London (GMT/BST)
- Europe/Paris (CET/CEST)
- Europe/Berlin (CET/CEST)
- Europe/Amsterdam (CET/CEST)
- Europe/Rome (CET/CEST)
- Europe/Madrid (CET/CEST)
- Europe/Moscow (MSK)
- And more...

### Asia
- Asia/Dubai (GST)
- Asia/Kolkata (IST)
- Asia/Bangkok (ICT)
- Asia/Hong_Kong (HKT)
- Asia/Shanghai (CST)
- Asia/Tokyo (JST)
- Asia/Seoul (KST)
- Asia/Singapore (SGT)
- And more...

### Australia & Pacific
- Australia/Sydney (AEDT/AEST)
- Australia/Melbourne (AEDT/AEST)
- Pacific/Auckland (NZDT/NZST)
- Pacific/Fiji (FJT)
- And more...

### Africa
- Africa/Cairo (EET)
- Africa/Johannesburg (SAST)
- Africa/Lagos (WAT)
- Africa/Nairobi (EAT)
- And more...

### Plus UTC and 50+ additional zones

## Widgets

### DigitalClockDisplay

The main widget for displaying a single clock.

```dart
DigitalClockDisplay(
  timeZoneId: 'Asia/Tokyo',
  displayName: 'Tokyo Office',
  showDate: true,
  is24Hour: true,
  timeStyle: null,  // Optional custom style
  dateStyle: null,  // Optional custom style
  zoneStyle: null,  // Optional custom style
)
```

## Screen

### ClockScreen

Full-featured clock management screen with:
- List of all clocks
- Add new clock button
- Toggle 24/12 hour format
- Reorderable list (drag and drop)
- Edit/rename functionality
- Remove clock functionality

## Performance Considerations

1. **Updates**: Clock updates every second using StreamProvider
2. **Optimization**: Uses `Provider.family` to avoid rebuilding all clocks when one updates
3. **Memory**: Lazy loading of timezone database
4. **UI**: Minimal rebuilds using Riverpod's smart dependency tracking

## Testing

### Unit Tests

```dart
test('TimeZoneModel returns correct formatted time', () {
  final tz = TimeZoneModel(
    name: 'UTC',
    timeZoneId: 'UTC',
    abbreviation: 'UTC',
    offsetInHours: 0,
  );
  
  final time = tz.getFormattedTime(is24Hour: true);
  expect(time, matches(RegExp(r'^\d{2}:\d{2}:\d{2}$')));
});
```

### Widget Tests

```dart
testWidgets('DigitalClockDisplay shows time zone name', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: DigitalClockDisplay(
          timeZoneId: 'UTC',
          displayName: 'UTC',
        ),
      ),
    ),
  );
  
  expect(find.text('UTC'), findsOneWidget);
});
```

## Customization

### Adding Custom Time Zones

Edit `lib/core/constants/popular_timezones.dart`:

```dart
static const Map<String, String> zones = {
  // ... existing zones
  'Your/Custom_Zone': '🌍 Your Zone',
};
```

### Styling

Clocks inherit theme colors from `ThemeConfig`. To customize:

```dart
DigitalClockDisplay(
  timeZoneId: 'Asia/Tokyo',
  displayName: 'Tokyo',
  timeStyle: Theme.of(context).textTheme.displayLarge?.copyWith(
    color: Colors.blue,
    fontSize: 48,
  ),
)
```

## Future Enhancements

- [ ] Persistent storage of clock preferences
- [ ] Alarm functionality for specific times
- [ ] Time difference calculator
- [ ] World map with time zones
- [ ] Timezone-aware meeting scheduler
- [ ] Export as image
- [ ] Widget support (Android/iOS home screen)
- [ ] Voice time announcements
- [ ] Sunrise/sunset times
- [ ] Business hours indicator

## API Reference

### TimeZoneRepositoryImpl

#### getAvailableTimeZones()
```dart
Future<List<String>> getAvailableTimeZones()
```
Returns list of all available IANA time zone identifiers.

#### getTimeZonesByRegion(String region)
```dart
Future<Map<String, String>> getTimeZonesByRegion(String region)
```
Returns time zones for a specific region (e.g., 'America', 'Europe').

#### getTimeInZone(String timeZoneId)
```dart
DateTime getTimeInZone(String timeZoneId)
```
Gets current time in specified timezone.

#### formatTime(DateTime time, {bool is24Hour})
```dart
String formatTime(DateTime time, {bool is24Hour = true})
```
Formats DateTime to time string.

## Troubleshooting

### Timezone Database Not Loading
```bash
flutter clean
flutter pub get
flutter pub run build_runner build
```

### Times Showing Incorrectly
- Ensure device time is set correctly
- Check system timezone settings
- Verify timezone ID is correct (case-sensitive)

### Performance Issues
- Limit number of clocks to < 10 for optimal performance
- Use 24-hour format for faster rendering
- Ensure minimal custom styling

## Integration with AI Treasure Hunt

The clock feature can be integrated into the main app:

1. Add clock reminder for treasure hunts
2. Show local time at treasure location
3. Display time until next daily treasure
4. Track time spent on treasure hunts
5. Schedule hunts across time zones

---

For more information, see [API_REFERENCE.md](../../API_REFERENCE.md)
