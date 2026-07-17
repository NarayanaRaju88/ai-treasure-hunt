# Digital Clock Integration Guide

## Adding to Your App

### Step 1: Update pubspec.yaml

Add timezone dependency:

```yaml
dependencies:
  timezone: ^0.9.2
```

Run:
```bash
flutter pub get
```

### Step 2: Initialize Timezone Data

In `main.dart`:

```dart
import 'package:timezone/data/latest_all.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize timezone data
  tz.initializeTimeZones();
  
  // ... rest of initialization
  runApp(const MyApp());
}
```

### Step 3: Add to Router

In `lib/presentation/routes/app_router.dart`:

```dart
GoRoute(
  path: 'clock',
  builder: (context, state) => const ClockScreen(),
  routes: [
    // Add sub-routes if needed
  ],
)
```

### Step 4: Add Navigation

Add button in home screen or navigation:

```dart
ListTile(
  leading: const Icon(Icons.schedule),
  title: const Text('World Clock'),
  onTap: () => context.go('/clock'),
)
```

## Complete Example

### Using Standalone Clock Widget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyClockPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Clocks')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DigitalClockDisplay(
          timeZoneId: 'Asia/Tokyo',
          displayName: 'Tokyo',
          showDate: true,
        ),
      ),
    );
  }
}
```

### Multiple Clocks

```dart
class MultiClockPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clocks = [
      ('Asia/Tokyo', 'Tokyo'),
      ('Europe/London', 'London'),
      ('America/New_York', 'New York'),
    ];

    return ListView.builder(
      itemCount: clocks.length,
      itemBuilder: (context, index) {
        final (tzId, name) = clocks[index];
        return DigitalClockDisplay(
          timeZoneId: tzId,
          displayName: name,
        );
      },
    );
  }
}
```

## State Management

### Adding Clocks

```dart
final newClock = ClockModel(
  name: 'Dubai Office',
  timeZone: TimeZoneModel(
    name: 'Gulf Standard Time',
    timeZoneId: 'Asia/Dubai',
    abbreviation: 'GST',
    offsetInHours: 4,
  ),
  position: 0,
);

ref.read(selectedTimeZonesProvider.notifier).addClockModel(newClock);
```

### Removing Clocks

```dart
ref.read(selectedTimeZonesProvider.notifier).removeClockModel(index);
```

### Reordering Clocks

```dart
ref.read(selectedTimeZonesProvider.notifier).reorderClocks(oldIndex, newIndex);
```

### Renaming Clocks

```dart
ref.read(selectedTimeZonesProvider.notifier).updateClockName(index, 'New Name');
```

## Advanced Usage

### Persistent Storage

Add to `preferences_service.dart`:

```dart
Future<void> saveClocks(List<ClockModel> clocks) async {
  final encoded = jsonEncode(
    clocks.map((c) => {
      'name': c.name,
      'timeZoneId': c.timeZone.timeZoneId,
      'position': c.position,
    }).toList(),
  );
  await _prefs.setString('clocks', encoded);
}

Future<List<ClockModel>> loadClocks() async {
  final encoded = _prefs.getString('clocks');
  if (encoded == null) return [];
  
  final decoded = jsonDecode(encoded) as List;
  return decoded.map((item) => ClockModel(
    name: item['name'],
    timeZone: TimeZoneModel(
      name: item['timeZoneId'],
      timeZoneId: item['timeZoneId'],
      abbreviation: item['timeZoneId'].split('/').last,
      offsetInHours: 0,
    ),
    position: item['position'],
  )).toList();
}
```

### Custom Styling

```dart
class StyledClock extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DigitalClockDisplay(
      timeZoneId: 'UTC',
      displayName: 'Universal Time',
      showDate: true,
      timeStyle: GoogleFonts.robotoMono(
        fontSize: 64,
        fontWeight: FontWeight.bold,
        color: Colors.blue[900],
        letterSpacing: 2,
      ),
      dateStyle: GoogleFonts.inter(
        fontSize: 14,
        color: Colors.grey[600],
      ),
      zoneStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.blue,
      ),
    );
  }
}
```

### Notifications for Time

```dart
Final alarmProvider = Provider((ref) {
  final currentTime = ref.watch(currentTimeProvider);
  
  // Trigger at specific time
  return currentTime.maybeWhen(
    data: (time) {
      if (time.hour == 9 && time.minute == 0) {
        // Trigger alarm
        NotificationService().showNotification(
          'Good morning!',
          'Time for your daily treasure hunt',
        );
      }
    },
    orElse: () {},
  );
});
```

## Deployment Checklist

- [ ] Timezone package imported in main.dart
- [ ] Timezone data initialized before app runs
- [ ] Clock screen added to router
- [ ] Navigation button added
- [ ] Tested on multiple devices
- [ ] Tested 24/12 hour toggle
- [ ] Tested timezone switching
- [ ] Performance verified (no jank)
- [ ] Accessibility tested
- [ ] Dark mode tested

## Common Issues

### TimeZone Database Not Found

```bash
# Solution
flutter clean
flutter pub get
flutter pub run build_runner build
```

### Times Not Updating

Ensure StreamProvider is properly watched:

```dart
ref.watch(currentTimeProvider); // Add this!
ref.watch(timeZoneTimeProvider(timeZoneId));
```

### Performance Lag

Limit clock count and use efficient builders:

```dart
ReorderableListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  // ...
)
```

## FAQ

**Q: Can I add custom time zones?**
A: Yes, add to `popular_timezones.dart` or directly use any IANA timezone ID.

**Q: Does it update in real-time?**
A: Yes, updates every second using StreamProvider.

**Q: Can I save clock preferences?**
A: Yes, use SharedPreferences or Hive for persistence.

**Q: Performance with many clocks?**
A: Recommended max 10 clocks per screen for optimal performance.

---

For more information, see [DIGITAL_CLOCK_README.md](DIGITAL_CLOCK_README.md)
