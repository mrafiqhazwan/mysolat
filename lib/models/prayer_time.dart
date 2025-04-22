import 'prayer.dart';

class PrayerTime {
  final String name;
  final DateTime time;
  final bool isCurrent;
  final bool isNext;

  PrayerTime({
    required this.name,
    required this.time,
    this.isCurrent = false,
    this.isNext = false,
  });

  String get formattedTime {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    final DateTime date = DateTime.parse(json['date'] as String);
    final List<Prayer> prayers = [];
    
    if (json.containsKey('fajr')) {
      prayers.add(Prayer(
        name: 'Fajr',
        time: _parseTime(json['fajr'] as String, date),
      ));
    }
    
    if (json.containsKey('dhuhr')) {
      prayers.add(Prayer(
        name: 'Dhuhr',
        time: _parseTime(json['dhuhr'] as String, date),
      ));
    }
    
    if (json.containsKey('asr')) {
      prayers.add(Prayer(
        name: 'Asr',
        time: _parseTime(json['asr'] as String, date),
      ));
    }
    
    if (json.containsKey('maghrib')) {
      prayers.add(Prayer(
        name: 'Maghrib',
        time: _parseTime(json['maghrib'] as String, date),
      ));
    }
    
    if (json.containsKey('isha')) {
      prayers.add(Prayer(
        name: 'Isha',
        time: _parseTime(json['isha'] as String, date),
      ));
    }
    
    return PrayerTime(
      name: prayers[0].name,
      time: prayers[0].time,
    );
  }
  
  static DateTime _parseTime(String timeString, DateTime date) {
    final List<String> parts = timeString.split(':');
    final int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);
    
    return DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }
} 