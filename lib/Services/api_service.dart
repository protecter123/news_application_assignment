import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = 'e40f07936b584e2baf8b24172b39defb';

  Future<Map<String, dynamic>> fetchNews() async {
    try {
      // Fetch all 100 articles at once
      final url = '$_baseUrl/everything?q=apple&from=2025-02-19&to=2025-02-19&sortBy=popularity&apiKey=$_apiKey&pageSize=100';
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}

