import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:midterm/state_module/api/catdata_model.dart';
import 'package:midterm/state_module/api/catdata_service.dart';
import 'package:midterm/state_module/gridstyle_logic.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  // 1. We now pass the pre-loaded data from MainScreen here
  final List<CatData> allCats;
  final ScrollController? controller;

  const HomeScreen({
    super.key,
    required this.allCats,
    this.controller,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scroller =
      widget.controller ?? ScrollController();

  final _service = CatService();
  late Future<List<CatData>> _futureData = _service.readCats();

  @override
  Widget build(BuildContext context) {
    bool gridStyle = context.watch<GridstyleLogic>().gridstyle;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _futureData = CatService().readCats();
        });
      },
      child: FutureBuilder<List<CatData>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error ${snapshot.error.toString()}"),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _futureData = CatService().readCats();
                    });
                  },
                  child: Text("RETRY"),
                ),
              ],
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return _buildGridView(widget.allCats, gridStyle);
          } else {
            return _buildSkeletonizer(gridStyle);
          }
        },
      ),
    );
  }

  Widget _buildGridView(List<CatData> items, bool gridStyle) {
    if (items.isEmpty) {
      return const Center(child: Text("No cats found."));
    }

    final Map<String, CatData> uniqueMap = {};
    for (var cat in items) {
      if (cat.breeds != null && cat.breeds!.isNotEmpty) {
        uniqueMap.putIfAbsent(cat.breeds!.first.id, () => cat);
      }
    }
    final displayList = uniqueMap.values.toList();

    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double screenWidth = MediaQuery.of(context).size.width;

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 1200 ? (screenWidth - 1200) / 2 : 0,
      ),
      controller: _scroller,
      physics: BouncingScrollPhysics(),
      itemCount: displayList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridStyle ? (isLandscape ? 4 : 2) : 1,
        childAspectRatio: gridStyle ? 0.8 : 1.4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final cat = displayList[index];
        final breed = cat.breeds!.first;

        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () {
              // 4. Create the slideshow by finding all photos of this breed
              final allPhotosOfThisBreed = items
                  .where(
                    (c) =>
                        c.breeds != null &&
                        c.breeds!.isNotEmpty &&
                        c.breeds!.first.id == breed.id,
                  )
                  .toList();

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: cat.url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (_, __) =>
                        Container(color: Colors.grey.shade200),
                    errorWidget: (_, __, ___) => const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        breed.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Origin: ${breed.origin}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonizer(bool gridStyle) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double screenWidth = MediaQuery.of(context).size.width;

    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(),
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 1200 ? (screenWidth - 1200) / 2 : 0,
        ),
        controller: _scroller,
        physics: BouncingScrollPhysics(),
        itemCount: 20,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridStyle ? (isLandscape ? 4 : 2) : 1,
          childAspectRatio: gridStyle ? 0.8 : 1.4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(8),
                    child: Container(
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "title sample textt, text, text, and some text",
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "price sample text",
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
