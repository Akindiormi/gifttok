import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../main.dart';
import '../models.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  void _rename(BuildContext context) {
    final ctl = TextEditingController(text: store.name.value);
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Your name'),
              content: TextField(controller: ctl, autofocus: true),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                FilledButton(
                    onPressed: () {
                      if (ctl.text.trim().isNotEmpty) {
                        store.setName(ctl.text.trim());
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Save')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ValueListenableBuilder<String?>(
              valueListenable: store.name,
              builder: (_, n, __) => Panel(
                  child: Row(children: [
                CircleAvatar(
                    radius: 28,
                    backgroundColor: kTeal,
                    child: Text((n ?? '?').characters.first.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 24, color: Colors.white))),
                const SizedBox(width: 14),
                Expanded(
                    child: Text(n ?? '',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800))),
                IconButton(
                    onPressed: () => _rename(context),
                    icon: const Icon(Icons.edit_outlined)),
              ])),
            ),
            Panel(
                child: Column(children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.send, color: kTeal),
                title: const Text('Join our Telegram'),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => launchUrl(Uri.parse(kTelegramUrl),
                    mode: LaunchMode.externalApplication),
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.notifications_none, color: kMuted),
                title: Text('Live alerts'),
                subtitle: Text('Coming soon'),
              ),
            ])),
            const SectionTitle('Following'),
            ValueListenableBuilder<Set<String>>(
              valueListenable: store.follows,
              builder: (_, f, __) => FutureBuilder<BoardSnapshot>(
                future: repo.fetchBoard(),
                builder: (_, s) {
                  if (!s.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(color: kTeal));
                  }
                  final list =
                      s.data!.creators.where((c) => f.contains(c.handle)).toList();
                  if (list.isEmpty) {
                    return const Panel(
                        child: Text('You are not following anyone yet.',
                            style: TextStyle(color: kMuted)));
                  }
                  return Panel(
                      child: Column(
                          children: [for (final c in list) CreatorTile(c)]));
                },
              ),
            ),
          ]);
}
