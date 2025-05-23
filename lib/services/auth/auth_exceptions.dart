//Login Exceptions
class EmailAlreadyInUseAuthException implements Exception {}

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class InvalidCredentialAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//Register Exceptions
class EmailAlreadyInUseRegisterException implements Exception {}

class InvalidEmailRegisterException implements Exception {}

class WeakPasswordRegisterException implements Exception {}

//Verify Email Exceptions
class NetworkRequestFailedVerifyEmailException implements Exception {}

//Generic Exceptions

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
