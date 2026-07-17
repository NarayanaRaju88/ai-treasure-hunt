import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme_config.dart';
import '../../../core/providers/timezone_provider.dart';
import '../../../domain/models/timezone_model.dart';
import '../../widgets/digital_clock_display.dart';

class ClockScreen extends ConsumerStatefulWidget {
  const ClockScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends ConsumerState<ClockScreen> {
  @override
  Widget build(BuildContext context) {
    final clocks = ref.watch(selectedTimeZonesProvider);
    final is24Hour = ref.watch(timeFormat24HourProvider);
    final availableTimeZones = ref.watch(availableTimeZonesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('World Clock'),
        elevation: 0,
        actions: [
          // Toggle 24/12 hour format
          Padding(
            padding: const EdgeInsets.all(ThemeConfig.md),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  ref.read(timeFormat24HourProvider.notifier).state =
                      !is24Hour;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConfig.md,
                    vertical: ThemeConfig.sm,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeConfig.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(ThemeConfig.radiusMd),
                    border: Border.all(
                      color: ThemeConfig.primaryColor,
                    ),
                  ),
                  child: Text(
                    is24Hour ? '24H' : '12H',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Add clock button
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddClockDialog(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeConfig.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'Your World Clocks',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: ThemeConfig.lg),
            // Clocks Grid
            if (clocks.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: ThemeConfig.lg),
                    Text(
                      'No clocks added yet',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: ThemeConfig.md),
                    ElevatedButton.icon(
                      onPressed: () => _showAddClockDialog(context, ref),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Clock'),
                    ),
                  ],
                ),
              )
            else
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: (oldIndex, newIndex) {
                  ref
                      .read(selectedTimeZonesProvider.notifier)
                      .reorderClocks(oldIndex, newIndex);
                },
                itemCount: clocks.length,
                itemBuilder: (context, index) {
                  final clock = clocks[index];
                  return _ClockCard(
                    key: ValueKey(clock.timeZone.timeZoneId),
                    clock: clock,
                    index: index,
                    onRemove: () {
                      ref
                          .read(selectedTimeZonesProvider.notifier)
                          .removeClockModel(index);
                    },
                    onRename: (newName) {
                      ref
                          .read(selectedTimeZonesProvider.notifier)
                          .updateClockName(index, newName);
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showAddClockDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ThemeConfig.radiusLg),
          topRight: Radius.circular(ThemeConfig.radiusLg),
        ),
      ),
      builder: (context) => _AddClockBottomSheet(),
    );
  }
}

class _ClockCard extends ConsumerWidget {
  final ClockModel clock;
  final int index;
  final VoidCallback onRemove;
  final Function(String) onRename;

  const _ClockCard({
    Key? key,
    required this.clock,
    required this.index,
    required this.onRemove,
    required this.onRename,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ThemeConfig.lg),
      child: Stack(
        children: [
          DigitalClockDisplay(
            timeZoneId: clock.timeZone.timeZoneId,
            displayName: clock.name,
            showDate: true,
          ),
          // Remove button
          Positioned(
            top: ThemeConfig.md,
            right: ThemeConfig.md,
            child: GestureDetector(
              onLongPress: () => _showOptionsMenu(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusSm),
                ),
                padding: const EdgeInsets.all(ThemeConfig.sm),
                child: const Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(ThemeConfig.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(context);
                _showRenameDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                onRemove();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: clock.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Clock'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter clock name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onRename(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _AddClockBottomSheet extends ConsumerStatefulWidget {
  const _AddClockBottomSheet();

  @override
  ConsumerState<_AddClockBottomSheet> createState() =>
      _AddClockBottomSheetState();
}

class _AddClockBottomSheetState extends ConsumerState<_AddClockBottomSheet> {
  String? _selectedTimeZone;
  String _clockName = '';

  @override
  Widget build(BuildContext context) {
    final availableTimeZones = ref.watch(availableTimeZonesProvider);

    return availableTimeZones.when(
      data: (zones) => Container(
        padding: const EdgeInsets.all(ThemeConfig.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New Clock',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: ThemeConfig.lg),
            // Clock Name Input
            TextField(
              decoration: const InputDecoration(
                labelText: 'Clock Name',
                hintText: 'e.g., Tokyo Office',
              ),
              onChanged: (value) => _clockName = value,
            ),
            const SizedBox(height: ThemeConfig.lg),
            // Time Zone Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Time Zone',
              ),
              items: zones
                  .map((zone) => DropdownMenuItem(
                        value: zone,
                        child: Text(zone),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedTimeZone = value),
            ),
            const SizedBox(height: ThemeConfig.lg),
            // Add Button
            ElevatedButton(
              onPressed: _selectedTimeZone != null && _clockName.isNotEmpty
                  ? () {
                      final newClock = ClockModel(
                        name: _clockName,
                        timeZone: TimeZoneModel(
                          name: _selectedTimeZone!,
                          timeZoneId: _selectedTimeZone!,
                          abbreviation: _selectedTimeZone!.split('/').last,
                          offsetInHours: 0,
                        ),
                        position: 0,
                      );
                      ref
                          .read(selectedTimeZonesProvider.notifier)
                          .addClockModel(newClock);
                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Add Clock'),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
