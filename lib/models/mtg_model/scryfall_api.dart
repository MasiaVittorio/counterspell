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

  static const Duration debounceDuration = Duration(milliseconds: 200);
  static DateTime? _last;
  static List<String> queue = <String>[];
  static bool isSearching = false;

  static bool isNowAGoodTimeFor(String query) {
    if (isSearching) return false;
    if (queue.isEmpty) return true; // should never happen
    if (queue.first != query) return false;
    if (_last == null) return true;
    return switch (_last) {
      null => true,
      DateTime last =>
        DateTime.now().difference(last).abs() >= debounceDuration,
    };
  }

  static Future<List<MtgCard>?> search(String query) async {
    if (query == "") return null;

    queue.add(query);

    while (!isNowAGoodTimeFor(query)) {
      await Future.delayed(debounceDuration);
    }
    if (queue.isNotEmpty && queue.first == query) queue.removeAt(0);
    _last = DateTime.now();
    isSearching = true;
    final result = await _actuallySearch(query);
    isSearching = false;
    _last = DateTime.now();
    return result;
  }

  static Future<List<MtgCard>?> _actuallySearch(String query) async {
    final String ss = ScryfallApi._searchString(query);

    final response = await http.get(
      Uri.parse(ss),
      headers: {
        'User-Agent': 'Limited/1.0',
        'Accept': 'application/json;q=0.9,*/*;q=0.8',
      },
    );

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

    return [for (final cjs in data) MtgCard.fromJson(cjs)];
  }

  static String _searchString(String string) =>
      "https://api.scryfall.com/cards/search?order=edhrec&q=${PercentEncode.encodeString(string)}";
}
