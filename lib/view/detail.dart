import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../model/detailgame.dart';
import '../viewmodel/fetchgame.dart';

class Detail extends StatefulWidget {
  final int gameTerpilih;

  const Detail({super.key, required this.gameTerpilih});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  static const Color bgPrimary = Color(0xFF0F0F23);
  static const Color bgSurface = Color(0xFF1E1C35);
  static const Color bgElevated = Color(0xFF27273B);
  static const Color brandPrimary = Color(0xFF7C3AED);
  static const Color brandSecondary = Color(0xFFA78BFA);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color borderSubtle = Color(0xFF312E51);

  late Future<DetailGame> _detailGameFuture;

  @override
  void initState() {
    super.initState();
    _detailGameFuture = fetchData();
  }

  Future<DetailGame> fetchData() async {
    final jsonData = await fetchDataFromAPI(widget.gameTerpilih);
    return DetailGame.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPrimary,
      body: FutureBuilder<DetailGame>(
        future: _detailGameFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: brandPrimary),
                  SizedBox(height: 14),
                  Text(
                    'Memuat detail & spesifikasi game...',
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
                    const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Terjadi kesalahan: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: textPrimary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _detailGameFuture = fetchData();
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: brandPrimary),
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      label: const Text('Muat Ulang', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('Data tidak tersedia', style: TextStyle(color: textSecondary)),
            );
          }

          final game = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Cover Artwork + Gradient Scrim + Back Button
                SizedBox(
                  height: 285,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(26),
                          bottomRight: Radius.circular(26),
                        ),
                        child: Image.network(
                          game.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: bgElevated,
                            child: const Icon(Icons.broken_image_rounded, size: 50, color: Colors.grey),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(26),
                            bottomRight: Radius.circular(26),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.25),
                              bgPrimary.withValues(alpha: 0.95),
                            ],
                          ),
                        ),
                      ),
                      // Tombol Back (Touch target >= 44x44dp)
                      Positioned(
                        top: 42,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: bgSurface.withValues(alpha: 0.85),
                              shape: BoxShape.circle,
                              border: Border.all(color: borderSubtle),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      // Status Badge (LIVE)
                      Positioned(
                        top: 46,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: accentEmerald.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: accentEmerald),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.circle, color: accentEmerald, size: 8),
                              const SizedBox(width: 5),
                              Text(
                                game.status.toUpperCase(),
                                style: const TextStyle(
                                  color: accentEmerald,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Title & Genre Overlay on Bottom of Banner
                      Positioned(
                        bottom: 16,
                        left: 18,
                        right: 18,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: brandPrimary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    game.genre,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: bgElevated,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    game.platform,
                                    style: const TextStyle(
                                      color: brandSecondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              game.title,
                              style: const TextStyle(
                                color: textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),

                      // 2. Bento Metadata Bar (Developer, Publisher, Release Date)
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetaCard(
                              Icons.code_rounded,
                              'Developer',
                              game.developer,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildMetaCard(
                              Icons.business_rounded,
                              'Publisher',
                              game.publisher,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildMetaCard(
                              Icons.event_available_rounded,
                              'Rilis',
                              game.releaseDate,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // 3. Minimum System Requirements Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderSubtle),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.memory_rounded, color: accentAmber, size: 19),
                                SizedBox(width: 8),
                                Text(
                                  'Minimum System Requirements',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(color: borderSubtle, height: 1),
                            ),
                            if (game.minimumSystemRequirements != null) ...[
                              _requirementRow('OS', game.minimumSystemRequirements?.os ?? '-'),
                              const SizedBox(height: 8),
                              _requirementRow('Processor', game.minimumSystemRequirements?.processor ?? '-'),
                              const SizedBox(height: 8),
                              _requirementRow('Memory', game.minimumSystemRequirements?.memory ?? '-'),
                              const SizedBox(height: 8),
                              _requirementRow('Graphics', game.minimumSystemRequirements?.graphics ?? '-'),
                              const SizedBox(height: 8),
                              _requirementRow('Storage', game.minimumSystemRequirements?.storage ?? '-'),
                            ] else
                              const Text(
                                'Game ini dapat dimainkan langsung melalui Web Browser / spesifikasi standar tanpa kebutuhan perangkat keras khusus.',
                                style: TextStyle(color: textSecondary, fontSize: 12.5),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 4. Horizontal Screenshots Gallery
                      if (game.screenshots.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'In-Game Screenshots',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              '${game.screenshots.length} Foto',
                              style: const TextStyle(
                                fontSize: 12,
                                color: brandSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 155,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: game.screenshots.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              return _itemList(game.screenshots[index].image);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // 5. About / Description Card with ReadMoreText
                      const Text(
                        'Deskripsi Game',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderSubtle),
                        ),
                        child: ReadMoreText(
                          game.description,
                          trimLines: 4,
                          colorClickableText: accentAmber,
                          trimMode: TrimMode.Line,
                          style: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 13.5,
                            height: 1.6,
                          ),
                          trimCollapsedText: '  more',
                          trimExpandedText: '  less',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetaCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: brandSecondary),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

SizedBox _itemList(String url) {
  return SizedBox(
    width: 250,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFF27273B),
          child: const Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey),
        ),
      ),
    ),
  );
}

Row _requirementRow(String title, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 3,
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const Expanded(
        flex: 1,
        child: Text(
          ':',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
        ),
      ),
      Expanded(
        flex: 8,
        child: Text(
          value,
          style: const TextStyle(
            color: Color(0xFFF8FAFC),
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}
