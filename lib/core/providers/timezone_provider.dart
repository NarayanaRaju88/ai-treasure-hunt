import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/models/timezone_model.dart';
import '../../domain/repositories/timezone_repository.dart';

final timeZoneRepositoryProvider = Provider<TimeZoneRepository>((ref) {
  return TimeZoneRepositoryImpl();
});

final availableTimeZonesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(timeZoneRepositoryProvider);
  return repository.getAvailableTimeZones();
});

final selectedTimeZonesProvider =
    StateNotifierProvider<SelectedTimeZonesNotifier, List<ClockModel>>((ref) {
  return SelectedTimeZonesNotifier();
});

class SelectedTimeZonesNotifier extends StateNotifier<List<ClockModel>> {
  SelectedTimeZonesNotifier()
      : super([
          ClockModel(
            name: 'Local Time',
            timeZone: TimeZoneModel(
              name: 'Local',
              timeZoneId: 'Local',
              abbreviation: 'LCL',
              offsetInHours: 0,
            ),
            position: 0,
          ),
          ClockModel(
            name: 'UTC',
            timeZone: TimeZoneModel(
              name: 'Coordinated Universal Time',
              timeZoneId: 'UTC',
              abbreviation: 'UTC',
              offsetInHours: 0,
            ),
            position: 1,
          ),
        ]);

  void addClockModel(ClockModel clock) {
    state = [
      ...state,
      clock.copyWith(position: state.length),
    ];
  }

  void removeClockModel(int index) {
    state = [
      ...state.sublist(0, index),
      ...state.sublist(index + 1).asMap().entries.map((entry) {
        return entry.value.copyWith(position: entry.key + 1);
      }),
    ];
  }

  void reorderClocks(int oldIndex, int newIndex) {
    final clocks = List<ClockModel>.from(state);
    final clock = clocks.removeAt(oldIndex);
    clocks.insert(newIndex, clock);

    state = clocks
        .asMap()
        .entries
        .map((entry) => entry.value.copyWith(position: entry.key))
        .toList();
  }

  void updateClockName(int index, String newName) {
    state = [
      ...state.sublist(0, index),
      state[index].copyWith(name: newName),
      ...state.sublist(index + 1),
    ];
  }
}

final currentTimeProvider = StreamProvider<DateTime>((ref) async* {
  while (true) {
    yield DateTime.now();
    await Future.delayed(const Duration(seconds: 1));
  }
});

final timeFormat24HourProvider = StateProvider<bool>((ref) => true);

final timeZoneTimeProvider =
    Provider.family<String, String>((ref, timeZoneId) {
  ref.watch(currentTimeProvider);
  final is24Hour = ref.watch(timeFormat24HourProvider);

  try {
    final location = tz.getLocation(timeZoneId);
    final now = tz.TZDateTime.now(location);
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');

    if (is24Hour) {
      return '$hour:$minute:$second';
    } else {
      final period = now.hour >= 12 ? 'PM' : 'AM';
      final displayHour =
          (now.hour % 12 == 0 ? 12 : now.hour % 12).toString().padLeft(2, '0');
      return '$displayHour:$minute:$second $period';
    }
  } catch (e) {
    return '00:00:00';
  }
});
