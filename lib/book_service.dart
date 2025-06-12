import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secrets.dart';

class BookService {
  static Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    final url =
        'https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeComponent(query)}&key=$googleBooksApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List?;

      if (items == null) return [];

      return items.map((book) {
        final info = book['volumeInfo'];
        return {
          'title': info['title'] ?? 'No Title',
          'description': info['description'] ?? 'No Description',
          'thumbnail': info['imageLinks']?['thumbnail'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
