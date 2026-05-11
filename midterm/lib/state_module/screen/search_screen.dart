import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../api/catdata_model.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<CatData> allCats;

  const SearchScreen({super.key, required this.allCats});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<CatData> _filteredCats = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _applyUniqueFilter(widget.allCats);
  }

  // Helper to make sure we only show one result per breed in the search list
  void _applyUniqueFilter(List<CatData> sourceList) {
    final Map<String, CatData> uniqueMap = {};
    for (var cat in sourceList) {
      if (cat.breeds != null && cat.breeds!.isNotEmpty) {
        uniqueMap.putIfAbsent(cat.breeds!.first.id, () => cat);
      }
    }
    _filteredCats = uniqueMap.values.toList();
  }

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      setState(() {
        _applyUniqueFilter(widget.allCats);
      });
      return;
    }

    final results = widget.allCats.where((cat) {
      final breedName = (cat.breeds != null && cat.breeds!.isNotEmpty)
          ? cat.breeds!.first.name.toLowerCase()
          : "";
      return breedName.contains(enteredKeyword.toLowerCase());
    }).toList();

    setState(() {
      _applyUniqueFilter(results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _controller,
            onChanged: (value) => _runFilter(value),
            decoration: InputDecoration(
              labelText: 'Search Breeds',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _runFilter("");
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: _filteredCats.isNotEmpty
              ? ListView.builder(
                  itemCount: _filteredCats.length,
                  itemBuilder: (context, index) {
                    final cat = _filteredCats[index];
                    final breed = cat.breeds.first;

                    return ListTile(
                      onTap: () {
                        // FILTER: Find ALL photos of this breed for the slideshow
                        final allPhotosOfThisBreed = widget.allCats.where((c) {
                          return c.breeds != null &&
                              c.breeds!.isNotEmpty &&
                              c.breeds!.first.id == breed.id;
                        }).toList();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              allPhotosOfThisBreed,
                              cat: cat,
                            ),
                          ),
                        );
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: cat.url,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              const CircularProgressIndicator(strokeWidth: 2),
                          errorWidget: (_, __, ___) => const Icon(Icons.pets),
                        ),
                      ),
                      title: Text(breed.name),
                      subtitle: Text(breed.origin),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    );
                  },
                )
              : const Center(
                  child: Text("No breeds found. Try something else!"),
                ),
        ),
      ],
    );
  }
}
