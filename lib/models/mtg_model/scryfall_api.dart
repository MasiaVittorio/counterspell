// ignore_for_file: avoid_print

import 'dart:async';
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
    } else {}
  }

  static void openCardOnTcgPlayer(MtgCard card) async {
    final url = card.purchaseUris?.tcgplayer ?? "";
    if (url == "") return;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {}
  }

  static void openCardOnScryfall(MtgCard card) async {
    final url = card.scryfallUri!;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {}
  }

  static const Duration debounceDuration = Duration(milliseconds: 200);
  static DateTime? _last;
  static List<({String query, Completer completer})> queue = [];
  static bool _isSearching = false;

  static bool _isCheckingQueue = false;

  static bool isNowAGoodTimeForANewItem() {
    if (_isSearching) return false;
    if (queue.isNotEmpty) return false;
    return switch (_last) {
      null => true,
      DateTime last =>
        DateTime.now().difference(last).abs() >= debounceDuration,
    };
  }

  static bool isNowAGoodTimeForAQueuedItem() {
    if (_isSearching) return false;
    return switch (_last) {
      null => true,
      DateTime last =>
        DateTime.now().difference(last).abs() >= debounceDuration,
    };
  }

  static Future<List<MtgCard>?> search(String query) async {
    if (query == "") return null;

    if (isNowAGoodTimeForANewItem()) {
      return await _actuallySearch(query);
    } else {
      final completer = Completer<List<MtgCard>?>();
      queue.add((query: query, completer: completer));
      if (!_isCheckingQueue) startQueueCheck();
      return completer.future;
    }
  }

  static void startQueueCheck() async {
    if (_isCheckingQueue) return;
    _isCheckingQueue = true;
    while (queue.isNotEmpty) {
      await Future.delayed(debounceDuration);
      final isIt = isNowAGoodTimeForAQueuedItem();
      if (isIt) {
        final item = queue.removeAt(0);
        final result = await _actuallySearch(item.query);
        item.completer.complete(result);
      }
    }
    _isCheckingQueue = false;
  }

  static Future<List<MtgCard>?> _actuallySearch(String query) async {
    if (query.isEmpty) return null;
    _isSearching = true;
    _last = DateTime.now();
    final response = await http.get(
      Uri.parse(ScryfallApi._searchString(query)),
      headers: {
        'User-Agent': 'Limited/1.0',
        'Accept': 'application/json;q=0.9,*/*;q=0.8',
      },
    );
    _isSearching = false;
    _last = DateTime.now();
    return _processResponse(response);
  }

  static List<MtgCard>? _processResponse(http.Response response) {
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
