import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secrets.dart';

class MovieService {
  static Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=$tmdbApiKey&query=${Uri.encodeComponent(query)}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((movie) {
        return {
          'title': movie['title'],
          'overview': movie['overview'],
          'poster': movie['poster_path'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
