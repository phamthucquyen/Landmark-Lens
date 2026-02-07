import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api.dart';

class WrappedService {
  Future<Map<String, dynamic>> fetchWrapped({
    required String userId,
    int limit = 50,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.wrappedEndpoint}/$userId?limit=$limit',
    );

    final res = await http.get(uri);

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load wrapped: ${res.statusCode}\n${res.body}');
    }
  }
}
