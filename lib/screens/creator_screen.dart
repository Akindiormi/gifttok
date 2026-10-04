import 'package:flutter/material.dart';
import '../main.dart';
import '../store.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class CreatorScreen extends StatelessWidget {
  final String handle;
  const CreatorScreen({super.key, required this.handle});

  Widget _grid(List<List<String>> items) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 2.4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [for (final i in items) StatTile(i[0], i[1])],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('@$handle')),
        body: FutureBuilder<Creator>(
          future: repo.fetchCreator(handle),
          builder: (_, s) {
            if (!s.hasData) {
              return const Center(child: CircularProgressIndicator(color: kTeal));
            }
            final c = s.data!;
            return ListView(padding: const EdgeInsets.all(16), children: [
              Row(children: [
                CircleAvatar(
                    radius: 30,
                    backgroundColor: c.isLive ? kTeal : kBorder,
                    child: Text(c.name.characters.first,
                        style: const TextStyle(color: Colors.white, fontSize: 22))),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  Text(c.isLive ? 'Live now' : 'Offline',
                      style: TextStyle(color: c.isLive ? kTeal : kMuted)),
                ])),
                ValueListenableBuilder<Set<String>>(
                  valueListenable: store.follows,
                  builder: (_, f, __) => FilledButton(
                    onPressed: () => store.toggleFollow(handle),
                    child: Text(f.contains(handle) ? 'Following' : 'Follow'),
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              const SectionTitle('Profile', sub: 'Public TikTok metadata'),
              _grid([
                ['Followers', fmt(c.followers)],
                ['Following', fmt(c.following)],
                ['Likes', fmt(c.likes)],
                ['Videos', fmt(c.videos)],
              ]),
              const SizedBox(height: 16),
              const SectionTitle('Live Now'),
              _grid([
                ['Viewers', fmt(c.viewers)],
                ['Live since', c.liveSince],
                ['Comments', fmt(c.comments)],
                ['Gifts', fmt(c.gifts)],
              ]),
              const SizedBox(height: 16),
              const SectionTitle('Last 24 Hours'),
              _grid([
                ['Streams', fmt(c.streams.length)],
                ['Peak viewers', fmt(c.peak)],
                ['Gifts', fmt(c.gifts)],
                ['Gift value', valueRange(c.valueMin, c.valueMax)],
              ]),
              const SizedBox(height: 16),
              const SectionTitle('Stream History', sub: 'Completed stream sessions'),
              Panel(
                  child: Column(children: [
                for (final st in c.streams)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(st.ended, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(
                        '${st.duration} - peak ${fmt(st.peak)} - ${fmt(st.gifts)} gifts'),
                    trailing: Text('GBP ${st.value.toInt()}'),
                  ),
              ])),
            ]);
          },
        ),
      );
}
