import 'package:flutter/material.dart';
import '../main.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class GiftsScreen extends StatefulWidget {
  const GiftsScreen({super.key});
  @override
  State<GiftsScreen> createState() => _GiftsScreenState();
}

class _GiftsScreenState extends State<GiftsScreen> {
  String range = '24h';
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
        const SectionTitle('Gift Leaders', sub: 'Rolling window'),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: '24h', label: Text('24h')),
            ButtonSegment(value: '7d', label: Text('7d')),
            ButtonSegment(value: '30d', label: Text('30d')),
          ],
          selected: {range},
          onSelectionChanged: (v) => setState(() => range = v.first),
        ),
        const SizedBox(height: 14),
        FutureBuilder<List<GiftStat>>(
          key: ValueKey(range),
          future: repo.fetchGiftLeaders(range),
          builder: (_, s) => !s.hasData
              ? const Center(child: CircularProgressIndicator(color: kTeal))
              : Panel(
                  child: Column(children: [
                  for (final g in s.data!)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: g.iconUrl.isEmpty
                          ? const Icon(Icons.card_giftcard, color: kTeal)
                          : Image.network(g.iconUrl, width: 36),
                      title: Text(g.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${fmt(g.coins)} coins'),
                      trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${fmt(g.given)} given',
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(valueRange(0, g.value),
                                style: const TextStyle(fontSize: 12, color: Colors.black54)),
                          ]),
                    ),
                ])),
        ),
      ]);
}
