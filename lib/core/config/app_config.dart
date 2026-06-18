class AppConfig {
  AppConfig._();

  // API
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // émulateur Android
  static const String socketUrl = 'http://10.0.2.2:3000'; // émulateur Android
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // App
  static const String appName = 'TchadOpportunité';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int pageSize = 20;

  // Cache
  static const int cacheDurationMinutes = 30;
}
