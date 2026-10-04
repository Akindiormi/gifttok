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
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
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
              color: kTeal.withOpacity(.2),
              borderRadius: BorderRadius.circular(8)),
          child: const Text('Beta',
              style: TextStyle(
                  fontSize: 11, color: kTeal, fontWeight: FontWeight.w700)),
        ),
      ]);
}

class PulseDot extends StatefulWidget {
  const PulseDot({super.key});
  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat(reverse: true);
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: Tween<double>(begin: .3, end: 1).animate(_c),
        child: Container(
            width: 8,
            height: 8,
            decoration:
                const BoxDecoration(color: kLive, shape: BoxShape.circle)),
      );
}

class Panel extends StatelessWidget {
  final Widget child;
  const Panel({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kBorder)),
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
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          if (sub != null)
            Text(sub!, style: const TextStyle(color: kMuted, fontSize: 13)),
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
            color: kCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kBorder)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(color: kMuted, fontSize: 12)),
              const SizedBox(height: 4),
              FittedBox(
                  child: Text(value,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800))),
            ]),
      );
}

class CreatorTile extends StatelessWidget {
  final Creator c;
  final bool showEarnings;
  final int? rank;
  const CreatorTile(this.c, {super.key, this.showEarnings = true, this.rank});
  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => CreatorScreen(handle: c.handle))),
        leading: Row(mainAxisSize: MainAxisSize.min, children: [
          if (rank != null)
            SizedBox(
                width: 22,
                child: Text('$rank',
                    style: const TextStyle(
                        color: kMuted, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: c.isLive ? kLive : Colors.transparent, width: 2)),
            child: CircleAvatar(
                backgroundColor: c.isLive ? kTeal : kBorder,
                child: Text(c.name.characters.first,
                    style: const TextStyle(color: Colors.white))),
          ),
        ]),
        title: Row(children: [
          Flexible(
              child: Text(c.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700))),
          if (c.isLive) ...[const SizedBox(width: 6), const PulseDot()],
        ]),
        subtitle: Text('@${c.handle}', style: const TextStyle(color: kMuted)),
        trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(c.isLive ? '${fmt(c.viewers)} viewers' : 'Offline',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: c.isLive ? kTeal : kMuted)),
              if (showEarnings)
                Text(valueRange(c.valueMin, c.valueMax),
                    style: const TextStyle(fontSize: 12, color: kMuted)),
            ]),
      );
}
