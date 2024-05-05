import 'package:flutter/material.dart';
import 'package:flutter_secure_biometric/client/biometric_client.dart';
import 'package:flutter_secure_biometric/server/biometric_server.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth_crypto/local_auth_crypto.dart';
import 'package:pin_keyboard/pin_keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Biometric Crypto'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _biometricClient = BiometricClient(
    BiometricServer(),
    LocalAuthCrypto.instance,
    const FlutterSecureStorage(),
  );

  @override
  void initState() {
    _biometricClient.canEvaluatePolicy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _createPin,
              child: const Text('[1] Create PIN'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: PinKeyboard(
                length: 4,
                enableBiometric: true,
                iconBiometricColor: Colors.blue[400],
                onChange: (pin) {},
                onConfirm: (pin) {},
                onBiometric: _biometricAuth,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createPin() async {
    try {
      await _biometricClient.createPin();
      showMessageDialog('Success', 'Create Pin Successfully');
    } catch (e) {
      showMessageDialog('WHOOPS!', '$e');
    }
  }

  void _biometricAuth() async {
    try {
      await _biometricClient.biometricAuth();
      showMessageDialog('Success', 'Biometric Auth Successfully');
    } catch (e) {
      showMessageDialog('WHOOPS!', '$e');
    }
  }

  void showMessageDialog(String title, String message) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
