import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Saves the user's name and follows on the phone. No server needed.
class AppStore {
  late SharedPreferences _p;
  final ValueNotifier<String?> name = ValueNotifier(null);
  final ValueNotifier<Set<String>> follows = ValueNotifier({});

  bool get onboarded => (name.value ?? '').isNotEmpty;

  Future<void> init() async {
    _p = await SharedPreferences.getInstance();
    name.value = _p.getString('name');
    follows.value = (_p.getStringList('follows') ?? []).toSet();
  }

  Future<void> setName(String n) async {
    await _p.setString('name', n);
    name.value = n;
  }

  void toggleFollow(String handle) {
    final next = {...follows.value};
    next.contains(handle) ? next.remove(handle) : next.add(handle);
    follows.value = next;
    _p.setStringList('follows', next.toList());
  }
}

final store = AppStore();
