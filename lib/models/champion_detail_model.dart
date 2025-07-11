import 'package:state_management/models/info_model.dart';
import 'package:state_management/models/skin_model.dart';
import 'package:state_management/models/image_model.dart';
import 'package:state_management/models/spell_model.dart';
import 'package:state_management/models/stats_model.dart';
import 'package:state_management/models/passive_model.dart';

class ChampionDetailModel {
  final String id;
  final String key;
  final String name;
  final String title;
  final String lore;
  final String blurb;
  final String partype;
  final ImageModel image;
  final List<SkinModel> skins;
  final List<String> tags;
  final List<String> allytips;
  final List<String> enemytips;
  final InfoModel info;
  final StatsModel stats;
  final List<SpellModel> spells;
  final PassiveModel passive;
  final String version;

  ChampionDetailModel({
    required this.id,
    required this.key,
    required this.name,
    required this.title,
    required this.lore,
    required this.blurb,
    required this.partype,
    required this.image,
    required this.skins,
    required this.tags,
    required this.allytips,
    required this.enemytips,
    required this.info,
    required this.stats,
    required this.spells,
    required this.passive,
    required this.version,
  });

  factory ChampionDetailModel.fromJson(
    Map<String, dynamic> json,
    String version,
  ) {
    return ChampionDetailModel(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      lore: json['lore'] ?? '',
      blurb: json['blurb'] ?? '',
      partype: json['partype'] ?? '',
      image: ImageModel.fromJson(json['image'] ?? {}),
      skins:
          (json['skins'] as List?)
              ?.map((s) => SkinModel.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      allytips:
          (json['allytips'] as List?)?.map((e) => e.toString()).toList() ?? [],
      enemytips:
          (json['enemytips'] as List?)?.map((e) => e.toString()).toList() ?? [],
      info: InfoModel.fromJson(json['info'] ?? {}),
      stats: StatsModel.fromJson(json['stats'] ?? {}),
      spells:
          (json['spells'] as List?)
              ?.map(
                (s) => SpellModel.fromJson(s as Map<String, dynamic>, version),
              )
              .toList() ??
          [],
      passive: PassiveModel.fromJson(json['passive'] ?? {}, version),
      version: version,
    );
  }

  String get splashImageUrl =>
      'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/${id}_0.jpg';
  String get loadingImageUrl =>
      'https://ddragon.leagueoflegends.com/cdn/img/champion/loading/${id}_0.jpg';
  String get squareImageUrl =>
      'https://ddragon.leagueoflegends.com/cdn/$version/img/champion/${image.full}';
}
