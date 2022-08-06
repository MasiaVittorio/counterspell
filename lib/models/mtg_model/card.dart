// To parse this JSON data, do
//
//     final db = dbFromJson(jsonString);

// import 'dart:convert';

// List<MtgCard> dbFromJson(String str) {
//     final jsonData = json.decode(str);
// 
//     if(!(jsonData is List<Map>))
//       return <MtgCard>[];
// 
//     return <MtgCard> [
//       for(final js in jsonData)
//         MtgCard.fromJson(js),
//     ];
// }

// String dbToJson(List<MtgCard> data) {
//     final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
//     return json.encode(dyn);
// }

// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
// import 'package:scrywalker/models/boolean_stuff/boolean_model.dart';
import 'color_data.dart';
// import 'package:scrywalker/themes/keyrune.dart';
// import 'package:scrywalker/themes/mana_icons.dart';
// import 'package:scrywalker/themes/material_community_icons.dart';


class MtgCard {

  static const cardAspectRatio = 63/88;
  //width / height

    //=========================
    // Getters =============
    //===================

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return other.id == id;
  }

  String? imageUrl({int faceIndex = 0, String uri = ImageUris.ARTCROP}) {
    late final ImageUris? uris;
    
    if(imageUris != null){
      uris = imageUris!;
    } else if(cardFaces != null){
      if(cardFaces!.length > faceIndex && faceIndex >= 0){
        uris = cardFaces![faceIndex].imageUris;
      }
    }

    if(uris == null) return null;

    return uris.getUri(uri);
  }

  bool get isCreature => typeLine.contains("Creature");
  bool get isEnchantment => typeLine.contains("Enchantment");
  bool get isSorcery => typeLine.contains("Sorcery");
  bool get isInstant => typeLine.contains("Sorcery");
  bool get isArtifact => typeLine.contains("Artifact");
  bool isType(String type) => typeLine.contains(type);

  bool isFaceType(String type, [int face = 0]) => isFaced
    ? (cardFaces![face].typeLine?.contains(type) ?? false) 
    : typeLine.contains(type);

  static const List<String> hybridSymbolsColored = [
    "{W/U}",
    "{W/B}",
    "{B/R}",
    "{B/G}",
    "{U/B}",
    "{U/R}",
    "{R/G}",
    "{R/W}",
    "{G/W}",
    "{G/U}",
  ];  

  bool get isFaced => cardFaces != null;

  String getManaCost([int face = 0]){
    if(isFaced) return cardFaces![face].manaCost;
    return manaCost ?? "";
  }

  bool isHybrid([int face = 0]) {
    for(final s in hybridSymbolsColored) {
      if(getManaCost(face).contains(s)) {
        return true;
    }
      }
    return false;
  }

  List<Color?> bkgColors([int face = 0]) {
    final List<MtgColor> clrs = colorIdentity;
    final int len = clrs.length;

    switch (len) {
      case 0:
        return [Colors.grey];
      case 1:
        return [MTG_TO_COLORS_BKG[clrs[0]]];
      case 2:
        if(isHybrid(face)) {
          return [
          MTG_TO_COLORS_BKG[clrs[0]],
          MTG_TO_COLORS_BKG[clrs[1]],
        ];
        }
        break;
     default:
    }

    return [GOLD_MULTICOLOR];
  } 

  Color? singleBkgColor([int face = 0]){
     final cc = bkgColors(face);
     
     if(cc.length > 1) return GOLD_MULTICOLOR;
     
     return cc[0];
  }

  //========================
  // Values =============
  //==================
  CardObject object; ///A content type for this object, always card.

  String id; ///A unique ID for this card in Scryfall’s database.

  String oracleId; ///A unique ID for this card’s oracle identity. This value is consistent across reprinted card editions, and unique among different cards with the same name (tokens, Unstable variants, etc).

  //CAN BE NULL OR MISSING
  List<int>? multiverseIds; ///This card’s multiverse IDs on Gatherer, if any, as an array of integers. Note that Scryfall includes many promo cards, tokens, and other esoteric objects that do not have these identifiers.

  //CAN BE NULL OR MISSING
  int? mtgoId; ///This card’s Magic Online ID (also known as the Catalog ID), if any. A large percentage of cards are not available on Magic Online and do not have this ID.

  //CAN BE NULL OR MISSING
  int? mtgoFoilId; ///This card’s foil Magic Online ID (also known as the Catalog ID), if any. A large percentage of cards are not available on Magic Online and do not have this ID.

  //CAN BE NULL OR MISSING
  int? tcgplayerId; ///This card’s ID on TCGplayer’s API, also known as the productId.

  String name; ///The name of this card. If this card has multiple faces, this field will contain both names separated by ␣//␣.

  String lang; ///A language code for this printing.

  String? releasedAt; ///The date this card was first released.

  String? uri; ///A link to this card object on Scryfall’s API.

  String? scryfallUri; ///A link to this card’s permapage on Scryfall’s website.

  String layout; ///A code for this card’s layout.

  bool? highresImage; ///True if this card’s imagery is high resolution.

  //CAN BE NULL OR MISSING
  ImageUris? imageUris; ///An object listing available imagery for this card. See the Card Imagery article for more information.

  //CAN BE NULL OR MISSING
  String? manaCost; ///The mana cost for this card. This value will be any empty string "" if the cost is absent. Remember that per the game rules, a missing mana cost and a mana cost of {0} are different values. Multi-faced cards will report this value in card faces.

  double cmc;  //The card’s converted mana cost. Note that some funny cards have fractional mana costs.

  String typeLine; ///The type line of this card.

  //CAN BE NULL OR MISSING
  String? oracleText; ///The Oracle text for this card, if any.

  //CAN BE NULL OR MISSING
  List<MtgColor>? colors; ///This card’s colors, if the overall card has colors defined by the rules. Otherwise the colors will be on the card_faces objects, see below.

  List<MtgColor> colorIdentity; ///This card’s color identity.

  Map<String,String> legalities; ///An object describing the legality of this card across play formats. Possible legalities are legal, not_legal, restricted, and banned.

  List<Game> games; ///A list of games that this card print is available in, paper, arena, and/or mtgo.

  bool? reserved; ///True if this card is on the Reserved List.

  bool? foil; ///True if this printing exists in a foil version.

  bool? nonfoil; ///True if this printing exists in a nonfoil version.

  bool? oversized; ///True if this card is oversized.

  bool? promo; ///True if this card is a promotional print.

  bool? reprint; ///True if this card is a reprint.

  String? dbSet;//This card’s set code.

  String? setName; ///This card’s full set name.

  String? setUri; ///A link to this card’s set object on Scryfall’s API.

  String? setSearchUri; ///A link to where you can begin paginating this card’s set on the Scryfall API.

  String? scryfallSetUri; ///A link to this card’s set on Scryfall’s website.

  String? rulingsUri; ///A link to this card’s rulings list on Scryfall’s API.

  String? printsSearchUri; ///A link to where you can begin paginating all re/prints for this card on Scryfall’s API.

  String? collectorNumber; ///This card’s collector number. Note that collector numbers can contain non-numeric characters, such as letters or ★.

  bool? digital; ///True if this is a digital card on Magic Online.

  Rarity rarity; ///This card’s rarity. One of common, uncommon, rare, or mythic.

  //CAN BE NULL OR MISSING
  String? flavorText; ///The flavor text, if any.

  //CAN BE NULL OR MISSING
  String? illustrationId; ///A unique identifier for the card artwork that remains consistent across reprints. Newly spoiled cards may not have this field yet.

  //CAN BE NULL OR MISSING
  String? artist; ///The name of the illustrator of this card. Newly spoiled cards may not have this field yet.

  BorderColor borderColor; ///This card’s border color: black, borderless, gold, silver, or white.

  String? frame; ///This card’s frame layout.

  // FrameEffect? frameEffect; ///This card’s frame effect, if any.

  bool? fullArt; ///True if this card’s artwork is larger than normal.

  bool? storySpotlight; ///True if this card is a Story Spotlight.

  //CAN BE NULL OR MISSING
  int? edhrecRank; ///This card’s overall rank/popularity on EDHREC. Not all cards are ranked.

  RelatedUris relatedUris; ///An object providing URIs to this card’s listing on other Magic: The Gathering online resources.

  //CAN BE NULL OR MISSING
  String? power; ///This card’s power, if any. Note that some cards have powers that are not numeric, such as *.

  //CAN BE NULL OR MISSING
  String? toughness; ///This card’s toughness, if any. Note that some cards have toughnesses that are not numeric, such as *.

  //CAN BE NULL OR MISSING
  int? arenaId; /// This card’s Arena ID, if any. A large percentage of cards are not available on Arena and do not have this ID.

  //CAN BE NULL OR MISSING
  Watermark? watermark; ///This card’s watermark, if any.
  
  //CAN BE NULL OR MISSING
  List<MtgRelatedCard>? allParts; ///If this card is closely related to other cards, this property will be an array with Related Card Objects.

  //CAN BE NULL OR MISSING
  List<CardFace>? cardFaces; ///An array of Card Face objects, if this card is multifaced.

  //CAN BE NULL OR MISSING
  String? lifeModifier; ///This card’s life modifier, if it is Vanguard card. This value will contain a delta, such as +2.

  //CAN BE NULL OR MISSING
  String? handModifier; ///This card’s hand modifier, if it is Vanguard card. This value will contain a delta, such as -1.

  //CAN BE NULL OR MISSING
  String? loyalty; ///This loyalty if any. Note that some cards have loyalties that are not numeric, such as X.

  //CAN BE NULL OR MISSING
  List<MtgColor>? colorIndicator; ///The colors in this card’s color indicator, if any. A null value for this field indicates the card does not have one.

  //CAN BE NULL OR MISSING
  MtgPrices? prices;

  //CAN BE NULL OR MISSING
  MtgPurchaseUris? purchaseUris;

  MtgCard({
    required this.object, 
    required this.id, 
    required this.oracleId, 
    this.multiverseIds, 
    this.mtgoId, 
    this.mtgoFoilId, 
    this.tcgplayerId, 
    required this.name,
    required this.lang,
    this.releasedAt,
    this.uri,
    this.scryfallUri,
    required this.layout,
    this.highresImage,
    this.imageUris,
    this.manaCost,
    required this.cmc,
    required this.typeLine,
    this.oracleText,
    this.colors,
    required this.colorIdentity,
    required this.legalities,
    required this.games,
    this.reserved,
    this.foil,
    this.nonfoil,
    this.oversized,
    this.promo,
    this.reprint,
    this.dbSet,
    this.setName,
    this.setUri,
    this.setSearchUri, 
    this.scryfallSetUri,
    this.rulingsUri, 
    this.printsSearchUri,
    this.collectorNumber,
    this.digital,
    required this.rarity,
    this.flavorText,
    this.illustrationId,
    this.artist,
    required this.borderColor,
    this.frame,
    // this.frameEffect,
    this.fullArt,
    this.storySpotlight,
    this.edhrecRank,
    required this.relatedUris,
    this.power,
    this.toughness,
    this.arenaId, 
    this.watermark,
    this.allParts, 
    this.cardFaces, 
    this.lifeModifier,
    this.handModifier,
    this.loyalty,
    this.colorIndicator,
    this.prices,
    this.purchaseUris,
  });

  factory MtgCard.fromJson(Map<String, dynamic> json) => MtgCard(
    object: dbObjectValues.map[json["object"]]!,
    id: json["id"],
    oracleId: json["oracle_id"],
    multiverseIds: json["multiverse_ids"] == null 
      ? null 
      : <int>[for(final v in json["multiverse_ids"]) v as int],
    mtgoId: json["mtgo_id"],
    mtgoFoilId: json["mtgo_foil_id"],
    tcgplayerId: json["tcgplayer_id"],
    name: json["name"],
    lang: json["lang"]!,
    releasedAt: json["released_at"],
    uri: json["uri"],
    scryfallUri: json["scryfall_uri"],
    layout: json["layout"] ?? "",
    highresImage: json["highres_image"],
    imageUris: json["image_uris"] == null ? null : ImageUris.fromJson(json["image_uris"]),
    manaCost: json["mana_cost"],
    cmc: json["cmc"].toDouble(),
    typeLine: json["type_line"],
    oracleText: json["oracle_text"],
    colors: json["colors"] == null ? null : List<MtgColor>.from(json["colors"].map((x) => colorValues.map[x])),
    colorIdentity: List<MtgColor>.from(json["color_identity"].map((x) => colorValues.map[x])),
    legalities: <String,String>{
      for(final entry in ((json["legalities"] ?? <String,String>{}) as Map).entries)
        (entry.key as String?) ?? '': (entry.value as String?) ?? '', 
    },
    games: List<Game>.from(json["games"].map((x) => gameValues.map[x])),
    reserved: json["reserved"],
    foil: json["foil"],
    nonfoil: json["nonfoil"],
    oversized: json["oversized"],
    promo: json["promo"],
    reprint: json["reprint"],
    dbSet: json["set"],
    setName: json["set_name"],
    setUri: json["set_uri"],
    setSearchUri: json["set_search_uri"],
    scryfallSetUri: json["scryfall_set_uri"],
    rulingsUri: json["rulings_uri"],
    printsSearchUri: json["prints_search_uri"],
    collectorNumber: json["collector_number"],
    digital: json["digital"],
    rarity: rarityValues.map[json["rarity"]]!,
    flavorText: json["flavor_text"],
    illustrationId: json["illustration_id"],
    artist: json["artist"],
    borderColor: borderColorValues.map[json["border_color"]]!,
    frame: json["frame"],
    // frameEffect: frameEffectValues.map[json["frame_effect"]],
    fullArt: json["full_art"],
    storySpotlight: json["story_spotlight"],
    edhrecRank: json["edhrec_rank"],
    relatedUris: RelatedUris.fromJson(json["related_uris"]),
    power: json["power"],
    toughness: json["toughness"],
    arenaId: json["arena_id"],
    watermark: json["watermark"] == null ? null : watermarkValues.map[json["watermark"]],
    allParts: json["all_parts"] == null ? null : List<MtgRelatedCard>.from(json["all_parts"].map((x) => MtgRelatedCard.fromJson(x))),
    cardFaces: json["card_faces"] == null ? null : List<CardFace>.from(json["card_faces"].map((x) => CardFace.fromJson(x))),
    lifeModifier: json["life_modifier"],
    handModifier: json["hand_modifier"],
    loyalty: json["loyalty"],
    colorIndicator: json["color_indicator"] == null ? null : List<MtgColor>.from(json["color_indicator"].map((x) => colorValues.map[x])),
    prices: json["prices"] == null ? null : MtgPrices.fromJson(json["prices"]),
    purchaseUris: json["purchase_uris"] == null ? null : MtgPurchaseUris.fromJson(json["purchase_uris"]),
  );

  Map<String, dynamic> toJson() => {
    "object": dbObjectValues.reverse[object],
    "id": id,
    "oracle_id": oracleId, 
    "multiverse_ids": multiverseIds,
    "mtgo_id": mtgoId,
    "mtgo_foil_id": mtgoFoilId,
    "tcgplayer_id": tcgplayerId,
    "name": name,
    "lang": lang,
    "released_at": releasedAt,
    "uri": uri,
    "scryfall_uri": scryfallUri,
    "layout": layout,
    "highres_image": highresImage,
    "image_uris": imageUris?.toJson(),
    "mana_cost": manaCost,
    "cmc": cmc,
    "type_line": typeLine,
    "oracle_text": oracleText,
    "colors": colors == null ? null : List<dynamic>.from(colors!.map((x) => colorValues.reverse[x])),
    "color_identity": List<dynamic>.from(colorIdentity.map((x) => colorValues.reverse[x])),
    "legalities": legalities,
    "games": List<dynamic>.from(games.map((x) => gameValues.reverse[x])),
    "reserved": reserved,
    "foil": foil,
    "nonfoil": nonfoil,
    "oversized": oversized,
    "promo": promo,
    "reprint": reprint,
    "set": dbSet,
    "set_name": setName,
    "set_uri": setUri,
    "set_search_uri": setSearchUri,
    "scryfall_set_uri": scryfallSetUri,
    "rulings_uri": rulingsUri,
    "prints_search_uri": printsSearchUri,
    "collector_number": collectorNumber,
    "digital": digital,
    "rarity": rarityValues.reverse[rarity],
    "flavor_text": flavorText,
    "illustration_id": illustrationId,
    "artist": artist,
    "border_color": borderColorValues.reverse[borderColor],
    "frame": frame,
    // "frame_effect": frameEffectValues.reverse[frameEffect!],
    "full_art": fullArt,
    "story_spotlight": storySpotlight,
    "edhrec_rank": edhrecRank,
    "related_uris": relatedUris.toJson(),
    "power": power,
    "toughness": toughness,
    "arena_id": arenaId,
    "watermark": watermark == null ? null : watermarkValues.reverse[watermark!],
    "all_parts": allParts == null ? null : List<dynamic>.from(allParts!.map((x) => x.toJson())),
    "card_faces": cardFaces == null ? null : List<dynamic>.from(cardFaces!.map((x) => x.toJson())),
    "life_modifier": lifeModifier,
    "hand_modifier": handModifier,
    "loyalty": loyalty,
    "color_indicator": colorIndicator == null ? null : List<dynamic>.from(colorIndicator!.map((x) => colorValues.reverse[x])),
    "prices": prices?.toJson(),
    "purchase_uris": purchaseUris?.toJson(),
  };
}

