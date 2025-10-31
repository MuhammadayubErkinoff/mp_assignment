import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: ThemeScreen());
}

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});
  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _isDark = prefs.getBool('isDark') ?? false);
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', value);
    setState(() => _isDark = value);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: _isDark ? ThemeData.dark() : ThemeData.light(),
    home: Scaffold(
      appBar: AppBar(title: const Text('Dark Mode Toggle')),
      body: Center(
        child: SwitchListTile(
          title: const Text('Enable Dark Mode'),
          value: _isDark,
          onChanged: _toggleTheme,
        ),
      ),
    ),
  );
}