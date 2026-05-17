// ignore_for_file:  constant_identifier_names
import 'dart:convert';

import 'package:counter_spell/models/game/commander_damage_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MtgCard {
  /// width / height
  static const cardAspectRatio = 63 / 88;

  List<ColorScheme> colorSchemes(ThemeData appTheme) => [
    for (final color in colorIdentity)
      ColorScheme.fromSeed(
        seedColor: color.seed,
        brightness: appTheme.brightness,
        // dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
        contrastLevel: 0.1,
      ),
    if (colorIdentity.isEmpty)
      ColorScheme.fromSeed(
        seedColor: Colors.grey,
        brightness: appTheme.brightness,
        dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
      ),
  ];

  String? imageUrl({int faceIndex = 0, String uri = ImageUris.ARTCROP}) {
    late final ImageUris? uris;

    if (imageUris != null) {
      uris = imageUris!;
    } else if (cardFaces != null) {
      if (cardFaces!.length > faceIndex && faceIndex >= 0) {
        uris = cardFaces![faceIndex].imageUris;
      }
    }

    if (uris == null) return null;

    return uris.getUri(uri);
  }

  CommanderDamageSettings? get autoCommanderDamageSettings =>
      hasInfect || hasLifelink
      ? CommanderDamageSettings(
          properties: {
            if (hasLifelink) CommanderDamageProperty.lifelink,
            if (hasInfect) CommanderDamageProperty.infect,
            if (!hasInfect) CommanderDamageProperty.dealDamageToLifeTotal,
          },
          perpetual: true,
        )
      : null;

  bool get hasLifelink => keywords?.contains('Lifelink') ?? false;

  bool get hasInfect => keywords?.contains('Infect') ?? false;

  ///A unique ID for this card in Scryfall’s database.
  final String id;

  ///A unique ID for this card’s oracle identity. This value is consistent across reprinted card editions, and unique among different cards with the same name (tokens, Unstable variants, etc).
  final String? oracleId;

  ///The name of this card. If this card has multiple faces, this field will contain both names separated by ␣//␣.
  final String name;

  ///A link to this card object on Scryfall’s API.
  final String? uri;

  ///A link to this card’s permapage on Scryfall’s website.
  final String? scryfallUri;

  ///True if this card’s imagery is high resolution.
  final bool? highresImage;

  ///An object listing available imagery for this card. See the Card Imagery article for more information.
  ///CAN BE NULL OR MISSING
  final ImageUris? imageUris;

  ///The mana cost for this card. This value will be any empty string "" if the cost is absent. Remember that per the game rules, a missing mana cost and a mana cost of {0} are different values. Multi-faced cards will report this value in card faces.
  ///CAN BE NULL OR MISSING
  final String? manaCost;

  //The card’s converted mana cost. Note that some funny cards have fractional mana costs.
  final double cmc;

  ///This card’s colors, if the overall card has colors defined by the rules. Otherwise the colors will be on the card_faces objects, see below.
  ///CAN BE NULL OR MISSING
  final List<MtgColor>? colors;

  ///This card’s color identity.
  final List<MtgColor> colorIdentity;

  ///A link to this card’s rulings list on Scryfall’s API.
  final String? rulingsUri;

  ///A link to where you can begin paginating all re/prints for this card on Scryfall’s API.
  final String? printsSearchUri;

  ///The flavor text, if any.
  ///CAN BE NULL OR MISSING
  final String? flavorText;

  /// A unique identifier for the card artwork that remains consistent across reprints. Newly spoiled cards may not have this field yet.
  /// CAN BE NULL OR MISSING
  final String? illustrationId;

  /// The name of the illustrator of this card. Newly spoiled cards may not have this field yet.
  /// CAN BE NULL OR MISSING
  final String? artist;

  /// This card’s overall rank/popularity on EDHREC. Not all cards are ranked.
  /// CAN BE NULL OR MISSING
  final int? edhrecRank;

  /// An array of Card Face objects, if this card is multifaced.
  /// CAN BE NULL OR MISSING
  final List<CardFace>? cardFaces;

  /// An array of keywords found on this card.
  final List<String>? keywords;

  const MtgCard({
    required this.id,
    required this.oracleId,
    required this.name,
    required this.uri,
    required this.scryfallUri,
    required this.highresImage,
    required this.imageUris,
    required this.manaCost,
    required this.cmc,
    required this.colors,
    required this.colorIdentity,
    required this.rulingsUri,
    required this.printsSearchUri,
    required this.flavorText,
    required this.illustrationId,
    required this.artist,
    required this.edhrecRank,
    required this.cardFaces,
    required this.keywords,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'oracle_id': oracleId,
      'name': name,
      'uri': uri,
      'scryfall_uri': scryfallUri,
      'highres_image': highresImage,
      'image_uris': imageUris?.toMap(),
      'mana_cost': manaCost,
      'cmc': cmc,
      'colors': colors == null ? null : [for (final a in colors!) a.name],
      'color_identity': [for (final a in colorIdentity) a.name],
      'rulings_uri': rulingsUri,
      'prints_search_uri': printsSearchUri,
      'flavor_text': flavorText,
      'illustration_id': illustrationId,
      'artist': artist,
      'edhrec_rank': edhrecRank,
      'keywords': keywords,
      'card_faces': cardFaces == null
          ? null
          : List<dynamic>.from(cardFaces!.map((x) => x.toMap())),
    };
  }

  MtgCard deepCopy() => MtgCard.fromJson(toJson());

  factory MtgCard.fromMap(Map<String, dynamic> map) {
    return MtgCard(
      keywords: map['keywords'] == null
          ? null
          : [
              if (map['keywords'] case List list)
                for (final e in list)
                  if (e is String) e,
            ],
      id: map['id'],
      oracleId: map['oracle_id'],
      name: map['name'],
      uri: map['uri'],
      scryfallUri: map['scryfall_uri'],
      highresImage: map['highres_image'],
      imageUris: map['image_uris'] == null
          ? null
          : ImageUris.fromMap(map['image_uris']),
      manaCost: map['mana_cost'],
      cmc: switch (map['cmc']) {
        null => 0,
        num n => n.toDouble(),
        _ => 0,
      },
      colors: map['colors'] == null
          ? null
          : List<MtgColor>.from(map['colors'].map((x) => colorValues[x])),
      colorIdentity: List<MtgColor>.from(
        map['color_identity'].map((x) => colorValues[x]),
      ),
      rulingsUri: map['rulings_uri'],
      printsSearchUri: map['prints_search_uri'],
      flavorText: map['flavor_text'],
      illustrationId: map['illustration_id'],
      artist: map['artist'],
      edhrecRank: map['edhrec_rank'],
      cardFaces: map['card_faces'] == null
          ? null
          : List<CardFace>.from(
              map['card_faces'].map((x) => CardFace.fromMap(x)),
            ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MtgCard.fromJson(String source) =>
      MtgCard.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MtgCard(id: $id, oracleId: $oracleId, name: $name, uri: $uri, scryfallUri: $scryfallUri, highresImage: $highresImage, imageUris: $imageUris, manaCost: $manaCost, cmc: $cmc, colors: $colors, colorIdentity: $colorIdentity, rulingsUri: $rulingsUri, printsSearchUri: $printsSearchUri, flavorText: $flavorText, illustrationId: $illustrationId, artist: $artist, edhrecRank: $edhrecRank, cardFaces: $cardFaces, keywords: $keywords)';
  }

  @override
  bool operator ==(covariant MtgCard other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}

class CardFace {
  final String name;
  final String manaCost;
  final List<MtgColor>? colors;
  final String? artist;
  final String? illustrationId;
  final ImageUris? imageUris;
  final String? flavorText;

  const CardFace({
    required this.name,
    required this.manaCost,
    required this.colors,
    required this.artist,
    required this.illustrationId,
    required this.imageUris,
    required this.flavorText,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'mana_cost': manaCost,
      'colors': colors == null
          ? null
          : List<dynamic>.from(colors!.map((x) => x.name)),
      'artist': artist,
      'illustration_id': illustrationId,
      'image_uris': imageUris?.toMap(),
      'flavor_text': flavorText,
    };
  }

  factory CardFace.fromMap(Map<String, dynamic> map) {
    return CardFace(
      name: map['name']!,
      manaCost: map['mana_cost']!,
      colors: map['colors'] == null
          ? null
          : List<MtgColor>.from(map['colors'].map((x) => colorValues[x])),
      artist: map['artist'],
      illustrationId: map['illustration_id'],
      imageUris: map['image_uris'] == null
          ? null
          : ImageUris.fromMap(map['image_uris']),
      flavorText: map['flavor_text'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CardFace.fromJson(String source) =>
      CardFace.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CardFace(name: $name, manaCost: $manaCost, colors: $colors, artist: $artist, illustrationId: $illustrationId, imageUris: $imageUris, flavorText: $flavorText)';
  }

  @override
  bool operator ==(covariant CardFace other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.manaCost == manaCost &&
        listEquals(other.colors, colors) &&
        other.artist == artist &&
        other.illustrationId == illustrationId &&
        other.imageUris == imageUris &&
        other.flavorText == flavorText;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        manaCost.hashCode ^
        colors.hashCode ^
        artist.hashCode ^
        illustrationId.hashCode ^
        imageUris.hashCode ^
        flavorText.hashCode;
  }
}

enum MtgColor {
  W(Color.fromARGB(255, 255, 251, 176)),
  U(Color.fromARGB(255, 42, 102, 255)),
  B(Color.fromARGB(255, 59, 45, 83)),
  R(Color.fromARGB(255, 255, 38, 23)),
  G(Color.fromARGB(255, 41, 118, 44));

  const MtgColor(this.seed);

  final Color seed;
}

const colorValues = {
  'B': MtgColor.B,
  'G': MtgColor.G,
  'R': MtgColor.R,
  'U': MtgColor.U,
  'W': MtgColor.W,
};

class ImageUris {
  static const String SMALL = 'small';
  static const String NORMAL = 'normal';
  static const String LARGE = 'large';
  static const String PNG = 'png';
  static const String ARTCROP = 'art_crop';
  static const String BORDERCROP = 'border_crop';

  final String? small;
  final String? normal;
  final String? large;
  final String? png;
  final String? artCrop;
  final String? borderCrop;

  String? getUri(String whichOne) => whichOne == SMALL
      ? small
      : whichOne == NORMAL
      ? normal
      : whichOne == LARGE
      ? large
      : whichOne == PNG
      ? png
      : whichOne == ARTCROP
      ? artCrop
      : whichOne == BORDERCROP
      ? borderCrop
      : null;

  ImageUris({
    required this.small,
    required this.normal,
    required this.large,
    required this.png,
    required this.artCrop,
    required this.borderCrop,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    SMALL: small,
    NORMAL: normal,
    LARGE: large,
    PNG: png,
    ARTCROP: artCrop,
    BORDERCROP: borderCrop,
  };

  String toJson() => json.encode(toMap());

  factory ImageUris.fromJson(String source) =>
      ImageUris.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ImageUris(small: $small, normal: $normal, large: $large, png: $png, artCrop: $artCrop, borderCrop: $borderCrop)';
  }

  @override
  bool operator ==(covariant ImageUris other) {
    if (identical(this, other)) return true;

    return other.small == small &&
        other.normal == normal &&
        other.large == large &&
        other.png == png &&
        other.artCrop == artCrop &&
        other.borderCrop == borderCrop;
  }

  @override
  int get hashCode {
    return small.hashCode ^
        normal.hashCode ^
        large.hashCode ^
        png.hashCode ^
        artCrop.hashCode ^
        borderCrop.hashCode;
  }

  factory ImageUris.fromMap(Map<String, dynamic> map) {
    return ImageUris(
      small: map[SMALL],
      normal: map[NORMAL],
      large: map[LARGE],
      png: map[PNG],
      artCrop: map[ARTCROP],
      borderCrop: map[BORDERCROP],
    );
  }
}
