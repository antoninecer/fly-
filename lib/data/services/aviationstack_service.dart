import 'dart:convert';
import 'package:http/http.dart' as http;

class AviationstackFlightResult {
  final String flightNumber;
  final String? airline;
  final String? departureAirport;
  final String? departureIata;
  final String? arrivalAirport;
  final String? arrivalIata;
  final String? departureScheduled;
  final String? arrivalScheduled;
  final String? flightStatus;

  const AviationstackFlightResult({
    required this.flightNumber,
    this.airline,
    this.departureAirport,
    this.departureIata,
    this.arrivalAirport,
    this.arrivalIata,
    this.departureScheduled,
    this.arrivalScheduled,
    this.flightStatus,
  });

  String toSummary() {
    return 'Flight: $flightNumber\n'
        'Airline: ${airline ?? "-"}\n'
        'Status: ${flightStatus ?? "-"}\n'
        'From: ${departureAirport ?? "-"} (${departureIata ?? "-"})\n'
        'To: ${arrivalAirport ?? "-"} (${arrivalIata ?? "-"})\n'
        'Departure: ${departureScheduled ?? "-"}\n'
        'Arrival: ${arrivalScheduled ?? "-"}';
  }
}

class AviationstackService {
  static const String _baseUrl = 'https://api.aviationstack.com/v1/flights';

  Future<AviationstackFlightResult> lookupFlight({
    required String apiKey,
    required String flightNumber,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl?access_key=$apiKey&flight_iata=${Uri.encodeQueryComponent(flightNumber)}',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Aviationstack HTTP ${response.statusCode}');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);

    if (json['error'] != null) {
      final error = json['error'];
      throw Exception(
        'Aviationstack error: ${error['message'] ?? 'Unknown error'}',
      );
    }

    final data = json['data'];
    if (data is! List || data.isEmpty) {
      throw Exception('No flight found for "$flightNumber"');
    }

    final item = data.first as Map<String, dynamic>;

    final flight = item['flight'] as Map<String, dynamic>?;
    final airline = item['airline'] as Map<String, dynamic>?;
    final departure = item['departure'] as Map<String, dynamic>?;
    final arrival = item['arrival'] as Map<String, dynamic>?;

    return AviationstackFlightResult(
      flightNumber: (flight?['iata'] ?? flightNumber).toString(),
      airline: airline?['name']?.toString(),
      departureAirport: departure?['airport']?.toString(),
      departureIata: departure?['iata']?.toString(),
      arrivalAirport: arrival?['airport']?.toString(),
      arrivalIata: arrival?['iata']?.toString(),
      departureScheduled: departure?['scheduled']?.toString(),
      arrivalScheduled: arrival?['scheduled']?.toString(),
      flightStatus: item['flight_status']?.toString(),
    );
  }
}