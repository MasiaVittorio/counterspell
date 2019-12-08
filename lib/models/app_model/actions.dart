import 'dart:io';
import 'package:counter_spell_new/core.dart';
import 'package:url_launcher/url_launcher.dart';

class CSActions{
    
  static void review() async {
    final String url = Platform.isAndroid ? CSUris.playStore: CSUris.appStore;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
  static void mailMe() async {
    if (await canLaunch(CSUris.mailAction)) {
      await launch(CSUris.mailAction);
    } else {
      print('Could not launch $CSUris.mailAction');
    }
  }
  static void chatWithMe() async {
    if (await canLaunch(CSUris.telegramGroup)) {
      await launch(CSUris.telegramGroup);
    } else {
      print('Could not launch $CSUris.telegramGroup');
    }
  }

}