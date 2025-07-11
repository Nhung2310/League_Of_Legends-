class InfoModel {
  final num? attack;
  final num? defense;
  final num? magic;
  final num? difficulty;

  InfoModel({this.attack, this.defense, this.magic, this.difficulty});

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      attack: json['attack'] as num?,
      defense: json['defense'] as num?,
      magic: json['magic'] as num?,
      difficulty: json['difficulty'] as num?,
    );
  }
}
