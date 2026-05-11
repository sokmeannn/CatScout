import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:midterm/state_module/api/catdata_model.dart';

class DetailScreen extends StatefulWidget {
  final List<CatData> catList;
  final CatData cat;

  const DetailScreen(this.catList, {super.key, required this.cat});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Find where the clicked cat is in the list to start the slideshow there
    _currentPage = widget.catList.indexOf(widget.cat);
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    // FIX: Use the cat at the current index so the text updates when you swipe
    final currentCat = widget.catList[_currentPage];
    final breed = currentCat.breeds.first;

    return Scaffold(
      appBar: AppBar(title: Text(breed.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SLIDESHOW
            SizedBox(
              height: 350, // Slightly taller for better design
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.catList.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: widget.catList[index].url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                  // INDICATOR DOTS
                  if (widget.catList.length > 1)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: List.generate(widget.catList.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: _currentPage == index ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 2),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
            // BREED DETAILS
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    breed.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Origin: ${breed.origin}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const Divider(height: 32),
                  const Text(
                    "About this breed",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    breed.description,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // STAT CARDS
                  _buildStatCard(
                    Icons.favorite,
                    "Temperament",
                    breed.temperament,
                  ),
                  _buildStatCard(
                    Icons.hourglass_bottom,
                    "Life Span",
                    "${breed.lifeSpan} years",
                  ),
                  _buildStatCard(
                    Icons.lightbulb,
                    "Intelligence",
                    "${breed.intelligence} / 5",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      color: Colors.brown.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.brown.shade100),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.brown),
        title: Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
