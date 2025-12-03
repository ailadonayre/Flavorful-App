import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if username is unique (case-insensitive)
  Future<bool> isUsernameUnique(String username) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username.toLowerCase())
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      throw Exception('Error checking username: $e');
    }
  }

  // Register user - FIXED VERSION
  Future<UserModel> registerUser({
    required String username,
    required String displayName,
    required String email,
    required String password,
    required String role,
  }) async {
    UserCredential? userCredential;

    try {
      // Check username uniqueness first
      final isUnique = await isUsernameUnique(username);
      if (!isUnique) {
        throw Exception('Username already taken');
      }

      // Create Firebase Auth user
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User creation failed');
      }

      // Create user model
      final userModel = UserModel(
        uid: user.uid,
        username: username.toLowerCase().trim(),
        displayName: displayName.trim(),
        email: email.trim(),
        role: role,
        createdAt: DateTime.now(),
        isVerifiedChef: false,
      );

      // Create Firestore document
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      // If user was created but Firestore failed, delete the auth user
      if (userCredential?.user != null) {
        try {
          await userCredential!.user!.delete();
        } catch (deleteError) {
          print('Failed to delete user after error: $deleteError');
        }
      }
      throw Exception(_handleAuthException(e));
    } catch (e) {
      // If user was created but Firestore failed, delete the auth user
      if (userCredential?.user != null) {
        try {
          await userCredential!.user!.delete();
        } catch (deleteError) {
          print('Failed to delete user after error: $deleteError');
        }
      }
      throw Exception('Registration failed: $e');
    }
  }

  // Login user - FIXED VERSION
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase Auth
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Login failed - No user returned');
      }

      // Get user data from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // If Firestore document doesn't exist, sign out and throw error
        await _auth.signOut();
        throw Exception('User data not found. Please contact support.');
      }

      final userData = userDoc.data();
      if (userData == null) {
        await _auth.signOut();
        throw Exception('User data is invalid. Please contact support.');
      }

      return UserModel.fromMap(user.uid, userData);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      // Make sure to sign out if there's any error after successful auth
      if (_auth.currentUser != null) {
        await _auth.signOut();
      }

      // Extract the actual error message if it's wrapped in Exception
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      throw Exception(errorMessage);
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists || userDoc.data() == null) {
        return null;
      }

      return UserModel.fromMap(uid, userDoc.data()!);
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak (minimum 6 characters)';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'invalid-verification-code':
        return 'Invalid verification code';
      case 'invalid-verification-id':
        return 'Invalid verification ID';
      default:
        return e.message ?? 'Authentication error occurred';
    }
  }
}