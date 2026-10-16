// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailgame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MinimumSystemRequirements _$MinimumSystemRequirementsFromJson(
  Map<String, dynamic> json,
) => MinimumSystemRequirements(
  os: json['os'] as String?,
  processor: json['processor'] as String?,
  memory: json['memory'] as String?,
  graphics: json['graphics'] as String?,
  storage: json['storage'] as String?,
);

Map<String, dynamic> _$MinimumSystemRequirementsToJson(
  MinimumSystemRequirements instance,
) => <String, dynamic>{
  'os': instance.os,
  'processor': instance.processor,
  'memory': instance.memory,
  'graphics': instance.graphics,
  'storage': instance.storage,
};

Screenshot _$ScreenshotFromJson(Map<String, dynamic> json) => Screenshot(
  id: (json['id'] as num?)?.toInt() ?? 0,
  image: json['image'] as String? ?? '',
);

Map<String, dynamic> _$ScreenshotToJson(Screenshot instance) =>
    <String, dynamic>{'id': instance.id, 'image': instance.image};

DetailGame _$DetailGameFromJson(Map<String, dynamic> json) => DetailGame(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  thumbnail: json['thumbnail'] as String? ?? '',
  status: json['status'] as String? ?? 'Live',
  shortDescription: json['short_description'] as String? ?? '',
  description: json['description'] as String? ?? '',
  gameUrl: json['game_url'] as String? ?? '',
  genre: json['genre'] as String? ?? '',
  platform: json['platform'] as String? ?? '',
  publisher: json['publisher'] as String? ?? '-',
  developer: json['developer'] as String? ?? '-',
  releaseDate: json['release_date'] as String? ?? '-',
  freetogameProfileUrl: json['freetogame_profile_url'] as String? ?? '',
  minimumSystemRequirements: json['minimum_system_requirements'] == null
      ? null
      : MinimumSystemRequirements.fromJson(
          json['minimum_system_requirements'] as Map<String, dynamic>,
        ),
  screenshots: (json['screenshots'] as List<dynamic>?)
          ?.map((e) => Screenshot.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$DetailGameToJson(DetailGame instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'status': instance.status,
      'short_description': instance.shortDescription,
      'description': instance.description,
      'game_url': instance.gameUrl,
      'genre': instance.genre,
      'platform': instance.platform,
      'publisher': instance.publisher,
      'developer': instance.developer,
      'release_date': instance.releaseDate,
      'freetogame_profile_url': instance.freetogameProfileUrl,
      'minimum_system_requirements': instance.minimumSystemRequirements,
      'screenshots': instance.screenshots,
    };
