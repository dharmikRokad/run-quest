import '../entities/user_profile.dart';

abstract class AuthRepository {
  /// Stream of user profile updates representing the authenticated state
  Stream<UserProfile?> get authStateChanges;

  /// Retrieves the current authenticated user's profile if logged in
  Future<UserProfile?> get getCurrentUser;

  /// Authenticate using email and password
  Future<UserProfile> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Register a new account, checking for username uniqueness first
  Future<UserProfile> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  });

  /// Verifies if the username is unique in Firestore
  Future<bool> checkUsernameUnique(String username);

  /// Triggers a verification email for the current user
  Future<void> sendEmailVerification();

  /// Checks if the current user's email is verified
  Future<bool> isEmailVerified();

  /// Logs out the user
  Future<void> logout();

  /// Requests account deletion
  Future<void> deleteAccount();
}
