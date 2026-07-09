import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../models/subscription_plan.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // In-memory user database (simulates backend)
  final Map<String, UserModel> _registeredUsers = {};
  // Track active sessions: email -> sessionToken
  final Map<String, String> _activeSessions = {};

  static const _uuid = Uuid();

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    // Seed with admin user
    final adminHash = _hashPassword('admin');
    _registeredUsers['admin@synapse.com'] = UserModel(
      id: 'admin-001',
      name: 'Admin',
      email: 'admin@synapse.com',
      planId: 'pro',
      avatarUrl: '',
      passwordHash: adminHash,
    );
    _tryAutoLogin();
  }

  /// Hash password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate a unique session token (JWT-like)
  String _generateSessionToken(String email) {
    final header = base64Encode(utf8.encode('{"alg":"HS256","typ":"JWT"}'));
    final payload = base64Encode(utf8.encode(json.encode({
      'email': email,
      'iat': DateTime.now().millisecondsSinceEpoch,
      'exp': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
      'jti': _uuid.v4(),
    })));
    final signature = _hashPassword('$header.$payload.brandora-secret-key');
    return '$header.$payload.${signature.substring(0, 16)}';
  }

  /// Check if session token is valid (not expired)
  bool _isTokenValid(String? token) {
    if (token == null) return false;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      final payload = json.decode(utf8.decode(base64Decode(parts[1])));
      final expiry = DateTime.fromMillisecondsSinceEpoch(payload['exp']);
      return DateTime.now().isBefore(expiry);
    } catch (e) {
      return false;
    }
  }

  /// Try to restore previous session
  Future<void> _tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('session_token');
      if (token != null) {
        final response = await ApiService.getProfile();
        if (response['success'] == true) {
          final userData = response['data'];
          _currentUser = UserModel(
            id: userData['user_id'] ?? _uuid.v4(),
            name: userData['name'] ?? 'User',
            email: userData['email'] ?? '',
            planId: userData['plan'] ?? 'free_trial',
            avatarUrl: userData['profile_image'] ?? '',
            sessionToken: token,
          );
        }
      }
    } catch (_) {
      // Silently fail auto-login
    }
    notifyListeners();
  }

  /// Save session to local storage
  Future<void> _saveSession(String email, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_token', token);
    await prefs.setString('user_email', email);
  }

  /// Clear session from local storage
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');
    await prefs.remove('user_email');
    await ApiService.clearToken();
  }

  /// Register a new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String planId,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await ApiService.signup(
        name: name,
        email: email.toLowerCase(),
        password: password,
      );

      final userData = response['data']['user'];
      final sessionToken = response['data']['token'];

      final user = UserModel(
        id: userData['user_id'] ?? _uuid.v4(),
        name: userData['name'] ?? name,
        email: userData['email'] ?? email.toLowerCase(),
        planId: userData['plan'] ?? 'free_trial',
        avatarUrl: userData['profileImage'] ?? '',
        sessionToken: sessionToken,
        sessionCreatedAt: DateTime.now(),
        planCreatedAt: DateTime.now(),
      );

      _currentUser = user;
      await _saveSession(email.toLowerCase(), sessionToken);

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  /// Upgrade subscription plan
  Future<bool> upgradeSubscription(String planId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await ApiService.upgradeSubscription(planType: planId);
      
      if (response['success'] == true) {
        if (_currentUser != null) {
          _currentUser = _currentUser!.copyWith(planId: planId);
        }
        notifyListeners();
        _setLoading(false);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  /// Update Profile Image
  Future<bool> updateProfileImage(String imagePath) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await ApiService.updateProfileImage(imagePath: imagePath);
      if (response['success'] == true) {
        if (_currentUser != null) {
          final imageUrl = response['data']['profileImage'] ?? '';
          _currentUser = _currentUser!.copyWith(avatarUrl: imageUrl);
          notifyListeners();
        }
        _setLoading(false);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  /// Update Profile (Name)
  Future<bool> updateProfile(String name) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await ApiService.updateProfile({'name': name});
      if (response['success'] == true) {
        if (_currentUser != null) {
          _currentUser = _currentUser!.copyWith(name: name);
          notifyListeners();
        }
        _setLoading(false);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  /// Login with email/username and password
  Future<bool> login(String emailOrUsername, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await ApiService.login(
        email: emailOrUsername.trim().toLowerCase(),
        password: password,
      );

      final userData = response['data']['user'];
      final sessionToken = response['data']['token'];

      final user = UserModel(
        id: userData['user_id'] ?? _uuid.v4(),
        name: userData['name'] ?? 'User',
        email: userData['email'] ?? emailOrUsername.toLowerCase(),
        planId: userData['plan'] ?? 'free_trial',
        avatarUrl: userData['profileImage'] ?? '',
        sessionToken: sessionToken,
        sessionCreatedAt: DateTime.now(),
        planCreatedAt: DateTime.now(),
      );

      _currentUser = user;
      await _saveSession(emailOrUsername.trim().toLowerCase(), sessionToken);

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  /// Validate current session (prevents credential sharing)
  bool validateSession() {
    if (_currentUser == null) return false;
    final email = _currentUser!.email;
    final currentToken = _currentUser!.sessionToken;

    // Check if session is still the active one
    if (_activeSessions[email] != currentToken) {
      return false;
    }

    // Check if token is expired
    if (!_isTokenValid(currentToken)) {
      return false;
    }

    return true;
  }

  /// Check if email is already registered
  bool isEmailRegistered(String email) {
    return _registeredUsers.containsKey(email.toLowerCase());
  }

  Future<void> logout() async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));

    if (_currentUser != null) {
      _activeSessions.remove(_currentUser!.email);
    }

    _currentUser = null;
    await _clearSession();
    _setLoading(false);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Check if user has access to a specific feature
  bool hasFeatureAccess(String featureName) {
    if (_currentUser == null) return false;
    
    final plan = SubscriptionPlan.allPlans.firstWhere(
      (p) => p.id == _currentUser!.planId,
      orElse: () => SubscriptionPlan.allPlans.first,
    );

    // Case-insensitive check
    return plan.features.any((f) => f.toLowerCase().contains(featureName.toLowerCase())) || 
           _currentUser!.planId == 'pro';
  }

  /// Get remaining days for current plan
  int getRemainingDays() {
    if (_currentUser == null) return 0;
    
    final plan = SubscriptionPlan.allPlans.firstWhere(
      (p) => p.id == _currentUser!.planId,
      orElse: () => SubscriptionPlan.allPlans.first,
    );

    final createdAt = _currentUser!.planCreatedAt ?? DateTime.now();
    final expiryDate = createdAt.add(Duration(days: plan.daysLimit));
    return expiryDate.difference(DateTime.now()).inDays;
  }
}


