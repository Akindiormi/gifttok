import 'package:flutter/material.dart';
import 'repository.dart';
import 'theme.dart';
import 'widgets.dart';
import 'screens/home_screen.dart';
import 'screens/creators_screen.dart';
import 'screens/gifts_screen.dart';

/// Replace with your real backend implementation.
final GiftTokRepository repo = MockRepository();

/// In-memory follows. Persist + sync with your backend later.
final ValueNotifier<Set<String>> follows = ValueNotifier({});

void main() => runApp(const GiftTokApp());

class GiftTokApp extends StatelessWidget {
  const GiftTokApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'GiftTok',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const Shell(),
      );
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 0;
  static const pages = [HomeScreen(), CreatorsScreen(), GiftsScreen()];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Logo()),
        body: pages[i],
        bottomNavigationBar: NavigationBar(
          selectedIndex: i,
          onDestinationSelected: (v) => setState(() => i = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Live board'),
            NavigationDestination(icon: Icon(Icons.people_outline), label: 'Creators'),
            NavigationDestination(icon: Icon(Icons.card_giftcard), label: 'Gifts'),
          ],
        ),
      );
}
