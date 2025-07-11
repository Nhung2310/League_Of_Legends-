import 'package:state_management/models/image_model.dart';

class PassiveModel {
  final String name;
  final String description;
  final ImageModel image;
  final String version;

  PassiveModel({
    required this.name,
    required this.description,
    required this.image,
    required this.version,
  });

  factory PassiveModel.fromJson(Map<String, dynamic> json, String version) {
    return PassiveModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: ImageModel.fromJson(json['image'] ?? {}), // Đổi thành ImageModel
      version: version,
    );
  }

  String get iconUrl =>
      'https://ddragon.leagueoflegends.com/cdn/$version/img/passive/${image.full}';
}
