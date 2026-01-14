import 'package:geolocator/geolocator.dart';
import 'package:location_service/src/entity/coordinates.dart';

/// Extension methods for [Position] to convert to internal domain models
extension PositionExtension on Position {
  /// Converts [Position] to [Coordinates] by extracting latitude and longitude
  Coordinates toCoordinates() => Coordinates(latitude: latitude, longitude: longitude);
}
