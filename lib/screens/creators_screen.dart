import 'package:flutter/material.dart';
import '../main.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class CreatorsScreen extends StatefulWidget {
  const CreatorsScreen({super.key});
  @override
  State<CreatorsScreen> createState() => _CreatorsScreenState();
}

class _CreatorsScreenState extends State<CreatorsScreen> {
  final _q = TextEditingController();
  late final Future<BoardSnapshot> _f = repo.fetchBoard();

  void _submit() {
    final ctl = TextEditingController();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Submit streamer'),
              content: TextField(
                  controller: ctl,
                  decoration: const InputDecoration(hintText: '@handle')),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                FilledButton(
                    onPressed: () {
                      repo.submitStreamer(ctl.text.trim());
                      Navigator.pop(context);
                    },
                    child: const Text('Send')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<BoardSnapshot>(
        future: _f,
        builder: (context, s) {
          if (!s.hasData) {
            return const Center(child: CircularProgressIndicator(color: kTeal));
          }
          final q = _q.text.toLowerCase();
          final list = s.data!.creators
              .where((c) =>
                  c.name.toLowerCase().contains(q) || c.handle.toLowerCase().contains(q))
              .toList();
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(children: [
                Expanded(
                    child: TextField(
                  controller: _q,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                      hintText: 'Search creators',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none)),
                )),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                    onPressed: _submit, icon: const Icon(Icons.person_add_alt_1)),
              ]),
            ),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: list.length,
                    itemBuilder: (_, i) => CreatorTile(list[i]))),
          ]);
        },
      );
}
