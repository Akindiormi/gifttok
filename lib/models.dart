class StreamSession {
  final String ended, duration;
  final int likes, gifts, comments, peak;
  final double value;
  StreamSession(this.ended, this.duration, this.likes, this.gifts,
      this.comments, this.peak, this.value);
}

class GiftStat {
  final String name, iconUrl;
  final int coins, given;
  final double value;
  GiftStat(this.name, this.iconUrl, this.coins, this.given, this.value);
}

class Creator {
  final String handle, name, updated;
  final bool isLive;
  final int? viewers;
  final int gifts, followers, following, likes, videos, comments, peak;
  final double valueMin, valueMax;
  final String liveSince;
  final List<StreamSession> streams;
  Creator({
    required this.handle,
    required this.name,
    this.updated = 'Just now',
    this.isLive = false,
    this.viewers,
    this.gifts = 0,
    this.followers = 0,
    this.following = 0,
    this.likes = 0,
    this.videos = 0,
    this.comments = 0,
    this.peak = 0,
    this.valueMin = 0,
    this.valueMax = 0,
    this.liveSince = '-',
    this.streams = const [],
  });
}

class BoardSnapshot {
  final int tracked, online, gifts24h;
  final double valueMin, valueMax;
  final DateTime generatedAt;
  final List<Creator> creators;
  BoardSnapshot(this.tracked, this.online, this.gifts24h, this.valueMin,
      this.valueMax, this.generatedAt, this.creators);

  List<Creator> get onlineSorted =>
      creators.where((c) => c.isLive).toList()
        ..sort((a, b) => (b.viewers ?? 0).compareTo(a.viewers ?? 0));
  List<Creator> get topRevenue => ([...creators]
        ..sort((a, b) => b.valueMax.compareTo(a.valueMax)))
      .take(5)
      .toList();
}
