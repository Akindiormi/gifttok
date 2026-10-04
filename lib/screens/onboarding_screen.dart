import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../main.dart';
import '../store.dart';
import '../theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pc = PageController();
  final _name = TextEditingController();
  int _i = 0;

  void _go(int p) => _pc.animateToPage(p,
      duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

  Future<void> _saveName() async {
    await store.setName(_name.text.trim());
    _go(2);
  }

  void _finish() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const Shell()));

  Future<void> _telegram() => launchUrl(Uri.parse(kTelegramUrl),
      mode: LaunchMode.externalApplication);

  Widget _page(IconData icon, String title, String body, Widget action) =>
      Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                    colors: [kTeal, Color(0xFF0A6E7A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                boxShadow: [
                  BoxShadow(color: kTeal.withOpacity(.4), blurRadius: 30)
                ]),
            child: Icon(icon, size: 44, color: Colors.white),
          ),
          const SizedBox(height: 28),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Text(body,
              textAlign: TextAlign.center,
              style: const TextStyle(color: kMuted, fontSize: 15, height: 1.4)),
          const SizedBox(height: 28),
          action,
        ]),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(children: [
            Expanded(
              child: PageView(
                controller: _pc,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (v) => setState(() => _i = v),
                children: [
                  _page(
                    Icons.card_giftcard,
                    'Welcome to GiftTok',
                    'See who is live on TikTok, how many are watching, and who is earning the most gifts.',
                    SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                            onPressed: () => _go(1),
                            child: const Text('Get started'))),
                  ),
                  _page(
                    Icons.person_outline,
                    'What is your name?',
                    'No sign-up needed. We just save your name on this phone.',
                    Column(children: [
                      TextField(
                        controller: _name,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                            hintText: 'Your name',
                            filled: true,
                            fillColor: kCard,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none)),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                              onPressed: _name.text.trim().isEmpty
                                  ? null
                                  : _saveName,
                              child: const Text('Continue'))),
                    ]),
                  ),
                  _page(
                    Icons.send,
                    'Join our Telegram',
                    'Get updates, tips and news from the GiftTok community.',
                    Column(children: [
                      SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                              onPressed: _telegram,
                              icon: const Icon(Icons.send),
                              label: const Text('Join Telegram'))),
                      const SizedBox(height: 8),
                      TextButton(
                          onPressed: _finish,
                          child: const Text('Continue to app')),
                    ]),
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var d = 0; d < 3; d++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.all(4),
                  width: _i == d ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: _i == d ? kTeal : kBorder,
                      borderRadius: BorderRadius.circular(8)),
                ),
            ]),
            const SizedBox(height: 24),
          ]),
        ),
      );
}
