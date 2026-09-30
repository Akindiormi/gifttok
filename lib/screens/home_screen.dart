import 'package:flutter/material.dart';
import '../main.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<BoardSnapshot> _f = repo.fetchBoard();
  Future<void> _refresh() async {
    setState(() => _f = repo.fetchBoard());
    await _f;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<BoardSnapshot>(
        future: _f,
        builder: (context, s) {
          if (!s.hasData) {
            return const Center(child: CircularProgressIndicator(color: kTeal));
          }
          final b = s.data!;
          return RefreshIndicator(
            color: kTeal,
            onRefresh: _refresh,
            child: ListView(padding: const EdgeInsets.all(16), children: [
              const Text('CREATOR MONITORING',
                  style: TextStyle(color: kTeal, fontWeight: FontWeight.w800, fontSize: 12)),
              const SizedBox(height: 6),
              const Text('See who is live, what they are earning, and who is moving fast.',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, height: 1.15)),
              const SizedBox(height: 8),
              const Text(
                  'GiftTok watches public TikTok Live creators and brings their status, viewer counts, gifts, and gift earnings into one easy board.',
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  StatTile('Tracked', fmt(b.tracked)),
                  StatTile('Online now', fmt(b.online)),
                  StatTile('Gift value / 24h', valueRange(b.valueMin, b.valueMax)),
                  StatTile('Gifts / 24h', fmt(b.gifts24h)),
                ],
              ),
              const SizedBox(height: 20),
              Panel(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SectionTitle('Top Revenue',
                    sub: 'Estimated gift earnings from the last 24 hours'),
                for (final c in b.topRevenue) CreatorTile(c),
              ])),
              Panel(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SectionTitle('Currently Online', sub: 'Sorted by live viewers'),
                for (final c in b.onlineSorted.take(15))
                  CreatorTile(c, showEarnings: false),
              ])),
              const Text('GiftTok is not affiliated with TikTok or ByteDance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45, fontSize: 12)),
            ]),
          );
        },
      );
}