class MtgPrices {
  String? usd;
  String? usdFoil;
  String? eur;
  String? tix;
  MtgPrices({
    this.usd,
    this.usdFoil,
    this.eur,
    this.tix,
  });
  factory MtgPrices.fromJson(Map<String,dynamic> json) => MtgPrices(
    usd: json["usd"],
    usdFoil: json["usd_foil"],
    eur: json["eur"],
    tix: json["tix"],
  );
  Map<String, dynamic> toJson() => {
    "usd": usd,
    "usd_foil": usdFoil,
    "eur": eur,
    "tix": tix,
  };
}
class MtgPurchaseUris {
  String? tcgplayer;
  String? cardmarket;
  String? cardhoarder;
  MtgPurchaseUris({
    this.tcgplayer,
    this.cardmarket,
    this.cardhoarder,
  });
  factory MtgPurchaseUris.fromJson(Map<String,dynamic> json) => MtgPurchaseUris(
    tcgplayer: json["tcgplayer"],
    cardmarket: json["cardmarket"],
    cardhoarder: json["cardhoarder"],
  );
  Map<String, dynamic> toJson() => {
    "tcgplayer": tcgplayer,
    "cardmarket": cardmarket,
    "cardhoarder": cardhoarder,
  };
}

class MtgRelatedCard {
  AllPartObject object;
  String id;
  Component component;
  String name;
  String typeLine;
  String uri;

