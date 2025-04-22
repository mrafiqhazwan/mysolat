import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysolat_app/models/prayer_model.dart';

class CurrentPrayerCard extends StatelessWidget {
  final PrayerInfo prayer;
  final double progress;
  final Duration timeRemaining;

  const CurrentPrayerCard({
    super.key,
    required this.prayer,
    required this.progress,
    required this.timeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Icon and Start Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  _getPrayerIcon(prayer.name),
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                Text(
                  DateFormat('h:mm a').format(prayer.time),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Row 2: Title and Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Now: ${prayer.name}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.notifications_active,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Row 3: Time Remaining
            Text(
              _formatDuration(timeRemaining),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            
            // Row 4: Progress Bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return Icons.wb_twilight;
      case 'Sunrise':
        return Icons.wb_sunny_outlined;
      case 'Dhuhr':
        return Icons.wb_sunny;
      case 'Asr':
        return Icons.sunny_snowing;
      case 'Maghrib':
        return Icons.nightlight_round;
      case 'Isha':
        return Icons.nightlight;
      default:
        return Icons.access_time;
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '$hours${hours == 1 ? 'h' : 'hrs'} $minutes${minutes == 1 ? 'min' : 'mins'} left';
    } else {
      return '$minutes${minutes == 1 ? 'min' : 'mins'} left';
    }
  }
}

class NextPrayerCard extends StatelessWidget {
  final PrayerInfo prayer;

  const NextPrayerCard({
    super.key,
    required this.prayer,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = prayer.time.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    
    String timeUntil = '';
    if (hours > 0) {
      timeUntil = '(in $hours${hours == 1 ? 'h' : 'hrs'} $minutes${minutes == 1 ? 'min' : 'mins'})';
    } else {
      timeUntil = '(in $minutes${minutes == 1 ? 'min' : 'mins'})';
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Icon
            Icon(
              _getPrayerIcon(prayer.name),
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(height: 12),
            
            // Row 2: Title
            Text(
              'Next: ${prayer.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            
            // Row 3: Start time with countdown
            Text(
              'Starts at ${DateFormat('h:mm a').format(prayer.time)} $timeUntil',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            
            // Row 4: Reminder Button
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Set reminder functionality
              },
              icon: const Icon(Icons.notifications_none),
              label: const Text('Set Reminder'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return Icons.wb_twilight;
      case 'Sunrise':
        return Icons.wb_sunny_outlined;
      case 'Dhuhr':
        return Icons.wb_sunny;
      case 'Asr':
        return Icons.sunny_snowing;
      case 'Maghrib':
        return Icons.nightlight_round;
      case 'Isha':
        return Icons.nightlight;
      default:
        return Icons.access_time;
    }
  }
} 