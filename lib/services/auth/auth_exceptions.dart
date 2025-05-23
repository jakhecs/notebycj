//Login Exceptions
class EmailAlreadyInUseAuthException implements Exception {}

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class InvalidCredentialAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class TooManyRequestsAuthException implements Exception {}

class NetworkRequestFailedAuthException implements Exception {}

//Register Exceptions
class EmailAlreadyInUseRegisterException implements Exception {}

class InvalidEmailRegisterException implements Exception {}

class OperationNotAllowedRegisterException implements Exception {}

class WeakPasswordRegisterException implements Exception {}

class AppNotAuthorizedRegisterException implements Exception {}

class TooManyRequestsRegisterException implements Exception {}

class NetworkRequestFailedRegisterException implements Exception {}

//Verify Email Exceptions
class NetworkRequestFailedVerifyEmailException implements Exception {}

//Generic Exceptions

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
