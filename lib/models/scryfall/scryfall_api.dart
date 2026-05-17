import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'card.dart';

class ScryfallApi {
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
    if (query == '') return null;

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
    try {
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
    } catch (e) {
      debugPrint('//////// error: $e');
      _isSearching = false;
      _last = DateTime.now();
      return null;
    }
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

    if (map['object'] == 'error') {
      if (map['code'] == 'not_found') {
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

    final results = <MtgCard>[];
    for (final cjs in data) {
      try {
        results.add(MtgCard.fromMap(cjs));
      } catch (e) {
        debugPrint('//// error parsing card: $e, card: $cjs');
      }
    }
    return results;
  }

  static String _searchString(String string) =>
      'https://api.scryfall.com/cards/search?order=edhrec&q=${string.percentEncode}';
}

extension PercentEncode on String {
  static const Map<String, String> charMap = {
    '!': '%21',
    '#': '%23',
    '\$': '%24',
    '&': '%26',
    "'": '%27',
    '(': '%28',
    ')': '%29',
    '*': '%2A',
    '+': '%2B',
    ',': '%2C',
    '/': '%2F',
    ':': '%3A',
    ';': '%3B',
    '=': '%3D',
    '?': '%3F',
    '@': '%40',
    '[': '%5B',
    ']': '%5D',
  };

  static String encodeChar(String char) {
    return charMap[char] ?? char;
  }

  static String encodeString(String? string) {
    if (string == null) return '';
    if (string.isEmpty) return string;
    String result = '';
    for (final s in string.split('')) {
      result += encodeChar(s);
    }
    return result;
  }

  String get percentEncode => encodeString(this);
}
