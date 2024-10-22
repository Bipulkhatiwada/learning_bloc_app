import 'dart:async';
import 'package:learning_bloc_app/Services/weather_services.dart';
import 'package:learning_bloc_app/models/weather_alert_model.dart';

class HomeViewState {
  final List<WeatherAlert> weatherAlerts;
  final bool isLoading;
  final String? errorMessage;

  HomeViewState({
    required this.weatherAlerts,
    required this.isLoading,
    this.errorMessage,
  });
}

class HomeViewModel {
  final WeatherService _weatherService = WeatherService();
  final List<String> locations = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'Austin'];
  String selectedLocation = 'New York';
  bool isValidUser = false;
  String userName = "";
  String errorMsg = "";

  final _stateController = StreamController<HomeViewState>.broadcast();
  Stream<HomeViewState> get stateStream => _stateController.stream;

  Future<void> fetchWeatherAlerts() async {
    if (isValidUser) {
  _stateController.add(HomeViewState(weatherAlerts: [], isLoading: true));
    try {
      final alerts = await _weatherService.fetchWeatherAlerts(selectedLocation);
      _stateController
          .add(HomeViewState(weatherAlerts: alerts, isLoading: false));
    } catch (e) {
      _stateController.add(HomeViewState(
          weatherAlerts: [], isLoading: false, errorMessage: e.toString()));
    }
    } else {
      errorMsg = "something went wrong";
    }
  
  }

 bool checkUserAuth() {
  if (userName == "bipul") { 
    return true;
  } else {
   return false; 
  }
}

  void updateLocation(String newLocation) {
    selectedLocation = newLocation;
    fetchWeatherAlerts();
  }

  void dispose() {
    _stateController.close();
  }
}
