// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sid_utils/sid_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'card.dart';

class ScryfallApi {
  static void openCardOnCardMarket(MtgCard card) async {
    final url = card.purchaseUris?.cardmarket ?? "";
    if (url == "") return;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Could not launch $url');
    }
  }

  static void openCardOnTcgPlayer(MtgCard card) async {
    final url = card.purchaseUris?.tcgplayer ?? "";
    if (url == "") return;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Could not launch $url');
    }
  }

  static void openCardOnScryfall(MtgCard card) async {
    final url = card.scryfallUri!;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Could not launch $url');
    }
  }

  static String _searchString(String string, {bool uniqueName = true}) =>
      "https://api.scryfall.com/cards/search?order=edhrec&q=${PercentEncode.encodeString(string)}${uniqueName ? "+unique%3Aname" : ""}"; //+legal%3Acommander";

  static Future<List<MtgCard>?> searchReprints(MtgCard card) async {
    return await search('!"${card.name}" unique:prints',
        uniqueName: false, force: true);
  }

  static Future<List<MtgCard>?> searchArts(String name, bool commander) async {
    return await search('"$name"${commander ? " is:commander" : ""} unique:art',
        uniqueName: false, force: true);
  }

  static DateTime? _last;
  static Future<List<MtgCard>?> search(String string,
      {bool force = false, bool uniqueName = true}) async {
    // print("api searching (force: $force)");
    final now = DateTime.now();

    if (force == false) {
      if (_last != null) {
        final secs = _last!.difference(now).inSeconds.abs();
        // print("api searching -> (secs: $secs)");
        if (secs < 10) {
          return null;
        }
      }
    }

    _last = now;

    if (string == "") return null;
    final ss = ScryfallApi._searchString(string, uniqueName: uniqueName);
    // print("searching: $_ss");
    final response = await http.get(Uri.parse(ss), headers: {
      'User-Agent': 'Limited/1.0',
      'Accept': 'application/json;q=0.9,*/*;q=0.8',
    });

    Map<String, dynamic>? map;

    switch (response.statusCode) {
      case 200:
        map = json.decode(response.body);
        break;

      case 404:
        return <MtgCard>[];

      default:
    }

    if (map == null) return null;

    if (map["object"] == "error") {
      if (map["code"] == "not_found") {
        return <MtgCard>[];
      } else {
        return null;
      }
    }

    if (!map.containsKey('data')) return null;

    List? data;

    try {
      data = List.from(map['data']);
    } catch (e) {
      data = null;
    }

    if (data == null) return null;
    if (data.isEmpty) return <MtgCard>[];

    return [
      for (final cjs in data) MtgCard.fromJson(cjs),
    ];
  }
}