  MtgRelatedCard({
    required this.object,
    required this.id,
    required this.component,
    required this.name,
    required this.typeLine,
    required this.uri,
  });

  factory MtgRelatedCard.fromJson(Map<String, dynamic> json) => MtgRelatedCard(
    object: allPartObjectValues.map[json["object"]]!,
    id: json["id"],
    component: componentValues.map[json["component"]]!,
    name: json["name"],
    typeLine: json["type_line"],
    uri: json["uri"],
  );

  Map<String, dynamic> toJson() => {
    "object": allPartObjectValues.reverse[object],
    "id": id,
    "component": componentValues.reverse[component],
    "name": name,
    "type_line": typeLine,
    "uri": uri,
  };
}

enum Component { COMBO_PIECE, TOKEN, MELD_PART, MELD_RESULT }

final componentValues = EnumValues({
    "combo_piece": Component.COMBO_PIECE,
    "meld_part": Component.MELD_PART,
    "meld_result": Component.MELD_RESULT,
    "token": Component.TOKEN
});

enum AllPartObject { RELATED_CARD }

final allPartObjectValues = EnumValues({
    "related_card": AllPartObject.RELATED_CARD
});

enum BorderColor { WHITE, BLACK, SILVER, GOLD, BORDERLESS }

final borderColorValues = EnumValues({
    "black": BorderColor.BLACK,
    "borderless": BorderColor.BORDERLESS,
    "gold": BorderColor.GOLD,
    "silver": BorderColor.SILVER,
    "white": BorderColor.WHITE
});

