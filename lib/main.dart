import 'package:flutter/material.dart';

void main() {
  runApp(const GlobalDigitalKhataApp());
}

class GlobalDigitalKhataApp extends StatelessWidget {
  const GlobalDigitalKhataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Digital Khata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Deep Corporate Blue
          primary: const Color(0xFF1E3A8A),
        ),
        useMaterial3: true,
        // درست شدہ CardThemeData
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.all(8),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Digital Khata'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // درست شدہ Color اور Icon
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'گلوبل ڈیجیٹل کھاتہ میں خوش آمدید',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
