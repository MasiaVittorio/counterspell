import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class CSActions{
  static const String androidUrl = 'https://play.google.com/store/apps/details?id=com.mvsidereusart.counterspell';
  static const String iosUrl = "https://itunes.apple.com/us/app/counterspell/id1459235508?l=it&ls=1&mt=8";
  
  static const String mailUrl = 'mailto:mvsidereus@gmail.com?subject=CounterSpell';
  static const String chatUrl = 'https://t.me/joinchat/CWQ9yhZgKHf0lPgJaeGkwQ';
    
  static void review() async {
    final String url = Platform.isAndroid ? androidUrl : iosUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
  static void mailMe() async {
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      print('Could not launch $mailUrl');
    }
  }
  static void chatWithMe() async {
    if (await canLaunch(chatUrl)) {
      await launch(chatUrl);
    } else {
      print('Could not launch $chatUrl');
    }
  }

}