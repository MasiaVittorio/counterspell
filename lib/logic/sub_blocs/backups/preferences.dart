import 'dart:convert';
import 'dart:io';

import 'package:counter_spell/core.dart';
import 'package:counter_spell/logic/sub_blocs/backups/backup_logic.dart';
import 'package:counter_spell/widgets/alerts/specifics/menu/settings/backups/share_or_save.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

extension CSBackupPreferences on CSBackupBloc {
  //===================================
  // Methods

  Future<bool> savePreferences() async {
    final newFile = await createPreferencesBackup();

    if (newFile == null) {
      return false;
    } else {
      await newFile.share();
      return true;
    }
  }

  Future<File?> createPreferencesBackup() async {
    final now = DateTime.now();
    final tempDir = await getTemporaryDirectory();
    File newFile = File(path.join(
      tempDir.path,
      "counterspell_settings_${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}.json",
    ));

    await newFile.writeAsString(
      jsonEncode(<String, dynamic>{
        parent.themer.savedSchemes.key: <String, Map<String, dynamic>>{
          for (final e in parent.themer.savedSchemes.value.entries)
            e.key: e.value.toJson,
        },

        parent.game.gameGroup.savedNames.key // Set<String> ->
            : parent.game.gameGroup.savedNames.value.toList(), // List<String>

        parent.settings.gameSettings.timeMode.key: // TimeMode ->
            TimeModes.nameOf(
                parent.settings.gameSettings.timeMode.value), // String (nameOf)

        parent.settings.appSettings.alwaysOnDisplay.key:
            parent.settings.appSettings.alwaysOnDisplay.value, // bool

        parent.settings.appSettings.wantVibrate.key:
            parent.settings.appSettings.wantVibrate.value, // bool

        parent.settings.arenaSettings.scrollOverTap.key:
            parent.settings.arenaSettings.scrollOverTap.value, // bool

        parent.settings.arenaSettings.verticalScroll.key:
            parent.settings.arenaSettings.verticalScroll.value, // bool

        parent.settings.arenaSettings.verticalTap.key:
            parent.settings.arenaSettings.verticalTap.value, // bool

        parent.settings.scrollSettings.confirmDelay.key: // Duration ->
            parent.settings.scrollSettings.confirmDelay.value
                .inMilliseconds, // int (milliseconds)

        parent.settings.scrollSettings.scrollSensitivity.key:
            parent.settings.scrollSettings.scrollSensitivity.value, // double

        parent.settings.scrollSettings.scroll1Static.key:
            parent.settings.scrollSettings.scroll1Static.value, // bool

        parent.settings.scrollSettings.scroll1StaticValue.key:
            parent.settings.scrollSettings.scroll1StaticValue.value, // double

        parent.settings.scrollSettings.scrollDynamicSpeed.key:
            parent.settings.scrollSettings.scrollDynamicSpeed.value, // bool

        parent.settings.scrollSettings.scrollDynamicSpeedValue.key: parent
            .settings.scrollSettings.scrollDynamicSpeedValue.value, // double

        parent.settings.scrollSettings.scrollPreBoost.key:
            parent.settings.scrollSettings.scrollPreBoost.value, //bool

        parent.settings.scrollSettings.scrollPreBoostValue.key:
            parent.settings.scrollSettings.scrollPreBoostValue.value, //double
      }),
    );

    return newFile;
  }

  Future<bool> loadPreferences(File file) async {
    final map = await readPreferences(file);
    if (map != null) {
      return await restorePreferences(map);
    } else {
      return false;
    }
  }

  Future<Map?> readPreferences(File file) async {
    try {
      String content = await file.readAsString();
      dynamic map = jsonDecode(content);
      if (map is Map) {
        return map;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool> restorePreferences(Map map) async {
    bool errorRestoring = false;
    try {
      final settings = parent.settings;
      final arena = settings.arenaSettings;
      final gameSettings = settings.gameSettings;
      final app = settings.appSettings;
      final scroll = settings.scrollSettings;
      final game = parent.game;
      final group = game.gameGroup;
      final themer = parent.themer;

      {
        final blocVar = themer.savedSchemes;
        final val = map[blocVar.key];
        if (val is Map) {
          for (final e in val.entries) {
            if (e.key is String && e.value is Map) {
              blocVar.value[e.key] = CSColorScheme.fromJson(e.value);
            }
          }
          blocVar.refresh();
        }
      }

      {
        final blocVar = group.savedNames;
        final val = map[blocVar.key];
        if (val is List) {
          for (final name in val) {
            if (name is String) blocVar.value.add(name);
          }
          blocVar.refresh();
        }
      }

      {
        final blocVar = gameSettings.timeMode;
        final val = map[blocVar.key];
        if (val is String) {
          if (TimeModes.reversed.containsKey(val)) {
            blocVar.set(TimeModes.fromName(val));
          }
        }
      }

      {
        final blocVar = app.alwaysOnDisplay;
        final val = map[blocVar.key];
        if (val is bool) {
          blocVar.set(val);
        }
      }

      {
        final blocVar = app.wantVibrate;
        final val = map[blocVar.key];
        if (val is bool) {
          blocVar.set(val);
        }
      }

      {
        final blocVar = arena.scrollOverTap;
        final val = map[blocVar.key];
        if (val is bool) {
          blocVar.set(val);
        }
      }

      {
        final blocVar = arena.verticalScroll;
        final val = map[blocVar.key];
        if (val is bool) {
          blocVar.set(val);
        }
      }

      {
        final blocVar = arena.verticalTap;
        final val = map[blocVar.key];
        if (val is bool) {
          blocVar.set(val);
        }
      }

      {
        final blocVar = scroll.confirmDelay;
        final val = map[blocVar.key];
        if (val is int) {
          blocVar.set(Duration(milliseconds: val));
        }
      }

      {
        final blocVar = scroll.scrollSensitivity;
        final val = map[blocVar.key];
        if (val is double) {
          blocVar.set(val);
        }
      }

      {
        final blocVar = scroll.scroll1StaticValue;
        final val = map[blocVar.key];
        if (val is double) {
          blocVar.set(val);
        }
      }

      {
        final blocVar = scroll.scrollDynamicSpeedValue;
        final val = map[blocVar.key];
        if (val is double) {
          blocVar.set(val);
        }
      }

      {
        final blocVar = scroll.scrollPreBoostValue;
        final val = map[blocVar.key];
        if (val is double) {
          blocVar.set(val);
        }
      }

      {
        final blocVar = scroll.scroll1Static;
        final val = map[blocVar.key];
        if (val is bool) {
          blocVar.set(val);
        }
      }

      {
        final blocVar = scroll.scrollDynamicSpeed;
        final val = map[blocVar.key];
        if (val is bool) {
          blocVar.set(val);
        }
      }

      {
        final blocVar = scroll.scrollPreBoost;
        final val = map[blocVar.key];
        if (val is bool) {
          blocVar.set(val);
        }
      }
    } catch (e) {
      errorRestoring = true;
    }

    if (errorRestoring) {
      return false;
    } else {
      return true;
    }
  }
}
