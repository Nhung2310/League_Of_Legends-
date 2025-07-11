class LevelTip {
  final List<String> label;
  final List<String> effect;

  LevelTip({required this.label, required this.effect});

  factory LevelTip.fromJson(Map<String, dynamic> json) {
    return LevelTip(
      label: (json['label'] as List?)?.map((e) => e.toString()).toList() ?? [],
      effect:
          (json['effect'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
