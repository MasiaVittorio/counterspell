typedef WinRate = ({int wins, int draws, int losses});

extension WinRateExtensions on WinRate {
  int get total => wins + draws + losses;

  WinRate modalIgnoreDraws(bool ignore) {
    if (!ignore) return this;
    return ignoreDraws;
  }

  WinRate get ignoreDraws => (wins: wins, draws: 0, losses: losses);

  double get winFraction => total == 0 ? 0 : wins / total;
  double get lossFraction => total == 0 ? 0 : losses / total;
  double get drawFraction => total == 0 ? 0 : draws / total;

  double get winPercentage => winFraction * 100;
  double get lossPercentage => lossFraction * 100;
  double get drawPercentage => drawFraction * 100;

  String get formattedWinPercentage {
    if (total == 0) return 'N/A';
    return '${winPercentage.toStringAsFixed(1)}%';
  }

  String get formattedLossPercentage {
    if (total == 0) return 'N/A';
    return '${lossPercentage.toStringAsFixed(1)}%';
  }

  String get formattedDrawPercentage {
    if (total == 0) return 'N/A';
    return '${drawPercentage.toStringAsFixed(1)}%';
  }
}
