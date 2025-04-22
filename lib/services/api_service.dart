import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysolat_app/services/location_service.dart';

class ApiService {
  final LocationService _locationService = LocationService();
  
  Future<PrayerTimes> fetchPrayerTimes() async {
    try {
      // Get the user's current location
      final Position position = await _locationService.getCurrentLocation();
      
      // Create coordinates object from the user's position
      final Coordinates coordinates = Coordinates(
        position.latitude,
        position.longitude,
      );
      
      // Create date components for the current date
      final DateComponents dateComponents = DateComponents.from(DateTime.now());
      
      // Create calculation parameters
      final CalculationParameters params = CalculationMethod.muslim_world_league.getParameters();
      
      // Set madhab to Shafi
      params.madhab = Madhab.shafi;
      
      // Calculate prayer times
      return PrayerTimes(coordinates, dateComponents, params);
    } catch (e) {
      // Re-throw the error to be handled by the provider
      throw 'Failed to fetch prayer times: ${e.toString()}';
    }
  }
} 