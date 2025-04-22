import 'package:adhan/adhan.dart';

class PrayerInfo {
  final String name;
  final DateTime time;
  final bool isCurrentPrayer;

  PrayerInfo({
    required this.name,
    required this.time,
    this.isCurrentPrayer = false,
  });

  factory PrayerInfo.fromPrayerTimes(Prayer prayer, PrayerTimes prayerTimes, bool isCurrent) {
    late final DateTime time;
    late final String name;

    switch (prayer) {
      case Prayer.fajr:
        time = prayerTimes.fajr;
        name = 'Fajr';
        break;
      case Prayer.sunrise:
        time = prayerTimes.sunrise;
        name = 'Sunrise';
        break;
      case Prayer.dhuhr:
        time = prayerTimes.dhuhr;
        name = 'Dhuhr';
        break;
      case Prayer.asr:
        time = prayerTimes.asr;
        name = 'Asr';
        break;
      case Prayer.maghrib:
        time = prayerTimes.maghrib;
        name = 'Maghrib';
        break;
      case Prayer.isha:
        time = prayerTimes.isha;
        name = 'Isha';
        break;
      default:
        time = DateTime.now();
        name = 'Unknown';
    }

    return PrayerInfo(
      name: name,
      time: time,
      isCurrentPrayer: isCurrent,
    );
  }
} 