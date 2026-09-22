import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: Scaffold(body: Center(
    child: Text('Reproducing Flutter #193097 — see console output.'),
  ))));
  const target = BasicMessageChannel<String>('repro/nil-handler', StringCodec());
  final baseline = await target.send('before registration');
  debugPrint('REPRO: never-registered channel returned $baseline (expected null)');
  await const MethodChannel('repro/control').invokeMethod<void>('unregister');
  debugPrint('REPRO: sending ping after native unregister acknowledgement');
  // === should crash here ===
  final response = await target.send('ping');
  debugPrint('REPRO: survived; response=$response (expected null)');
}
