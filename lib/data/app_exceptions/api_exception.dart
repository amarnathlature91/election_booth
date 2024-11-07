
// Custom Exception Classes
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() {
    return "ApiException: $message";
  }
}

class BadRequestException extends ApiException {
  BadRequestException([super.message = "Bad Request"]);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([super.message = "Unauthorized"]);
}

class NotFoundException extends ApiException {
  NotFoundException([super.message = "Not Found"]);
}

class ServerErrorException extends ApiException {
  ServerErrorException([super.message = "Internal Server Error"]);
}



