// ignore_for_file: avoid_print

import 'dart:io';

import 'package:counter_spell_new/core.dart';
import 'package:url_launcher/url_launcher.dart';

class CSActions {
  static void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Could not launch $url');
    }
  }

  static void review() async {
    _launchUrl(Platform.isAndroid ? CSUris.playStore : CSUris.appStore);
  }

  static void mailMe([String? body]) async {
    _launchUrl(CSUris.mailAction + (body == null ? "" : "&body=$body"));
  }

  static void chatWithMe() async {
    _launchUrl(CSUris.telegramGroup);
  }

  static void openDiscordInvite() async {
    _launchUrl(CSUris.discordInvite);
  }

  static void githubPage() async {
    _launchUrl(CSUris.githubPage);
  }

  static void visitCommandBros() async {
    _launchUrl(CSUris.commandBrosYouTubeChannel);
  }
}
