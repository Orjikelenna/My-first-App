import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AnimationPage());
  }
}

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  bool _expanded = false;
  bool _visible = true;
  bool _big = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animations'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: _expanded ? 300 : 100,
              height: _expanded ? 300 : 100,
              color: _expanded ? Colors.blue : Colors.red,
              child: const Center(
                child: Text('Tap me!', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: const Text('Expand / Shrink'),
            ),
            const SizedBox(height: 30),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _visible ? 1.0 : 0.0,
              child: const Text(
                'I can disappear!',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                });
              },
              child: const Text('Show / Hide'),
            ),
            const SizedBox(height: 30),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: _big ? 40 : 20,
                color: _big ? Colors.red : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              child: const Text('I change size!'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _big = !_big;
                });
              },
              child: const Text('Big / Small'),
            ),
          ],
        ),
      ),
    );
  }
}
