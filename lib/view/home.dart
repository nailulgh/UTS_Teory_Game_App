import 'package:flutter/material.dart';
import '../model/game.dart';
import '../viewmodel/fetchgame.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // UI/UX Pro Max Semantic Color Tokens (Obsidian Gaming Dark)
  static const Color bgPrimary = Color(0xFF0F0F23);
  static const Color bgSurface = Color(0xFF1E1C35);
  static const Color bgElevated = Color(0xFF27273B);
  static const Color brandPrimary = Color(0xFF7C3AED);
  static const Color brandSecondary = Color(0xFFA78BFA);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color borderSubtle = Color(0xFF312E51);

  late Future<List<Game>> gameList;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedGenre = 'Semua';

  final List<Map<String, dynamic>> _genreCategories = const [
    {'label': 'Semua', 'query': 'Semua', 'icon': Icons.grid_view_rounded},
    {'label': 'Menembak', 'query': 'Shooter', 'icon': Icons.gps_fixed_rounded},
    {'label': 'MMORPG', 'query': 'MMORPG', 'icon': Icons.shield_rounded},
    {'label': 'Strategi', 'query': 'Strategy', 'icon': Icons.extension_rounded},
    {'label': 'MOBA', 'query': 'MOBA', 'icon': Icons.flash_on_rounded},
    {'label': 'Balap', 'query': 'Racing', 'icon': Icons.directions_car_filled_rounded},
    {'label': 'Olahraga', 'query': 'Sports', 'icon': Icons.sports_soccer_rounded},
  ];

  @override
  void initState() {
    super.initState();
    gameList = loadGames();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Game>> loadGames() async {
    return fetchGames();
  }

  List<Game> _filterGames(List<Game> allGames) {
    final query = _searchQuery.toLowerCase().trim();
    return allGames.where((game) {
      final matchesGenre = _selectedGenre == 'Semua' ||
          game.genre.toLowerCase().contains(_selectedGenre.toLowerCase());
      final matchesSearch = query.isEmpty ||
          game.title.toLowerCase().contains(query) ||
          game.genre.toLowerCase().contains(query) ||
          game.developer.toLowerCase().contains(query);
      return matchesGenre && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPrimary,
      body: SafeArea(
        child: FutureBuilder<List<Game>>(
          future: gameList,
          builder: (context, snapshot) {
            final totalLoaded = snapshot.hasData ? snapshot.data!.length : 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Header & Search Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopHeader(totalLoaded),
                      const SizedBox(height: 14),
                      _searchBar(),
                    ],
                  ),
                ),

                // 2. Horizontal Genre Category Chips
                SizedBox(
                  height: 76,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    scrollDirection: Axis.horizontal,
                    itemCount: _genreCategories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final cat = _genreCategories[index];
                      final isSelected = _selectedGenre == cat['query'];
                      return _buildGenreChip(
                        label: cat['label'] as String,
                        queryValue: cat['query'] as String,
                        icon: cat['icon'] as IconData,
                        isSelected: isSelected,
                      );
                    },
                  ),
                ),

                // 3. Dynamic Content Area from API
                Expanded(
                  child: _buildDynamicContent(snapshot),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopHeader(int totalGames) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: brandPrimary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: brandPrimary.withValues(alpha: 0.5)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt_rounded, color: accentAmber, size: 13),
                        SizedBox(width: 4),
                        Text(
                          'FREETOGAME LIVE API',
                          style: TextStyle(
                            color: brandSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (totalGames > 0) ...[
                    const SizedBox(width: 8),
                    Text(
                      '• $totalGames Game',
                      style: const TextStyle(
                        color: textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Selamat Datang',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Info game apa yang kamu butuhkan hari ini?',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [brandPrimary, Color(0xFF4F46E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: brandPrimary.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.sports_esports_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      style: const TextStyle(color: textPrimary, fontSize: 14),
      cursorColor: brandSecondary,
      decoration: InputDecoration(
        fillColor: bgSurface,
        filled: true,
        hintText: 'Masukkan judul game, genre, atau developer...',
        hintStyle: const TextStyle(fontSize: 13, color: textSecondary),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: brandSecondary,
          size: 22,
        ),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded, color: textSecondary, size: 18),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
              )
            : Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentAmber,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune_rounded, color: Color(0xFF0F0F23), size: 18),
              ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderSubtle, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: brandPrimary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildGenreChip({
    required String label,
    required String queryValue,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGenre = queryValue;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? brandPrimary : bgSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? brandSecondary : borderSubtle,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: brandPrimary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : accentAmber,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : textSecondary,
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicContent(AsyncSnapshot<List<Game>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: brandPrimary),
            SizedBox(height: 14),
            Text(
              'Mengambil katalog game dari server API...',
              style: TextStyle(color: textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    } else if (snapshot.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_rounded, color: Colors.redAccent, size: 48),
              const SizedBox(height: 12),
              Text(
                'Gagal Memuat Data API\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: textPrimary, fontSize: 13.5),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    gameList = loadGames();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandPrimary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada data game dari API.',
          style: TextStyle(color: textSecondary),
        ),
      );
    }

    final allGames = snapshot.data!;
    final filteredGames = _filterGames(allGames);
    final popularGames = allGames.take(6).toList();
    final showPopularCarousel = _searchQuery.isEmpty && _selectedGenre == 'Semua';

    if (filteredGames.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, color: textSecondary, size: 48),
            const SizedBox(height: 10),
            Text(
              'Game dengan kata kunci "$_searchQuery" tidak ditemukan.',
              style: const TextStyle(color: textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      itemCount: filteredGames.take(35).length + (showPopularCarousel ? 2 : 1),
      itemBuilder: (context, index) {
        if (showPopularCarousel) {
          if (index == 0) {
            return _buildPopularSection(popularGames);
          }
          if (index == 1) {
            return _buildSectionTitle('Game Terbaru & Rekomendasi', filteredGames.length);
          }
          final game = filteredGames[index - 2];
          return _buildGameCardWrapper(game);
        } else {
          if (index == 0) {
            return _buildSectionTitle(
              'Hasil Filter ($_selectedGenre)',
              filteredGames.length,
            );
          }
          final game = filteredGames[index - 1];
          return _buildGameCardWrapper(game);
        }
      },
    );
  }

  Widget _buildPopularSection(List<Game> popularGames) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Game Populer',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Top Picks API',
                style: TextStyle(
                  color: accentAmber,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 148,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: popularGames.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final g = popularGames[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/detail', arguments: g.id);
                },
                child: Container(
                  width: 235,
                  decoration: BoxDecoration(
                    color: bgSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderSubtle),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        g.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: bgElevated,
                          child: const Icon(Icons.videogame_asset, color: textSecondary),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.1),
                              Colors.black.withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: brandPrimary.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            g.genre,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              g.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              g.developer,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFFCBD5E1),
                                fontSize: 11,
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
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionTitle(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: bgElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count Game',
              style: const TextStyle(
                color: brandSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCardWrapper(Game game) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detail',
            arguments: game.id,
          );
        },
        child: _listItem(
          game.thumbnail,
          game.title,
          game.genre,
          releaseDate: game.releaseDate,
          platform: game.platform,
        ),
      ),
    );
  }
}

Card _listItem(
  String urlCover,
  String judul,
  String genre, {
  String releaseDate = '-',
  String platform = 'PC',
}) {
  return Card(
    color: const Color(0xFF1E1C35),
    clipBehavior: Clip.antiAlias,
    elevation: 2,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: Color(0xFF312E51), width: 1),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          // Landscape 16:9 Thumbnail
          SizedBox(
            width: 112,
            height: 74,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                urlCover,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF27273B),
                  child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title, Genre, & Release Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFF8FAFC),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        genre,
                        style: const TextStyle(
                          color: Color(0xFFA78BFA),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        platform.contains('Windows') ? 'PC' : 'Web',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 10.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 11,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        releaseDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // CTA Pill Button ("Baca Info")
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Baca Info',
              style: TextStyle(
                color: Color(0xFF0F0F23),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
