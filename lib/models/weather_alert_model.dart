class WeatherAlert {
  final String headline;
  final String desc;

  WeatherAlert({required this.headline, required this.desc});

  factory WeatherAlert.fromJson(Map<String, dynamic> json) {
    return WeatherAlert(
      headline: json['headline'],
      desc: json['desc'],
    );
  }
}
