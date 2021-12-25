// import 'dart:html' hide VoidCallback;

import 'package:counter_spell_new/core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:path/path.dart' as path;

class BackupsAlert extends StatelessWidget {

  const BackupsAlert();

  @override
  Widget build(BuildContext context) {
    return _BackupsAlert(CSBloc.of(context));
  }
}


class _BackupsAlert extends StatefulWidget {

  final CSBloc logic;

  _BackupsAlert(this.logic);

  @override
  _BackupsAlertState createState() => _BackupsAlertState();
}

class _BackupsAlertState extends State<_BackupsAlert> {

  PermissionStatus permissionStatus;

  @override
  void initState() {
    super.initState();
    // widget.logic.backups.init();
    init();
  }

  void init() async {
    permissionStatus = await Permission.storage.status;
    this.setState((){});
  }

  @override
  Widget build(BuildContext context) {

    final CSBackupBloc backups = widget.logic.backups;

    return backups.ready.build((context, ready){

      if(!ready){
        return HeaderedAlert(
          "Permission needed",
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PermissionStatusWidget(
                permissionStatus, 
                onStatusChanged: (status){
                  if(status?.isGranted ?? false){
                    this.setState(() {
                      this.permissionStatus = status;
                    });
                    backups.init();
                  }
                }
              ),
              if(permissionStatus?.isGranted ?? false)
                ListTile(
                  title: Text("Loading..."),
                  leading: CircularProgressIndicator(),
                ),
            ],
          ),
        );
      }

      final stage = Stage.of(context);

      return RadioHeaderedAlert<BackupType>(
        initialValue: stage.panelController.alertController.savedStates[
          "backups radio headered alert"
        ] ?? BackupType.pastGames,
        onPageChanged: (p) => stage.panelController.alertController.savedStates[
          "backups radio headered alert"
        ] = p,
        orderedValues: <BackupType>[BackupType.pastGames, BackupType.preferences],
        items: <BackupType,RadioHeaderedItem>{
          BackupType.preferences: RadioHeaderedItem(
            child: backups.savedPreferences.build((context, list) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for(int i=0; i<list.length; ++i)
                  FileListTile(
                    file: list[i],
                    index: i,
                    type: BackupType.preferences,
                  ),
                  
                DoOneTime(
                  title: Text("Create new backup"),
                  leading: Icon(Icons.add),
                  futureTap: backups.savePreferences,
                ),
              ],
            ),),
            longTitle: "Backup preferences",
            title: "Preferences",
            icon: McIcons.cog,
            unselectedIcon: McIcons.cog_outline,
          ),
          BackupType.pastGames: RadioHeaderedItem(
            child: backups.savedPastGames.build((context, list) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for(int i=0; i<list.length; ++i)
                  FileListTile(
                    file: list[i],
                    index: i,
                    type: BackupType.pastGames,
                  ),
                  
                DoOneTime(
                  title: Text("Create new backup"),
                  leading: Icon(Icons.add),
                  futureTap: backups.savePastGames,
                ),
              ],
            ),),
            longTitle: "Backup game history",
            title: "Games",
            icon: McIcons.medal,
          ),
        },
      );
    });

  }
}


class DoOneTime extends StatefulWidget {
  final Future<bool> Function() futureTap;
  final void Function(VoidCallback tapped) delegateTap;
  final Widget leading;
  final Widget title;

  const DoOneTime({
    @required this.title,
    this.leading,
    this.futureTap,
    this.delegateTap,
  });

  @override
  _DoOneTimeState createState() => _DoOneTimeState();
}

class _DoOneTimeState extends State<DoOneTime> {

  bool done = false;
  bool waiting = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: widget.title,
      leading: widget.leading,
      trailing: done 
        ? const Icon(Icons.check) 
        : waiting 
          ? const CircularProgressIndicator()
          : null,
      onTap: done ? null : widget.delegateTap != null
        ? () {
          this.setState(() {
            waiting = true;
            done = false;
          });
          widget.delegateTap(() {
            if(!mounted) return;
            this.setState(() {
              waiting = false;
              done = true;
            });
          });
        }
        : widget.futureTap != null
          ? () async {
            this.setState(() {
              done = false;
              waiting = true;
            });
            if(await widget.futureTap()){
              if(!mounted) return;
              this.setState(() {
                done = true;
                waiting = false;
              });
            }
          }
          : null,
    );
  }
}


enum BackupType {
  preferences,
  pastGames,
}


class FileListTile extends StatelessWidget {
  final File file;
  final int index;
  final BackupType type;

  FileListTile({
    @required this.index,
    @required this.file,
    @required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final stage = Stage.of(context);
    return ListTile(
      title: Text(path.basename(file.path)),
      leading: Icon(McIcons.file_document_outline),
      trailing: IconButton(
        icon: CSWidgets.deleteIcon,
        onPressed: () => stage.showAlert(
        ConfirmAlert(
          action: <BackupType,VoidCallback>{
            BackupType.preferences: () => logic.backups.deletePreference(index),
            BackupType.pastGames: () => logic.backups.deletePastGame(index),
          }[type],
          warningText: "Delete file?",
          confirmIcon: Icons.delete_forever,
          confirmColor: CSColors.delete,
        ),
        size: ConfirmAlert.height,
      ),
      ),
      onTap: () => stage.showAlert(
        ConfirmAlert(
          action: <BackupType,VoidCallback>{
            BackupType.preferences: () => logic.backups.loadPreferences(file),
            BackupType.pastGames: () => logic.backups.loadPastGame(file),
          }[type],
          warningText: <BackupType,String>{
            BackupType.preferences: "Merge preferences from file?",
            BackupType.pastGames: "Merge games from file?",
          }[type],
        ),
        size: ConfirmAlert.height,
      ),

    );
  }
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
    PermissionStatus.limited: "Limited",
    // PermissionStatus.undetermined: "Not asked yet",
  }[widget.status]) ?? "Not checked yet";

  IconData get permissionIcon => (<PermissionStatus,IconData>{
    PermissionStatus.denied: Icons.close,
    PermissionStatus.granted: Icons.check,
    PermissionStatus.permanentlyDenied: Icons.close,
    PermissionStatus.restricted: Icons.help_outline,
    PermissionStatus.limited: Icons.help_outline,
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