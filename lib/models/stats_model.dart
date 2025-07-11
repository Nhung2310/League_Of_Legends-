class StatsModel {
  final num? hp;
  final num? hpperlevel;
  final num? mp;
  final num? mpperlevel;
  final num? movespeed;
  final num? armor;
  final num? armorperlevel;
  final num? spellblock;
  final num? spellblockperlevel;
  final num? attackrange;
  final num? hpregen;
  final num? hpregenperlevel;
  final num? mpregen;
  final num? mpregenperlevel;
  final num? crit;
  final num? critperlevel;
  final num? attackdamage;
  final num? attackdamageperlevel;
  final num? attackspeedperlevel;
  final num? attackspped;

  StatsModel({
    this.hp,
    this.hpperlevel,
    this.mp,
    this.mpperlevel,
    this.movespeed,
    this.armor,
    this.armorperlevel,
    this.spellblock,
    this.spellblockperlevel,
    this.attackrange,
    this.hpregen,
    this.hpregenperlevel,
    this.mpregen,
    this.mpregenperlevel,
    this.crit,
    this.critperlevel,
    this.attackdamage,
    this.attackdamageperlevel,
    this.attackspeedperlevel,
    this.attackspped,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      hp: json['hp'] as num?,
      hpperlevel: json['hpperlevel'] as num?,
      mp: json['mp'] as num?,
      mpperlevel: json['mpregenperlevel'] as num?,
      movespeed: json['movespeed'] as num?,
      armor: json['armor'] as num?,
      armorperlevel: json['armorperlevel'] as num?,
      spellblock: json['spellblock'] as num?,
      spellblockperlevel: json['spellblockperlevel'] as num?,
      attackrange: json['attackrange'] as num?,
      hpregen: json['hpregen'] as num?,
      hpregenperlevel: json['hpregenperlevel'] as num?,
      mpregen: json['mpregen'] as num?,
      mpregenperlevel: json['mpregenperlevel'] as num?,
      crit: json['crit'] as num?,
      critperlevel: json['critperlevel'] as num?,
      attackdamage: json['attackdamage'] as num?,
      attackdamageperlevel: json['attackdamageperlevel'] as num?,
      attackspeedperlevel: json['attackspeedperlevel'] as num?,
      attackspped: json['attackspeed'] as num?,
    );
  }
}
