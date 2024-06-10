import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/ValueManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValueScreen extends StatefulWidget{
  const ValueScreen({super.key});

  @override
  _ValueScreen createState() => _ValueScreen();
}

class _ValueScreen extends State<ValueScreen> {
  final ValueManager _valueManager = ValueManager();
  String? _value;
  Timer? _timer;
  Duration _countdown = const Duration(hours: 3);
  int? _timestamp;

  @override
  void initState() {
    super.initState();
    _loadValue();
  }

  Future<void> _loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    _timestamp = prefs.getInt(ValueManager.nilai);
    final value = await _valueManager.getValue();
    setState(() {
      _value = value;
      if (_timestamp != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final elapsed = now - _timestamp!;
        final remainingTime = const Duration(minutes: 5) - Duration(milliseconds: elapsed);
        if (remainingTime.isNegative) {
          _countdown = Duration.zero;
        } else {
          _countdown = remainingTime;
          _startCountdownTimer();
        }
      }
    });
  }

  void _startCountdownTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown.inSeconds > 0) {
          _countdown = _countdown - const Duration(seconds: 1);
        } else {
          _timer?.cancel();
          _checkValue();
        }
      });
    });
  }

  Future<void> _checkValue() async {
    final value = await _valueManager.getValue();
    setState(() {
      _value = value;
    });
  }

  Future<void> _saveValue() async {
    await _valueManager.saveValue("Hello, World!");
    _loadValue();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Value Manager')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_value ?? 'No value saved.'),
            const SizedBox(height: 20),
            Text('Time remaining: ${_countdown.inHours}:${(_countdown.inMinutes % 60).toString().padLeft(2, '0')}:${(_countdown.inSeconds % 60).toString().padLeft(2, '0')}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveValue,
              child: const Text('Save Value'),
            ),
          ],
        ),
      ),
    );
  }
}