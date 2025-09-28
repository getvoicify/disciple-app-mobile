//** Author: JayTech👨🏾‍💻
//** Date: September 6, 2023
//** A class that defines API paths for API endpoints.

class ApiPath {
  //? Api version
  static const String _apiVersionOne = '/api';

  //? Notes routes
  static const String notes = '$_apiVersionOne/notes';

  //? Media routes
  static const String mediaUpload = '$_apiVersionOne/media/upload';
  static String imageUrl(String id) =>
      'https://staging.infra.api.pottersville.church/api/media/serve/$id';
}
