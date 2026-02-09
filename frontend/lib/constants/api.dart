class ApiConstants {
  // Use environment variable for production, localhost for development
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8000',
  );

  static const String identifyEndpoint = '/identify/';
  static const String scansEndpoint = '/scans';
  static const String wrappedEndpoint = '/wrapped';
  static const String chatEndpoint = '/chat/';
  static const String profileEndpoint = '/profile';
}
