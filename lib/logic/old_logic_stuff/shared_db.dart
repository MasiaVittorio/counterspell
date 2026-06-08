// ignore_for_file: constant_identifier_names

import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sqflite;

const String _TABLE = 'shared_db';
const String _COLUMN_VALUE = 'value';
const String _createTable =
    '''
    CREATE TABLE $_TABLE ( 
      id integer primary key autoincrement, 
      key text UNIQUE not null,
      $_COLUMN_VALUE text);
    CREATE UNIQUE INDEX idx_${_TABLE}_id ON $_TABLE (id);
    CREATE UNIQUE INDEX idx_${_TABLE}_key ON $_TABLE (key);
    ''';

const String _NAME = 'shared.db';

/// A class that can be used just like shared preferences, but it
/// uses a sqlite database under the hood.
/// You call [final instance = await SharedDb.getInstance()]
/// and the you can go like [instance.getString(key)] or even
/// [instance.setString(key,value)] but just with strings.
class SharedDb {
  //Singleton pattern
  static SharedDb? _instance;
  SharedDb._construct(this.db);
  final sqflite.Database? db;

  static Future<sqflite.Database?>? _db;

  static int _idSinceCreated = 0;

  static Future<SharedDb?> getInstance() async {
    final int thisId = _idSinceCreated;

    //make sure they all await the same future
    if (_db == null && _instance == null) {
      _db = _getDb(thisId);
    }

    //if the future is there, await for it
    //and then delete it
    if (_db != null) {
      final sqflite.Database? createdDatabase = await _db;
      _db = null;

      if (thisId != _idSinceCreated) {
        /// The database has been closed since!
        return null;
      }

      //with the database obtained (the same for every call of getInstance)
      //create the SharedDb instance but only one time
      _instance ??= SharedDb._construct(createdDatabase);
    }

    return _instance;
  }

  static Future<String> _getPath() async {
    final databasesPath = await sqflite.getDatabasesPath();
    return path.join(databasesPath, _NAME);
  }

  static Future<sqflite.Database?> _getDb(int thisId) async {
    try {
      final String path = await _getPath();

      if (thisId != _idSinceCreated) {
        /// The database has been closed since!
        return null;
      }

      sqflite.Database result = await sqflite.openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          // When creating the db, create the table
          await db.execute(_createTable);
          await db.execute('PRAGMA case_sensitive_like = true');
        },
      );

      if (thisId != _idSinceCreated) {
        /// The database has been closed since!
        result.close();
        return null;
      }

      //non so perché, copiato da frideos
      await result.execute('PRAGMA case_sensitive_like = true');

      if (thisId != _idSinceCreated) {
        /// The database has been closed since!
        result.close();
        return null;
      }

      return result;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static void close() {
    _idSinceCreated++;
    if (_instance != null) {
      _instance!.db?.close();
      _instance = null;
    }
  }

  Future<String?> getString(String key) async {
    String? valueString;
    const query = 'SELECT * FROM $_TABLE WHERE key = ?';

    try {
      final queryResult = await db!.rawQuery(query, [key]);

      if (queryResult.isNotEmpty) {
        valueString = queryResult.first[_COLUMN_VALUE] as String?;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return valueString;
  }

  Future<bool> setString(String key, String value) async {
    try {
      int changes = await db!.rawUpdate(
        'UPDATE $_TABLE SET value = ? WHERE key = ?',
        [value, key],
      );
      if (changes == 0) {
        await db!.execute(
          '''
          INSERT INTO $_TABLE (key, $_COLUMN_VALUE) 
          VALUES  (?, ?); 
          ''',
          [key, value],
        );
      }

      return true;
    } catch (e) {
      // print(e);
    }

    return false;
  }

  Future<int> deleteByKey(String key) async {
    try {
      return await db!.delete(_TABLE, where: 'key = ?', whereArgs: [key]);
    } catch (e) {
      debugPrint(e.toString());
      return -1;
    }
  }
}
