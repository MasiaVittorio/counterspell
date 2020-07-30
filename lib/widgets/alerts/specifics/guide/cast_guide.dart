import 'package:counter_spell_new/core.dart';

const String _choseTitle = "Choose single commander or partners";
const String _chose1 = "Long press on the person icon to split in two partners";
const String _chose2 = "(Or merge two partners into a single commander)";

const String _partnerTitle = "Select the right partner";
const String _partner1 = "Tap on the person icon to switch between partner A and B";

class CastInfo extends StatelessWidget {
  const CastInfo();
  static const height = 2 * (InfoTitle.height + 14.0) + 3 * PieceOfInfo.height + AlertDrag.height - 14.0;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: Stage.of(context).panelController.panelScrollPhysics(),
        child: Container(
          height: height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const InfoSection(
                first: true,
                icon: const Icon(Icons.person_outline),
                title: _choseTitle,
                info: [
                  _chose1,
                  _chose2,
                ],
              ),
              const InfoSection(
                last: true,
                icon: const Icon(McIcons.account_multiple_outline),
                title: _partnerTitle,
                info: [
                  _partner1,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

