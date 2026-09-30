import 'models.dart';

/// Swap MockRepository for an ApiRepository that talks to your backend.
abstract class GiftTokRepository {
  Future<BoardSnapshot> fetchBoard();
  Future<Creator> fetchCreator(String handle);
  Future<List<GiftStat>> fetchGiftLeaders(String range); // 24h | 7d | 30d
  Future<void> submitStreamer(String handle);
}

class MockRepository implements GiftTokRepository {
  final _creators = List.generate(
      30,
      (i) => Creator(
            handle: 'creator_${i + 1}',
            name: 'Creator ${i + 1}',
            isLive: i % 3 != 2,
            viewers: i % 3 != 2 ? 90000 - i * 2900 : null,
            gifts: i * 12,
            followers: 100000 + i * 5300,
            following: 120 + i,
            likes: 2000000 + i * 41000,
            videos: 80 + i,
            comments: 900 + i * 31,
            peak: 95000 - i * 2500,
            valueMin: 0,
            valueMax: 189.0 - i * 4,
            liveSince: '2h 14m',
            streams: [
              StreamSession('29 Sep, 21:40', '2h 05m', 14200, 88, 3100,
                  40210 - i * 500, 120),
              StreamSession('28 Sep, 20:10', '1h 47m', 9800, 54, 2200,
                  31800 - i * 400, 74),
            ],
          ));

  @override
  Future<BoardSnapshot> fetchBoard() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return BoardSnapshot(4332, _creators.where((c) => c.isLive).length, 0, 0,
        189, DateTime.now(), _creators);
  }

  @override
  Future<Creator> fetchCreator(String handle) async =>
      _creators.firstWhere((c) => c.handle == handle);

  @override
  Future<List<GiftStat>> fetchGiftLeaders(String range) async => [
        GiftStat('Accelerator Crown', '', 1000, 0, 0),
        GiftStat('Surprise!', '', 699, 0, 0),
        GiftStat('Mono armicufales', '', 199, 0, 0),
        GiftStat('MX Soccer Stadium', '', 399, 0, 0),
        GiftStat('Gafas Blancas', '', 1, 0, 0),
      ];

  @override
  Future<void> submitStreamer(String handle) async {}
}
