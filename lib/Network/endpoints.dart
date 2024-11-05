class Endpoints{
  Endpoints._();

  static const String baseUrl = "https://jsonplaceholder.typicode.com";

  static const Duration receiveTimeout = Duration(seconds: 10);

  static const Duration connectionTimeout = Duration(seconds: 10);
  
  static const String posts = "/posts";
}