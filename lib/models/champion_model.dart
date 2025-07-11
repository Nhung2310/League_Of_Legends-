class ChampionModel {
  final Map<String, Champion> data;
  final String version;
  final String type;
  ChampionModel({
    required this.data,
    required this.version,
    required this.type,
  });

  factory ChampionModel.fromJson(Map<String, dynamic> json) {
    Map<String, Champion> championMap = {};
    if (json['data'] != null) {
      json['data'].forEach((key, value) {
        championMap[key] = Champion.fromJson(value, json['version'] ?? '');
      });
    }
    return ChampionModel(
      data: championMap,
      version: json['version'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class Champion {
  final String id;
  final String name;
  final String blurb;
  final String _version;
  Champion({
    required this.id,
    required this.name,
    required this.blurb,
    required String version,
  }) : _version = version;

  factory Champion.fromJson(Map<String, dynamic> json, String version) {
    return Champion(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      blurb: json['blurb'] ?? '',
      version: version,
    );
  }

  String get splashImageUrl =>
      'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/${id}_0.jpg';

  String get iconImageUrl =>
      'https://ddragon.leagueoflegends.com/cdn/$_version/img/champion/${id}.png';
}
