import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Curated list of vibrant, neon map-rendering colors for runners
  static const List<String> _runnerColors = [
    'FF5A36', // Electric Orange
    '00F2FE', // Quest Cyan
    '39FF14', // Neon Green
    'BD00FF', // Cyber Purple
    'FF007F', // Rage Pink
    'CCFF00', // Acid Yellow
    '00E5FF', // Arctic Blue
  ];

  @override
  Stream<UserProfile?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          return UserProfile.fromMap(doc.data()!, user.uid, isEmailVerified: user.emailVerified);
        }
      } catch (e) {
        // Handle database read error or document not created yet
      }
      // Return stub during registration transition
      return UserProfile(
        uid: user.uid,
        username: user.displayName ?? '',
        email: user.email ?? '',
        avatarUrl: user.photoURL ?? '',
        colorHex: 'FF5A36',
        totalAreaM2: 0,
        totalRuns: 0,
        totalDistanceM: 0,
        privacySetting: PrivacySetting.public,
        isActive: true,
        isEmailVerified: user.emailVerified,
        lastLoginAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });
  }

  @override
  Future<UserProfile?> get getCurrentUser async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data() != null) {
      return UserProfile.fromMap(doc.data()!, user.uid, isEmailVerified: user.emailVerified);
    }
    return null;
  }

  @override
  Future<bool> checkUsernameUnique(String username) async {
    final cleanUsername = username.trim().toLowerCase();
    if (cleanUsername.length < 3 || cleanUsername.length > 30) {
      return false;
    }
    
    try {
      final result = await _firestore
          .collection('users')
          .where('username_lowercase', isEqualTo: cleanUsername)
          .limit(1)
          .get()
          .timeout(const Duration(seconds: 4));
          
      return result.docs.isEmpty;
    } catch (e) {
      // Log for developer inspection in emulator console
      print('RUN QUEST DEBUG: checkUsernameUnique failed with error: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfile> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) {
      throw Exception('Login failed: User is null');
    }

    final doc = await _firestore.collection('users').doc(credential.user!.uid).get();
    if (!doc.exists) {
      throw Exception('User profile not found in database.');
    }

    // Update last login timestamp
    await _firestore.collection('users').doc(credential.user!.uid).update({
      'lastLoginAt': FieldValue.serverTimestamp(),
    });

    final updatedDoc = await _firestore.collection('users').doc(credential.user!.uid).get();
    return UserProfile.fromMap(updatedDoc.data()!, credential.user!.uid, isEmailVerified: credential.user!.emailVerified);
  }

  @override
  Future<UserProfile> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    final isUnique = await checkUsernameUnique(username);
    if (!isUnique) {
      throw Exception('Username is already taken');
    }

    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Registration failed: User could not be created');
    }

    // Set displayName on Firebase Auth
    await user.updateDisplayName(username);

    // Assign a random unique color to this runner
    final randomColor = _runnerColors[Random().nextInt(_runnerColors.length)];

    final newProfile = UserProfile(
      uid: user.uid,
      username: username,
      email: email,
      avatarUrl: '',
      colorHex: randomColor,
      totalAreaM2: 0.0,
      totalRuns: 0,
      totalDistanceM: 0.0,
      privacySetting: PrivacySetting.public,
      isActive: true,
      isEmailVerified: false,
      lastLoginAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save profile and denormalised username details for fast checks
    await _firestore.collection('users').doc(user.uid).set({
      ...newProfile.toMap(),
      'username_lowercase': username.trim().toLowerCase(),
    });

    // Send email verification immediately (disabled for now)
    // await user.sendEmailVerification();

    return newProfile;
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;
    await user.reload();
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;
    
    // Auth trigger will handle cascade deletions asynchronously.
    // We soft-delete the client profile first.
    await _firestore.collection('users').doc(user.uid).update({
      'isActive': false,
    });
    
    await user.delete();
  }
}
