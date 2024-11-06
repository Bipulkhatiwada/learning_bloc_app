class Endpoints{
  Endpoints._();

  static const String baseUrl = "https://ca09adbca945eb1a5b26.free.beeceptor.com/api";

  static const Duration receiveTimeout = Duration(seconds: 10);

  static const Duration connectionTimeout = Duration(seconds: 10);
  
  static const String users = "/users";
}