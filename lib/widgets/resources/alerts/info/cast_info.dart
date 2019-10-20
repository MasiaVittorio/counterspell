import 'package:counter_spell_new/themes/material_community_icons.dart';
import 'package:counter_spell_new/widgets/resources/alerts/info/info_basics.dart';
import 'package:flutter/material.dart';
import 'package:stage_board/stage_board.dart';

const String _multiTitle = "No multi selection";
const String _multi1 = "You'll just have to scroll on one player at a time";

const String _partnerTitle = "Select the right partner";
const String _partner1 = "tap on the person icon to split the commander into two partners";
const String _partner2 = "tap again on the player to switch between partners A and B";

class CastInfo extends StatelessWidget {
  const CastInfo();
  static const height = 2 * InfoTitle.height + 3 * PieceOfInfo.height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: SingleChildScrollView(
        physics: StageBoard.of(context).scrollPhysics,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const InfoSection(
              icon: const Icon(McIcons.gesture_swipe_horizontal),
              title: _multiTitle,
              info: [
                _multi1,
              ],
            ),
            const InfoSection(
              icon: const Icon(McIcons.account_multiple_outline),
              title: _partnerTitle,
              info: [
                _partner1,
                _partner2,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

