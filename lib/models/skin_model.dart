class SkinModel {
  final String id;
  final int num;
  final String name;
  final bool chromas;

  SkinModel({
    required this.id,
    required this.num,
    required this.name,
    required this.chromas,
  });

  factory SkinModel.fromJson(Map<String, dynamic> json) {
    return SkinModel(
      id: json['id'] as String? ?? '',
      num: json['num'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      chromas: json['chromas'] as bool? ?? false,
    );
  }
}
