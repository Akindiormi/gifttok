import 'package:flutter/material.dart';
import '../main.dart';
import '../store.dart';
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                        colors: [kTeal, Color(0xFF0A6E7A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    boxShadow: [
                      BoxShadow(color: kTeal.withOpacity(.3), blurRadius: 24)
                    ]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ValueListenableBuilder<String?>(
                    valueListenable: store.name,
                    builder: (_, n, __) => Text('Hi, ${n ?? ''}',
                        style: const TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 6),
                  const Text('See who is live and who is earning.',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                          color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text(
                      'Live status, viewers and gift earnings of public TikTok Live creators in one place.',
                      style: TextStyle(color: Colors.white70)),
                ]),
              ),
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
                for (var i = 0; i < b.topRevenue.length; i++)
                  CreatorTile(b.topRevenue[i], rank: i + 1),
              ])),
              Panel(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SectionTitle('Currently Online', sub: 'Sorted by live viewers'),
                for (final c in b.onlineSorted.take(15))
                  CreatorTile(c, showEarnings: false),
              ])),
              const Text('GiftTok is not affiliated with TikTok or ByteDance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kMuted, fontSize: 12)),
            ]),
          );
        },
      );
}
