import 'dart:io';

import 'dart:convert';

import 'package:counter_spell_new/core.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path/path.dart' as path;

extension CSBackupPreferences on CSBackupBloc {
  void initPreferences() {
    if (!ready.value) return;
    final List<File> preferences = jsonFilesInDirectory(preferencesDirectory!);
    savedPreferences.set(preferences);
  }

  //===================================
  // Methods

  Future<bool> savePreferences() async {
    if (!ready.value) return false;

    final now = DateTime.now();
    File newFile = File(path.join(
      preferencesDirectory!.path,
      "pr_${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}.json",
    ));

    int i = 0;
    while (await newFile.exists()) {
      ++i;
      String withoutExt = path.basenameWithoutExtension(newFile.path);
      newFile = File(path.join(
        preferencesDirectory!.path,
        "${withoutExt}_($i).json",
      ));
      if (i == 100) {
        // print("100 files in the same second? wtf??");
        return false;
      }
    }

    newFile.create();

    final settings = parent.settings;
    final arena = settings.arenaSettings;
    final gameSettings = settings.gameSettings;
    final app = settings.appSettings;
    final scroll = settings.scrollSettings;
    final game = parent.game;
    final group = game.gameGroup;
    final themer = parent.themer;

    await newFile.writeAsString(
      jsonEncode(<String, dynamic>{
        themer.savedSchemes.key: <String, Map<String, dynamic>>{
          for (final e in themer.savedSchemes.value.entries)
            e.key: e.value.toJson,
        },

        group.savedNames.key // Set<String> ->
            : group.savedNames.value.toList(), // List<String>

        gameSettings.timeMode.key: // TimeMode ->
            TimeModes.nameOf(gameSettings.timeMode.value), // String (nameOf)

        app.alwaysOnDisplay.key: app.alwaysOnDisplay.value, // bool

        app.wantVibrate.key: app.wantVibrate.value, // bool

        arena.scrollOverTap.key: arena.scrollOverTap.value, // bool

        arena.verticalScroll.key: arena.verticalScroll.value, // bool

        arena.verticalTap.key: arena.verticalTap.value, // bool

        scroll.confirmDelay.key: // Duration ->
            scroll.confirmDelay.value.inMilliseconds, // int (milliseconds)

        scroll.scrollSensitivity.key: scroll.scrollSensitivity.value, // double

        scroll.scroll1Static.key: scroll.scroll1Static.value, // bool

        scroll.scroll1StaticValue.key:
            scroll.scroll1StaticValue.value, // double

        scroll.scrollDynamicSpeed.key: scroll.scrollDynamicSpeed.value, // bool

        scroll.scrollDynamicSpeedValue.key:
            scroll.scrollDynamicSpeedValue.value, // double

        scroll.scrollPreBoost.key: scroll.scrollPreBoost.value, //bool

        scroll.scrollPreBoostValue.key:
            scroll.scrollPreBoostValue.value, //double
      }),
    );

    savedPreferences.value.add(newFile);
    savedPreferences.refresh();

    return true;
  }

  Future<bool> deletePreference(int index) async {
    if (savedPreferences.value.checkIndex(index)) {
      final file = savedPreferences.value.removeAt(index);
      savedPreferences.refresh();
      await file.delete();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> loadPreferences(File file) async {
    if (!ready.value) return false;
    if (!(await Permission.storage.isGranted)) return false;

    try {
      String content = await file.readAsString();

      dynamic map = jsonDecode(content);

      if (map is Map) {
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
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }

    return true;
  }
}
