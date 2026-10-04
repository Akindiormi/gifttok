import 'package:flutter/material.dart';
import 'repository.dart';
import 'store.dart';
import 'theme.dart';
import 'widgets.dart';
import 'screens/home_screen.dart';
import 'screens/creators_screen.dart';
import 'screens/gifts_screen.dart';
import 'screens/me_screen.dart';
import 'screens/onboarding_screen.dart';

/// Replace with your real backend implementation later.
final GiftTokRepository repo = MockRepository();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await store.init();
  runApp(const GiftTokApp());
}

class GiftTokApp extends StatelessWidget {
  const GiftTokApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'GiftTok',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: store.onboarded ? const Shell() : const OnboardingScreen(),
      );
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 0;
  static const pages = [
    HomeScreen(),
    CreatorsScreen(),
    GiftsScreen(),
    MeScreen()
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Logo()),
        body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: KeyedSubtree(key: ValueKey(i), child: pages[i])),
        bottomNavigationBar: NavigationBar(
          selectedIndex: i,
          onDestinationSelected: (v) => setState(() => i = v),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.dashboard_outlined), label: 'Live board'),
            NavigationDestination(
                icon: Icon(Icons.people_outline), label: 'Creators'),
            NavigationDestination(
                icon: Icon(Icons.card_giftcard), label: 'Gifts'),
            NavigationDestination(
                icon: Icon(Icons.person_outline), label: 'Me'),
          ],
        ),
      );
}
