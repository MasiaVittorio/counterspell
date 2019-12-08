import 'dart:io';
import 'package:counter_spell_new/core.dart';
import 'package:url_launcher/url_launcher.dart';

class CSActions{

  static void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  } 
  static void review() async {
    _launchUrl(Platform.isAndroid ? CSUris.playStore: CSUris.appStore);
  }
  static void mailMe() async {
    _launchUrl(CSUris.mailAction);
  }
  static void chatWithMe() async {
    _launchUrl(CSUris.telegramGroup);
  }
  static void githubPage() async {
    _launchUrl(CSUris.githubPage);
  }

}