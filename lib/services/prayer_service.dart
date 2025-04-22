import 'package:adhan/adhan.dart';
import 'package:mysolat_app/models/prayer_model.dart';

class PrayerService {
  // Get prayer times for a specific location
  PrayerTimes getPrayerTimes(double latitude, double longitude) {
    final coordinates = Coordinates(latitude, longitude);
    final dateComponents = DateComponents.from(DateTime.now());
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    
    return PrayerTimes(coordinates, dateComponents, params);
  }
  
  // Get the current prayer time
  PrayerInfo getCurrentPrayer(PrayerTimes prayerTimes) {
    final currentPrayer = prayerTimes.currentPrayer();
    return PrayerInfo.fromPrayerTimes(currentPrayer, prayerTimes, true);
  }
  
  // Get the next prayer time
  PrayerInfo getNextPrayer(PrayerTimes prayerTimes) {
    final nextPrayer = prayerTimes.nextPrayer();
    return PrayerInfo.fromPrayerTimes(nextPrayer, prayerTimes, false);
  }
  
  // Calculate time remaining until the next prayer
  Duration getTimeRemaining(PrayerTimes prayerTimes) {
    final now = DateTime.now();
    final nextPrayerTime = _getNextPrayerTime(prayerTimes);
    return nextPrayerTime.difference(now);
  }
  
  // Calculate progress percentage (100% to 0%) as time goes by
  double calculateProgressPercentage(PrayerTimes prayerTimes) {
    final Prayer currentPrayer = prayerTimes.currentPrayer();
    final DateTime now = DateTime.now();
    
    // Get the start and end times for the current period
    final DateTime startTime = _getPrayerTime(currentPrayer, prayerTimes);
    final DateTime endTime = _getNextPrayerTime(prayerTimes);
    
    // Calculate total duration of the prayer period in milliseconds
    final totalDuration = endTime.difference(startTime).inMilliseconds;
    
    // Calculate elapsed time in milliseconds
    final elapsedTime = now.difference(startTime).inMilliseconds;
    
    // Calculate progress as a percentage from 100% down to 0%
    final progress = 1.0 - (elapsedTime / totalDuration);
    
    // Ensure progress is between 0 and 1
    return progress.clamp(0.0, 1.0);
  }
  
  // Helper method to get DateTime for a specific prayer
  DateTime _getPrayerTime(Prayer prayer, PrayerTimes prayerTimes) {
    switch (prayer) {
      case Prayer.fajr:
        return prayerTimes.fajr;
      case Prayer.sunrise:
        return prayerTimes.sunrise;
      case Prayer.dhuhr:
        return prayerTimes.dhuhr;
      case Prayer.asr:
        return prayerTimes.asr;
      case Prayer.maghrib:
        return prayerTimes.maghrib;
      case Prayer.isha:
        return prayerTimes.isha;
      case Prayer.none:
        // If no prayer is current (i.e., after Isha and before Fajr),
        // return yesterday's Isha as the starting time
        return _getYesterdayIshaTime(prayerTimes.coordinates);
    }
  }
  
  // Helper method to get the next prayer time
  DateTime _getNextPrayerTime(PrayerTimes prayerTimes) {
    final Prayer nextPrayer = prayerTimes.nextPrayer();
    
    // If next prayer is Fajr and current time is after Isha,
    // it means we need tomorrow's Fajr time
    if (nextPrayer == Prayer.fajr && prayerTimes.currentPrayer() == Prayer.isha) {
      return _getTomorrowFajrTime(prayerTimes.coordinates);
    }
    
    return _getPrayerTime(nextPrayer, prayerTimes);
  }
  
  // Get yesterday's Isha time
  DateTime _getYesterdayIshaTime(Coordinates coordinates) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final dateComponents = DateComponents(yesterday.year, yesterday.month, yesterday.day);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    
    final yesterdayPrayerTimes = PrayerTimes(coordinates, dateComponents, params);
    return yesterdayPrayerTimes.isha;
  }
  
  // Get tomorrow's Fajr time
  DateTime _getTomorrowFajrTime(Coordinates coordinates) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final dateComponents = DateComponents(tomorrow.year, tomorrow.month, tomorrow.day);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    
    final tomorrowPrayerTimes = PrayerTimes(coordinates, dateComponents, params);
    return tomorrowPrayerTimes.fajr;
  }
} 