class CardFace {
    CardFaceObject object;
    String name;
    String manaCost;
    String? typeLine;
    String? oracleText;
    List<MtgColor>? colors;
    String? power;
    String? toughness;
    String? artist;
    String? illustrationId;
    ImageUris? imageUris;
    Watermark? watermark;
    List<MtgColor>? colorIndicator;
    String? flavorText;
    String? loyalty;

    CardFace({
        required this.object,
        required this.name,
        required this.manaCost,
        this.typeLine,
        this.oracleText,
        this.colors,
        this.power,
        this.toughness,
        this.artist,
        this.illustrationId,
        this.imageUris,
        this.watermark,
        this.colorIndicator,
        this.flavorText,
        this.loyalty,
    });

    factory CardFace.fromJson(Map<String, dynamic> json) => CardFace(
        object: cardFaceObjectValues.map[json["object"]]!,
        name: json["name"]!,
        manaCost: json["mana_cost"]!,
        typeLine: json["type_line"],
        oracleText: json["oracle_text"],
        colors: json["colors"] == null ? null : List<MtgColor>.from(json["colors"].map((x) => colorValues.map[x])),
        power: json["power"],
        toughness: json["toughness"],
        artist: json["artist"],
        illustrationId: json["illustration_id"],
        imageUris: json["image_uris"] == null ? null : ImageUris.fromJson(json["image_uris"]),
        watermark: json["watermark"] == null ? null : watermarkValues.map[json["watermark"]],
        colorIndicator: json["color_indicator"] == null ? null : List<MtgColor>.from(json["color_indicator"].map((x) => colorValues.map[x])),
        flavorText: json["flavor_text"],
        loyalty: json["loyalty"],
    );

