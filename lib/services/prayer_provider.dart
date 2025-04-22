import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysolat_app/models/prayer_model.dart';
import 'package:mysolat_app/services/location_service.dart';
import 'package:mysolat_app/services/prayer_service.dart';
import 'package:mysolat_app/models/prayer_time.dart';
import 'package:mysolat_app/models/prayer.dart';
import 'package:mysolat_app/services/api_service.dart';

class PrayerProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final PrayerService _prayerService = PrayerService();
  final ApiService _apiService;
  
  PrayerTimes? _prayerTimes;
  Prayer? _currentPrayer;
  Prayer? _nextPrayer;
  double _progress = 0.0;
  Duration _timeRemaining = Duration.zero;
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _timer;
  
  // Getters
  PrayerTimes? get prayerTimes => _prayerTimes;
  Prayer? get currentPrayer => _currentPrayer;
  Prayer? get nextPrayer => _nextPrayer;
  double get progress => _progress;
  Duration get timeRemaining => _timeRemaining;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  PrayerProvider({required ApiService apiService}) : _apiService = apiService {
    fetchPrayerTimes();
    _startTimer();
  }
  
  Future<void> fetchPrayerTimes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final prayerTimes = await _apiService.fetchPrayerTimes();
      _prayerTimes = prayerTimes;
      _updateCurrentAndNextPrayer();
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
    }
    
    notifyListeners();
  }
  
  Future<void> refreshPrayerTimes() async {
    await fetchPrayerTimes();
  }
  
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      _updateCurrentAndNextPrayer();
      notifyListeners();
    });
  }
  
  void _updateCurrentAndNextPrayer() {
    if (_prayerTimes == null) return;
    
    final now = DateTime.now();
    final prayers = [
      Prayer(name: 'Fajr', time: _prayerTimes!.fajr),
      Prayer(name: 'Sunrise', time: _prayerTimes!.sunrise),
      Prayer(name: 'Dhuhr', time: _prayerTimes!.dhuhr),
      Prayer(name: 'Asr', time: _prayerTimes!.asr),
      Prayer(name: 'Maghrib', time: _prayerTimes!.maghrib),
      Prayer(name: 'Isha', time: _prayerTimes!.isha),
      // Add the next day's Fajr as the end time for Isha
      Prayer(
        name: 'Fajr',
        time: DateTime(
          _prayerTimes!.fajr.year,
          _prayerTimes!.fajr.month,
          _prayerTimes!.fajr.day + 1,
          _prayerTimes!.fajr.hour,
          _prayerTimes!.fajr.minute,
        ),
      ),
    ];
    
    // Find current prayer
    Prayer? current;
    Prayer? next;
    
    for (int i = 0; i < prayers.length - 1; i++) {
      if (now.isAfter(prayers[i].time) && now.isBefore(prayers[i + 1].time)) {
        current = prayers[i];
        next = prayers[i + 1];
        break;
      }
    }
    
    // If not found, it's after the last prayer of the day (Isha)
    if (current == null && now.isAfter(prayers[5].time)) {
      current = prayers[5]; // Isha
      next = prayers[6];    // Next day's Fajr
    }
    
    // If still not found, it's before the first prayer of the day (Fajr)
    if (current == null && now.isBefore(prayers[0].time)) {
      // Use the previous day's Isha as the current prayer
      // For simplicity, we're just setting current to null
      current = null;
      next = prayers[0]; // Today's Fajr
    }
    
    _currentPrayer = current;
    _nextPrayer = next;
    
    // Calculate progress and time remaining
    if (current != null && next != null) {
      final totalDuration = next.time.difference(current.time).inSeconds;
      final elapsedDuration = now.difference(current.time).inSeconds;
      
      _progress = elapsedDuration / totalDuration;
      _timeRemaining = next.time.difference(now);
    } else {
      _progress = 0.0;
      _timeRemaining = Duration.zero;
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
} 