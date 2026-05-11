import 'package:flutter/material.dart';
import 'package:midterm/state_module/api/catdata_model.dart';
import 'package:midterm/state_module/api/catdata_service.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import '../theme_logic.dart';
import 'about_us_screen.dart';
import 'search_screen.dart';
import '../gridstyle_logic.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Future<List<CatData>>? _futureData;
  final CatService _service = CatService();
  final ScrollController _homeScroller = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _futureData = _service.readCats();

    _homeScroller.addListener(() {
      if (_homeScroller.offset > 300 && !_showBackToTop) {
        setState(() => _showBackToTop = true);
      } else if (_homeScroller.offset <= 300 && _showBackToTop) {
        setState(() => _showBackToTop = false);
      }
    });
  }

  @override
  void dispose() {
    // Always dispose of controllers to prevent memory leaks
    _homeScroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<ThemeLogic>().dark;
    bool gridStyle = context.watch<GridstyleLogic>().gridstyle;

    final List<String> _titles = [
      "CatScout",
      "Search Breeds",
      "About CatScout",
    ];

    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      drawer: _buildDrawer(context, dark, gridStyle),
      body: _futureData == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<CatData>>(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text("No data"));
                }

                final allCats = snapshot.data!;

                return IndexedStack(
                  index: _currentIndex,
                  children: [
                    HomeScreen(allCats: allCats, controller: _homeScroller),
                    SearchScreen(allCats: allCats),
                    AboutUsScreen(),
                  ],
                );
              },
            ),
      floatingActionButton: _currentIndex == 0 ? _buildFloating() : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: dark ? Colors.orange : Colors.brown,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About Us"),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, bool dark, bool gridStyle) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: dark ? Colors.brown.shade900 : Colors.brown,
            ),
            accountName: const Text(
              "Cat",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text("IT Student"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.pets, size: 40, color: Colors.brown),
            ),
          ),
          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: Icon(dark ? Icons.dark_mode : Icons.light_mode),
            value: dark,
            onChanged: (value) {
              context.read<ThemeLogic>().toggleTheme();
            },
          ),
          SwitchListTile(
            title: const Text("Grid View"),
            secondary: Icon(gridStyle ? Icons.grid_view : Icons.list),
            value: gridStyle,
            onChanged: (value) {
              context.read<GridstyleLogic>().toggleStyle();
            },
          ),
          const Spacer(),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "CatScout v1.0.0",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloating() {
    return AnimatedScale(
      scale: _showBackToTop ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack, // Gives it a nice "pop" effect for designers
      child: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          _homeScroller.animateTo(
            0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn,
          );
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