    Map<String, dynamic> toJson() => {
        "object": cardFaceObjectValues.reverse[object],
        "name": name,
        "mana_cost": manaCost,
        "type_line": typeLine,
        "oracle_text": oracleText,
        "colors": colors == null ? null : List<dynamic>.from(colors!.map((x) => colorValues.reverse[x])),
        "power": power,
        "toughness": toughness,
        "artist": artist,
        "illustration_id": illustrationId,
        "image_uris": imageUris?.toJson(),
        "watermark": watermark == null ? null : watermarkValues.reverse[watermark!],
        "color_indicator": colorIndicator == null ? null : List<dynamic>.from(colorIndicator!.map((x) => colorValues.reverse[x])),
        "flavor_text": flavorText,
        "loyalty": loyalty,
    };
}

enum MtgColor { W, U, B, R, G, }

final colorValues = EnumValues({
    "W": MtgColor.W,
    "U": MtgColor.U,
    "B": MtgColor.B,
    "R": MtgColor.R,
    "G": MtgColor.G,
});
final colorValuesCool = EnumValues({
    "White": MtgColor.W,
    "Blue": MtgColor.U,
    "Black": MtgColor.B,
    "Red": MtgColor.R,
    "Green": MtgColor.G,
});

class ImageUris {

    static const String SMALL = "small";
    static const String NORMAL = "normal";
    static const String LARGE = "large";
    static const String PNG = "png";
    static const String ARTCROP = "art_crop";
    static const String BORDERCROP = "border_crop";

