class ApiPath {
  static const String baseUrl = "https://api.yourapp.com";

  // Auth
  static const String login = "/auth/login";
  static const String refreshToken = "/auth/refresh";

  // Notes
  static const String notes = "/notes";
  static const String noteById = "/notes/{id}";

  // Community
  static const String posts = "/posts";
}
