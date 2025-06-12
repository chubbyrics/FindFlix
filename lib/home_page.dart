import 'package:flutter/material.dart';
import 'movie_service.dart';
import 'book_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key); // 👈 added Key

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchType = 'Movie';
  String query = '';
  bool isLoading = false;
  List<Map<String, dynamic>> results = [];

  void search() async {
    if (query.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      results = [];
    });

    try {
      if (searchType == 'Movie') {
        results = await MovieService.searchMovies(query);
      } else {
        results = await BookService.searchBooks(query);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movie & Book Recommender',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [searchType == 'Movie', searchType == 'Book'],
              borderRadius: BorderRadius.circular(10),
              borderColor: Colors.deepPurple,
              selectedColor: Colors.white,
              fillColor: Colors.deepPurple,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('🎬 Movie'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('📚 Book'),
                ),
              ],
              onPressed: (index) {
                setState(() {
                  searchType = index == 0 ? 'Movie' : 'Book';
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by genre or keyword',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) => query = val,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: search,
              icon: const Icon(Icons.search),
              label: const Text('Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              Column(
                children: const [
                  CircularProgressIndicator(color: Colors.deepPurple),
                  SizedBox(height: 10),
                  Text('Searching...', style: TextStyle(color: Colors.deepPurple)),
                ],
              )
            else if (results.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final item = results[index];
                    final imageUrl = searchType == 'Movie'
                        ? (item['poster'] != null
                            ? 'https://image.tmdb.org/t/p/w200${item['poster']}'
                            : null)
                        : item['thumbnail'];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  width: 50,
                                  height: 75,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.image_not_supported, size: 40),
                        title: Text(
                          item['title'] ?? 'No Title',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          item['overview'] ?? item['description'] ?? 'No description available',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