    String? small;
    String? normal;
    String? large;
    String? png;
    String? artCrop;
    String? borderCrop;

    String? getUri(String whichOne) => 
      whichOne == SMALL ? small : 
      whichOne == NORMAL ? normal : 
      whichOne == LARGE ? large : 
      whichOne == PNG ? png : 
      whichOne == ARTCROP ? artCrop : 
      whichOne == BORDERCROP ? borderCrop : 
      null;

    ImageUris({
        this.small,
        this.normal,
        this.large,
        this.png,
        this.artCrop,
        this.borderCrop,
    });

    factory ImageUris.fromJson(Map<String, dynamic> json) => ImageUris(
      small: json[SMALL],
      normal: json[NORMAL],
      large: json[LARGE],
      png: json[PNG],
      artCrop: json[ARTCROP],
      borderCrop: json[BORDERCROP],
    );

    Map<String, dynamic> toJson() => {
      SMALL: small,
      NORMAL: normal,
      LARGE: large,
      PNG: png,
      ARTCROP: artCrop,
      BORDERCROP: borderCrop,
    };
}

enum CardFaceObject { CARD_FACE }

final cardFaceObjectValues = EnumValues({
    "card_face": CardFaceObject.CARD_FACE
});

enum Watermark { 
  SIMIC, 
  ORDEROFTHEWIDGET, 
  ABZAN, 
  SET, 
  BOROS, 
  SELESNYA, 
  MIRRAN, 
  GOBLINEXPLOSIONEERS, 
  IZZET, 
  AZORIUS, 
  PLANESWALKER, 
  ORZHOV, 
  SULTAI, 
  PHYREXIAN, 
  JESKAI, 
  RAKDOS, 
  HEROSPATH, 
  DIMIR, 
  KOLAGHAN, 
  GRUUL, 
  SILUMGAR, 
  OJUTAI, 
  CROSSBREEDLABS, 
  CONSPIRACY, 
  LEAGUEOFDASTARDLYDOOM, 
  AGENTSOFSNEAK, 
  GOLGARI, 
  MARDU, 
  DROMOKA, 
  ATARKA, 
  TEMUR, 
  FLAVOR, 
  NERF, 
  TRANSFORMERS,
}

