import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io' show Platform;

class ApiService {
  // Use 10.0.2.2 for Android emulator to connect to local backend
  static String get baseUrl {
    return 'http://10.0.2.2:3000';
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Map<String, String> _headers({String? token}) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      String errorMessage = body['message'] ?? 'Something went wrong';
      if (body['errors'] != null && body['errors'] is List) {
        final errorDetails = (body['errors'] as List)
            .map((e) => '${e['field']}: ${e['message']}')
            .join(', ');
        errorMessage += ' ($errorDetails)';
      }
      throw Exception(errorMessage);
    }
  }

  // ── AUTH ───────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    String language = 'en',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: _headers(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'language': language,
      }),
    );
    final result = await _handleResponse(response);
    if (result['data']?['token'] != null) {
      await _saveToken(result['data']['token']);
    }
    return result;
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    final result = await _handleResponse(response);
    if (result['data']?['token'] != null) {
      await _saveToken(result['data']['token']);
    }
    return result;
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: _headers(),
      body: jsonEncode({'email': email}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: _headers(token: token),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/user/profile'),
      headers: _headers(token: token),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> updateProfileImage({required String imagePath}) async {
    final token = await _getToken();
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/user/upload-image'));
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.files.add(await http.MultipartFile.fromPath('profileImage', imagePath));
    
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  // ── SUBSCRIPTION ──────────────────────────────────────────────

  static Future<Map<String, dynamic>> getPlans() async {
    final response = await http.get(
      Uri.parse('$baseUrl/subscription/plans'),
      headers: _headers(),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> upgradePlan({
    required String planType,
    String cardNumber = '',
    String cardName = '',
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/subscription/upgrade'),
      headers: _headers(token: token),
      body: jsonEncode({
        'plan_type': planType,
        'card_number': cardNumber,
        'card_name': cardName,
      }),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getSubscriptionStatus() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/subscription/status'),
      headers: _headers(token: token),
    );
    return _handleResponse(response);
  }

  // ── AI ────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> generateBusiness({
    required String industry,
    required String budget,
    String location = 'Pakistan',
    String language = 'en',
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/ai/generate-business'),
      headers: _headers(token: token),
      body: jsonEncode({
        'industry': industry,
        'budget': budget,
        'location': location,
        'language': language,
      }),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> generatePost({
    required String businessName,
    required String product,
    required String platform,
    String tone = 'engaging',
    String language = 'en',
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/ai/generate-post'),
      headers: _headers(token: token),
      body: jsonEncode({
        'business_name': businessName,
        'product': product,
        'platform': platform,
        'tone': tone,
        'language': language,
      }),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> generateMarketingPlan({
    required String businessName,
    required String industry,
    String targetAudience = '',
    String budget = '',
    String language = 'en',
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/ai/generate-plan'),
      headers: _headers(token: token),
      body: jsonEncode({
        'business_name': businessName,
        'industry': industry,
        'target_audience': targetAudience,
        'budget': budget,
        'language': language,
      }),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> generateHashtags({
    required List<String> keywords,
    String platform = 'instagram',
    int count = 15,
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/ai/generate-hashtags'),
      headers: _headers(token: token),
      body: jsonEncode({
        'keywords': keywords,
        'platform': platform,
        'count': count,
      }),
    );
    return _handleResponse(response);
  }

  // ── CHAT ──────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> createNewChat({String language = 'en'}) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/chat/new'),
      headers: _headers(token: token),
      body: jsonEncode({'language': language}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> sendChatMessage({
    required String message,
    String? chatId,
    String language = 'en',
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/chat/message'),
      headers: _headers(token: token),
      body: jsonEncode({
        'message': message,
        if (chatId != null) 'chat_id': chatId,
        'language': language,
      }),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getChatHistory() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/chat/history'),
      headers: _headers(token: token),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> deleteChat(String chatId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/chat/$chatId'),
      headers: _headers(token: token),
    );
    return _handleResponse(response);
  }

  // ── SOCIAL ────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> createSocialPost({
    required String platform,
    required String content,
    List<String> hashtags = const [],
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/social/create-post'),
      headers: _headers(token: token),
      body: jsonEncode({
        'platform': platform,
        'content': content,
        'hashtags': hashtags,
      }),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getSocialPosts() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/social/posts'),
      headers: _headers(token: token),
    );
    return _handleResponse(response);
  }

  // ── ANALYTICS ─────────────────────────────────────────────────

  static Future<Map<String, dynamic>> getAnalytics() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/analytics'),
      headers: _headers(token: token),
    );
    return _handleResponse(response);
  }

  // ── WEBSITE ───────────────────────────────────────────────────

  static Future<Map<String, dynamic>> generateWebsite({
    required String businessName,
    required String businessIdea,
    String industry = '',
    String language = 'en',
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/website/generate'),
      headers: _headers(token: token),
      body: jsonEncode({
        'business_name': businessName,
        'business_idea': businessIdea,
        'industry': industry,
        'language': language,
      }),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getMyWebsites() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/website/my-websites'),
      headers: _headers(token: token),
    );
    return _handleResponse(response);
  }

  // ── LOGO ──────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> generateLogo({
    required String businessName,
    String colorTheme = 'professional',
    String shape = 'circle',
    String fontStyle = 'bold',
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/logo/generate'),
      headers: _headers(token: token),
      body: jsonEncode({
        'business_name': businessName,
        'color_theme': colorTheme,
        'shape': shape,
        'font_style': fontStyle,
      }),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getMyLogos() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/logo/my-logos'),
      headers: _headers(token: token),
    );
    return _handleResponse(response);
  }

  // ================= SUBSCRIPTION =================
  static Future<Map<String, dynamic>> upgradeSubscription({required String planType}) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/subscription/upgrade'),
      headers: _headers(token: token),
      body: jsonEncode({
        'plan_type': planType,
      }),
    );
    return _handleResponse(response);
  }
}
