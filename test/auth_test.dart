import 'package:test/test.dart';
import 'package:notesbycj/services/auth/auth_user.dart';
import 'package:notesbycj/services/auth/auth_provider.dart';
import 'package:notesbycj/services/auth/auth_exceptions.dart';

void main() {
  group('Authentification simulée', () {
    final provider = MockAuthProvider();
    test('Ne doit pas être initialisé pour commencer', () {
      expect(provider.isInitialized, false);
    });

    test("Ne doit pas se deconnecter s'il n'est pas initialisé", () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Devrait pouvoir être initialisé', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test("L'utilisateur doit être nul après initialisation", () {
      expect(provider.currentUser, null);
    });

    test(
      "Devrait être capable d'initialiser en moins de 2 secondes",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test(
      "Le nouveau utilisateur doit déléguer à la fonction de connexion",
      () async {
        final badEmailUser = await provider.createdUser(
          email: "test@test.com",
          password: "testuser",
        );
        expect(
          badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()),
        );

        final user = await provider.logIn(email: "foo", password: "bar");
        expect(provider.currentUser, user);
        expect(user.isEmailVerified, false);
      },
    );

    test("L'utilisateur connecté doit pouvoir etre vérifié", () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("Peut se déconnecter et se reconnecter", () async {
      await provider.logOut();
      await provider.logIn(email: "email", password: "password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createdUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "test@test.com") throw UserNotFoundAuthException();
    if (password == "testuser") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: 'test@test.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: 'test@test.com');
    _user = newUser;
  }
}