final watermarkValues = EnumValues({
    "abzan": Watermark.ABZAN,
    "agentsofsneak": Watermark.AGENTSOFSNEAK,
    "atarka": Watermark.ATARKA,
    "azorius": Watermark.AZORIUS,
    "boros": Watermark.BOROS,
    "conspiracy": Watermark.CONSPIRACY,
    "crossbreedlabs": Watermark.CROSSBREEDLABS,
    "dimir": Watermark.DIMIR,
    "dromoka": Watermark.DROMOKA,
    "flavor": Watermark.FLAVOR,
    "goblinexplosioneers": Watermark.GOBLINEXPLOSIONEERS,
    "golgari": Watermark.GOLGARI,
    "gruul": Watermark.GRUUL,
    "herospath": Watermark.HEROSPATH,
    "izzet": Watermark.IZZET,
    "jeskai": Watermark.JESKAI,
    "kolaghan": Watermark.KOLAGHAN,
    "leagueofdastardlydoom": Watermark.LEAGUEOFDASTARDLYDOOM,
    "mardu": Watermark.MARDU,
    "mirran": Watermark.MIRRAN,
    "nerf": Watermark.NERF,
    "ojutai": Watermark.OJUTAI,
    "orderofthewidget": Watermark.ORDEROFTHEWIDGET,
    "orzhov": Watermark.ORZHOV,
    "phyrexian": Watermark.PHYREXIAN,
    "planeswalker": Watermark.PLANESWALKER,
    "rakdos": Watermark.RAKDOS,
    "selesnya": Watermark.SELESNYA,
    "set": Watermark.SET,
    "silumgar": Watermark.SILUMGAR,
    "simic": Watermark.SIMIC,
    "sultai": Watermark.SULTAI,
    "temur": Watermark.TEMUR,
    "transformers": Watermark.TRANSFORMERS
});

enum FrameEffect { EMPTY, NYXTOUCHED, DEVOID, MOONELDRAZIDFC, TOMBSTONE, SUNMOONDFC, DRAFT, COMPASSLANDDFC, COLORSHIFTED, MIRACLE, ORIGINPWDFC }

final frameEffectValues = EnumValues({
    "colorshifted": FrameEffect.COLORSHIFTED,
    "compasslanddfc": FrameEffect.COMPASSLANDDFC,
    "devoid": FrameEffect.DEVOID,
    "draft": FrameEffect.DRAFT,
    "": FrameEffect.EMPTY,
    "miracle": FrameEffect.MIRACLE,
    "mooneldrazidfc": FrameEffect.MOONELDRAZIDFC,
    "nyxtouched": FrameEffect.NYXTOUCHED,
    "originpwdfc": FrameEffect.ORIGINPWDFC,
    "sunmoondfc": FrameEffect.SUNMOONDFC,
    "tombstone": FrameEffect.TOMBSTONE
});

enum Game { MTGO, PAPER, ARENA }

final gameValues = EnumValues({
    "arena": Game.ARENA,
    "mtgo": Game.MTGO,
    "paper": Game.PAPER
});

enum CardObject { CARD }

final dbObjectValues = EnumValues({
  "card": CardObject.CARD
});

enum Rarity { RARE, COMMON, UNCOMMON, MYTHIC }

final rarityValues = EnumValues({
  "common": Rarity.COMMON,
  "mythic": Rarity.MYTHIC,
  "rare": Rarity.RARE,
  "uncommon": Rarity.UNCOMMON
});

class RelatedUris {
    String? gatherer;
    String? tcgplayerDecks;
    String? edhrec;
    String? mtgtop8;

    RelatedUris({
        this.gatherer,
        this.tcgplayerDecks,
        this.edhrec,
        this.mtgtop8,
    });

    factory RelatedUris.fromJson(Map<String, dynamic> json) => RelatedUris(
        gatherer: json["gatherer"],
        tcgplayerDecks: json["tcgplayer_decks"],
        edhrec: json["edhrec"],
        mtgtop8: json["mtgtop8"],
    );

    Map<String, dynamic> toJson() => {
        "gatherer": gatherer,
        "tcgplayer_decks": tcgplayerDecks,
        "edhrec": edhrec,
        "mtgtop8": mtgtop8,
    };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? _reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    _reverseMap ??= <T,String>{
        for(final entry in map.entries)
          entry.value: entry.key
      };
    return _reverseMap!;
  }
}
