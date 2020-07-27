import 'package:counter_spell_new/business_logic/sub_blocs/backup_and_restore.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/other_routes/data_backup/body.dart';
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

      // final stage = Stage.of(context);

      return RadioHeaderedAlert<BackupType>(
        items: <BackupType,RadioHeaderedItem>{
          BackupType.theme: RadioHeaderedItem(
            child: Container(),
            longTitle: "Backup themes",
            title: "Themes",
            icon: McIcons.palette,
            unselectedIcon: McIcons.palette_outline,
          ),
          BackupType.pastGames: RadioHeaderedItem(
            child: backups.savedPastGames.build((context, list) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for(final file in list)
                  FileListTile(
                    file: file,
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
            icon: McIcons.palette,
            unselectedIcon: McIcons.palette_outline,
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
          widget.delegateTap((){
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
  theme,
  pastGames,
}


class FileListTile extends StatelessWidget {
  final File file;
  final BackupType type;

  FileListTile({
    @required this.file,
    @required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final stage = Stage.of(context);
    return DoOneTime(
      title: Text(path.basename(file.path)),
      leading: Icon(McIcons.file_document_outline),
      delegateTap: (tapped) => stage.showAlert(
        ConfirmAlert( ///TODO: long confirm nel senso che prima di andarsene aspetta che finisci
          action: () async {
            await logic.backups.loadPastGame(file);
            tapped();
          },
          warningText: "Merge games from file?",
        ),
        size: ConfirmAlert.height,
      ),
    );
  }
}

