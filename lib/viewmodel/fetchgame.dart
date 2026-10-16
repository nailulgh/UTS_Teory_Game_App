import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/game.dart';

/// Mengambil daftar seluruh game free-to-play dari endpoint FreeToGame API.
Future<List<Game>> fetchGames() async {
  final response = await http.get(
    Uri.parse('https://www.freetogame.com/api/games'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData
        .map((item) => Game.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Gagal mengambil data game (HTTP ${response.statusCode})');
  }
}

/// Mengambil informasi detail game spesifik berdasarkan [idGame] dari API.
Future<Map<String, dynamic>> fetchDataFromAPI(int idGame) async {
  final response = await http.get(
    Uri.parse('https://www.freetogame.com/api/game?id=$idGame'),
  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    if (jsonData != null && jsonData is Map<String, dynamic>) {
      return jsonData;
    } else {
      throw Exception('Format data dari API tidak sesuai yang diharapkan');
    }
  } else {
    throw Exception('Gagal mengambil detail game dari API (HTTP ${response.statusCode})');
  }
}
