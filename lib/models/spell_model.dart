import 'package:state_management/models/level_tip.dart';
import 'package:state_management/models/image_model.dart';

class SpellModel {
  final List<List<num?>?>? effect;

  final List<String?>? effectBurn;

  final String id;
  final String name;
  final String description;
  final String tooltip;
  final int maxrank;
  final List<int> cooldown;
  final String cooldownBurn;
  final List<int> cost;
  final String costBurn;
  final String costType;
  final String maxammo;
  final List<int> range;
  final String rangeBurn;
  final Map<String, dynamic> datavalues;
  final ImageModel image;
  final String resource;
  final String version;

  SpellModel({
    required this.id,
    required this.name,
    required this.description,
    required this.tooltip,
    required this.maxrank,
    required this.cooldown,
    required this.cooldownBurn,
    required this.cost,
    required this.costBurn,
    required this.datavalues,
    this.effect,
    this.effectBurn,
    required this.costType,
    required this.maxammo,
    required this.range,
    required this.rangeBurn,
    required this.image,
    required this.resource,
    required this.version,
  });
  String get iconUrl {
    const String baseUrl = 'https://ddragon.leagueoflegends.com/cdn';
    return '$baseUrl/$version/img/spell/${image.full}';
  }

  factory SpellModel.fromJson(Map<String, dynamic> json, String version) {
    return SpellModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      tooltip: json['tooltip'] as String,
      maxrank: json['maxrank'] as int,
      cooldown: (json['cooldown'] as List).cast<int>(),
      cooldownBurn: json['cooldownBurn'] as String,
      cost: (json['cost'] as List).cast<int>(),
      costBurn: json['costBurn'] as String,
      datavalues: json['datavalues'] as Map<String, dynamic>,

      effect: (json['effect'] as List?)?.map((e) {
        if (e == null) return null;
        return (e as List).cast<num?>();
      }).toList(),
      effectBurn: (json['effectBurn'] as List?)
          ?.map((e) => e as String?)
          .toList(),
      costType: json['costType'] as String,
      maxammo: json['maxammo'] as String,
      range: (json['range'] as List).cast<int>(),
      rangeBurn: json['rangeBurn'] as String,
      image: ImageModel.fromJson(json['image'] as Map<String, dynamic>),
      resource: json['resource'] as String,
      version: version,
    );
  }
}
