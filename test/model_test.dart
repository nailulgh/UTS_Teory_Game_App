import 'package:flutter_test/flutter_test.dart';
import 'package:uts_teori_game_app/model/game.dart';
import 'package:uts_teori_game_app/model/detailgame.dart';

void main() {
  group('Model Deserialization Tests', () {
    test('Game.fromJson parses valid JSON catalog item', () {
      final sampleJson = {
        'id': 540,
        'title': 'Overwatch 2',
        'thumbnail': 'https://www.freetogame.com/g/540/thumbnail.jpg',
        'short_description': 'A hero-focused first-person team shooter.',
        'game_url': 'https://www.freetogame.com/open/overwatch-2',
        'genre': 'Shooter',
        'platform': 'PC (Windows)',
        'publisher': 'Blizzard Entertainment',
        'developer': 'Blizzard Entertainment',
        'release_date': '2022-10-04',
        'freetogame_profile_url': 'https://www.freetogame.com/overwatch-2',
      };

      final game = Game.fromJson(sampleJson);

      expect(game.id, 540);
      expect(game.title, 'Overwatch 2');
      expect(game.genre, 'Shooter');
      expect(game.platform, 'PC (Windows)');
      expect(game.developer, 'Blizzard Entertainment');
      expect(game.releaseDate, '2022-10-04');
    });

    test('DetailGame.fromJson parses nested JSON specifications and screenshots', () {
      final sampleDetailJson = {
        'id': 540,
        'title': 'Overwatch 2',
        'thumbnail': 'https://www.freetogame.com/g/540/thumbnail.jpg',
        'status': 'Live',
        'short_description': 'A hero shooter',
        'description': 'Full game description with extensive details.',
        'game_url': 'https://www.freetogame.com/open/overwatch-2',
        'genre': 'Shooter',
        'platform': 'Windows',
        'publisher': 'Blizzard Entertainment',
        'developer': 'Blizzard Entertainment',
        'release_date': '2022-10-04',
        'freetogame_profile_url': 'https://www.freetogame.com/overwatch-2',
        'minimum_system_requirements': {
          'os': 'Windows 10 64-bit',
          'processor': 'Intel Core i3 or AMD Phenom X3 8650',
          'memory': '6 GB RAM',
          'graphics': 'NVIDIA GeForce GTX 600 series or AMD Radeon HD 7000 series',
          'storage': '50 GB available space',
        },
        'screenshots': [
          {'id': 1, 'image': 'https://www.freetogame.com/g/540/overwatch-2-1.jpg'},
          {'id': 2, 'image': 'https://www.freetogame.com/g/540/overwatch-2-2.jpg'},
        ],
      };

      final detail = DetailGame.fromJson(sampleDetailJson);

      expect(detail.id, 540);
      expect(detail.title, 'Overwatch 2');
      expect(detail.status, 'Live');
      expect(detail.minimumSystemRequirements?.os, 'Windows 10 64-bit');
      expect(detail.minimumSystemRequirements?.storage, '50 GB available space');
      expect(detail.screenshots.length, 2);
      expect(detail.screenshots.first.image, 'https://www.freetogame.com/g/540/overwatch-2-1.jpg');
    });
  });
}
