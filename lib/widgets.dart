import 'package:flutter/material.dart';
import 'models.dart';
import 'theme.dart';
import 'screens/creator_screen.dart';

String fmt(num? n) {
  if (n == null) return '-';
  final s = n.toInt().toString();
  return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}

String valueRange(double a, double b) => 'GBP ${a.toInt()}-${b.toInt()}';

class Logo extends StatelessWidget {
  const Logo({super.key});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Image.asset('assets/brand/gifttok-mark.png',
            height: 28,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.card_giftcard, color: kTeal)),
        const SizedBox(width: 8),
        const Text('GiftTok', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
              color: kTeal.withOpacity(.15),
              borderRadius: BorderRadius.circular(8)),
          child: const Text('Beta',
              style: TextStyle(fontSize: 11, color: kTeal, fontWeight: FontWeight.w700)),
        ),
      ]);
}

class Panel extends StatelessWidget {
  final Widget child;
  const Panel({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3F0F0))),
        child: child,
      );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? sub;
  const SectionTitle(this.title, {super.key, this.sub});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          if (sub != null)
            Text(sub!, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        ]),
      );
}

class StatTile extends StatelessWidget {
  final String label, value;
  const StatTile(this.label, this.value, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE3F0F0))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 4),
          FittedBox(
              child: Text(value,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
        ]),
      );
}

class CreatorTile extends StatelessWidget {
  final Creator c;
  final bool showEarnings;
  const CreatorTile(this.c, {super.key, this.showEarnings = true});
  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => CreatorScreen(handle: c.handle))),
        leading: CircleAvatar(
            backgroundColor: c.isLive ? kTeal : Colors.grey.shade300,
            child: Text(c.name.characters.first,
                style: const TextStyle(color: Colors.white))),
        title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('@${c.handle}'),
        trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(c.isLive ? '${fmt(c.viewers)} viewers' : 'Offline',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: c.isLive ? kTeal : Colors.black45)),
              if (showEarnings)
                Text(valueRange(c.valueMin, c.valueMax),
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ]),
      );
}
