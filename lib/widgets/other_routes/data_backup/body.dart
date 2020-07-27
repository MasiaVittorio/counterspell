import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sid_bloc/persistence/shared_db.dart' as shared_db;
import 'dart:io' as io;
import 'package:stage/stage.dart';
import 'package:ext_storage/ext_storage.dart' as ext_storage; 
import 'backup_route.dart';

import 'package:permission_handler/permission_handler.dart';

class BackupBody extends StatefulWidget {

  const  BackupBody();

  @override
  _BackupBodyState createState() => _BackupBodyState();
}

class _BackupBodyState extends State<BackupBody> {

  static const String _dbName = "shared.db";
  static const String _dirName = "CounterSpell";

  bool notAndroid;

  PermissionStatus permissionStatus;


  String loadingMessage = "Initiating page";

  String privateDatabaseDirectoryPath;
  io.File privateDatabaseFile;
  bool get privateDatabaseExists => privateDatabaseFile?.existsSync();

  String internalStoragePath;
  io.Directory internalStorageCounterspellDirectory;
  io.File savedDatabaseFile;
  bool get savedDatabaseExists => savedDatabaseFile?.existsSync();

  bool saving = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {

    shared_db.SharedDb.close();

    if(!io.Platform.isAndroid){
      notAndroid = true;
      return;
    } else {
      notAndroid = false;
    }

    if(!await initPermission()){
      message("Storage permission needed!");
      return;
    }

    await initSaved();

    await initPrivate();

    message(null);
  }

  Future initPermission() async {
    message("Checking storage permission");
    this.permissionStatus = await Permission.storage.status;
    return permissionStatus.isGranted;
  }


  Future initSaved() async {

    message("Getting internal storage");

    this.internalStoragePath = await ext_storage.ExtStorage.getExternalStorageDirectory(); 

    this.internalStorageCounterspellDirectory = io.Directory(
      path.join(internalStoragePath, _dirName)
    );

    if(!(await internalStorageCounterspellDirectory.exists())){
      message("Creating $_dirName directory");
      await internalStorageCounterspellDirectory.create();
    }

    this.savedDatabaseFile = io.File(path.join(
      internalStorageCounterspellDirectory.path,
      _dbName,
    ));

  }

  Future initPrivate() async {
    message("Getting private database directory");
    this.privateDatabaseDirectoryPath = await sqflite.getDatabasesPath();

    this.privateDatabaseFile = io.File(path.join(
      privateDatabaseDirectoryPath,
      _dbName,
    ));

  }


  Future<bool> loadFromSaved() async {
    if(this.savedDatabaseExists){
      /// This will overwrite the existing shared.db file
      /// in the private directory of the app with the one 
      /// saved previously in the internal storage
      await this.savedDatabaseFile.copy(path.join(
        this.privateDatabaseDirectoryPath,
        _dbName,
      ));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveFromCurrent() async {
    if(this.privateDatabaseExists){
      /// This will overwrite the existing shared.db file
      await this.privateDatabaseFile.copy(
        path.join(
          this.internalStorageCounterspellDirectory.path,
          _dbName,
        ),
      );
      return true;
    } else {
      return false;
    }
  }

  void _save() async {
    setState(() {
      saving = true;
    });
    await saveFromCurrent();
    SystemNavigator.pop();
  }

  // void _load() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   await loadFromSaved();
  //   SystemNavigator.pop();
  // }

  @override
  Widget build(BuildContext context) {
    if(notAndroid){
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: const Text(
          "this feature is only available on Android", 
          textAlign: TextAlign.center,
        )
      );
    }

    if(loadingMessage != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PermissionStatusWidget(
            permissionStatus, 
            onStatusChanged: (s) => init(),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(loadingMessage, textAlign: TextAlign.center,),
          ),
        ],
      );
    }

    if(!(this.privateDatabaseExists ?? false)){
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: const Text(
          "ERROR: private database doesn't exist", 
          textAlign: TextAlign.center,
        ),
      );
    }

    final stage = Stage.of(context);

    return StageBody<BackupPage>(
      canvasBackground: true,
      children: <BackupPage,Widget>{
        BackupPage.save: Column(children: <Widget>[
          const ListTile(
            title: Text("Your personal settings, past games history and such are saved in a single .db file"),
            leading: Icon(Icons.info_outline),
          ),

          const ListTile(
            leading: Icon(Icons.save),
            title: Text("You can save a copy of it in your internal storage for later restoring"),
          ),

          if(this.savedDatabaseExists)
            ListTile(
              title: Text('One "shared.db" file is already saved in your local storage'),
              leading: Icon(Icons.check),
            ),

          Expanded(child: SubSection(
            <Widget>[
              if(saving)
                const Center(child: CircularProgressIndicator()) 
              else
                const Icon(Icons.save, size: 100,),

              Text(
                saving ? "Saving..." : 'Save current database to internal ${this.internalStorageCounterspellDirectory.path}',
                textAlign: TextAlign.center,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            onTap: (){
              if(this.savedDatabaseExists){
                stage.showAlert(ConfirmAlert(
                  action: _save,
                  warningText: "Overwrite previously saved database?",
                ));
              } else _save();
            },
          ),),

          SizedBox(height: StageDimensions.defaultCollapsedPanelSize/2 + 16),

        ],),
        BackupPage.load: Container(),
      },
    );
  }


  void message(String message)
    => SchedulerBinding.instance.addPostFrameCallback((_){
      if(!mounted) return;
      this.setState((){
        this.loadingMessage = message;
      });
    },);


}







class PermissionStatusWidget extends StatefulWidget {

  const PermissionStatusWidget(this.status, {
    @required this.onStatusChanged,
  });

  final PermissionStatus status;
  final ValueChanged<PermissionStatus> onStatusChanged;

  @override
  _PermissionStatusWidgetState createState() => _PermissionStatusWidgetState();
}

class _PermissionStatusWidgetState extends State<PermissionStatusWidget> {

  bool waiting = false;

  String get permissionString => (<PermissionStatus,String>{
    PermissionStatus.denied: "Denied",
    PermissionStatus.granted: "Granted",
    PermissionStatus.permanentlyDenied: "Permanently denied",
    PermissionStatus.restricted: "Restricted",
    PermissionStatus.undetermined: "Not asked yet",
  }[widget.status]) ?? "Not checked yet";

  IconData get permissionIcon => (<PermissionStatus,IconData>{
    PermissionStatus.denied: Icons.close,
    PermissionStatus.granted: Icons.check,
    PermissionStatus.permanentlyDenied: Icons.close,
    PermissionStatus.restricted: Icons.help_outline,
    PermissionStatus.undetermined: Icons.help_outline,
  }[widget.status]) ?? Icons.help_outline;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(permissionIcon),
      title: const Text("Storage Permission"),
      subtitle: Text(permissionString),
      trailing: waiting
        ? const CircularProgressIndicator()
        : null,
      onTap: [
        PermissionStatus.undetermined,
        PermissionStatus.denied,
        null,
      ].contains(widget.status) ? () async {
        this.setState(() {
          waiting = true;
        });

        widget.onStatusChanged(
          await Permission.storage.request(),
        );

        if(!mounted) return;
        this.setState(() {
          waiting = true;
        });
      } : null,
    );
  }
}