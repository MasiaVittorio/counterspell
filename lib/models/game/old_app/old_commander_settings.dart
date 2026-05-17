class OldCommanderSettings {
  //==============================
  // Values
  final bool lifelink;
  final bool damageDefendersLife;
  final bool infect;

  //==============================
  // Constructor
  const OldCommanderSettings({
    required this.lifelink,
    required this.damageDefendersLife,
    required this.infect,
  }) : assert(!(damageDefendersLife && infect));

  //==============================
  // default
  static const OldCommanderSettings defaultSettings = OldCommanderSettings(
    damageDefendersLife: true,
    infect: false,
    lifelink: false,
  );
  static const OldCommanderSettings off = OldCommanderSettings(
    damageDefendersLife: false,
    infect: false,
    lifelink: false,
  );

  //==============================
  // Methods
  OldCommanderSettings copyWith({
    bool? lifelink,
    bool? damageDefendersLife,
    bool? infect,
  }) => OldCommanderSettings(
    lifelink: lifelink ?? this.lifelink,
    damageDefendersLife: damageDefendersLife ?? this.damageDefendersLife,
    infect: infect ?? this.infect,
  );

  OldCommanderSettings toggleDamageDefendersLife() => copyWith(
    damageDefendersLife: !damageDefendersLife,
    infect: (!damageDefendersLife) ? false : null,
  );
  OldCommanderSettings toggleInfect() =>
      copyWith(infect: !infect, damageDefendersLife: (!infect) ? false : null);
  OldCommanderSettings toggleLifelink() => copyWith(lifelink: !lifelink);

  //==============================
  // Persistence
  Map<String, dynamic> toJson() => <String, dynamic>{
    'lifelink': lifelink,
    'damageDefendersLife': damageDefendersLife,
    'infect': infect,
  };

  static OldCommanderSettings fromJson(Map<String, dynamic> json) =>
      OldCommanderSettings(
        lifelink: json['lifelink'],
        damageDefendersLife: json['damageDefendersLife'],
        infect: json['infect'],
      );
}
