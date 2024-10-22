import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning_bloc_app/models/weather_alert_model.dart';

class WeatherService {
  final String apiKey = '731bb6a5a4124cf6baa11730240310';

  Future<List<WeatherAlert>> fetchWeatherAlerts(String location) async {
    final response = await http.post(
      Uri.parse(
        'https://api.weatherapi.com/v1/alerts.json?key=$apiKey&q=$location',
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final alerts = jsonResponse['alerts']['alert'] as List<dynamic>;
      return alerts
          .map((alertJson) => WeatherAlert.fromJson(alertJson))
          .toList();
    } else {
      throw Exception('Failed to load weather alerts');
    }
  }
}
