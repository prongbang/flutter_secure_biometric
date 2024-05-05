import 'package:flutter_secure_biometric/server/biometric_server.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth_crypto/local_auth_crypto.dart';

class BiometricClient {
  final BiometricServer _biometricServer;
  final LocalAuthCrypto _localAuthCrypto;
  final FlutterSecureStorage _flutterSecureStorage;

  BiometricClient(
    this._biometricServer,
    this._localAuthCrypto,
    this._flutterSecureStorage,
  );

  final String _key = '018f4476-ed8f-7754-81f3-75b9eec18008';

  void canEvaluatePolicy() async {
    final status = await _localAuthCrypto
        .evaluatePolicy('Allow biometric to authenticate');
    print('status: $status');
  }

  Future<void> createPin() async {
    final response = await _biometricServer.createPin('123456');
    print('uuid: ${response.uuid}');
    print('pin-token: ${response.pinToken}');
    print('access-token: ${response.accessToken}');

    // Encrypt pin token
    final pinTokenEncrypted = await _localAuthCrypto.encrypt(response.pinToken);

    // Save pin token encrypted to secure storage
    await _flutterSecureStorage.write(key: _key, value: pinTokenEncrypted);
  }

  Future<void> biometricAuth() async {
    // Get pin token encrypted from secure storage
    final pinTokenEncrypted = await _flutterSecureStorage.read(key: _key) ?? '';

    // Decrypt by biometric authentication
    final promptInfo = BiometricPromptInfo(
      title: 'BIOMETRIC',
      subtitle: 'Please scan biometric to decrypt',
      negativeButton: 'CANCEL',
    );
    final pinToken =
        await _localAuthCrypto.authenticate(promptInfo, pinTokenEncrypted);

    // Auth with pin token
    const uuid = '018f446a-c2f1-7804-9867-aa003559f996';
    final response = await _biometricServer.biometricAuth(uuid, pinToken ?? '');
    print('uuid: ${response.uuid}');
    print('pin-token: ${response.pinToken}');
    print('access-token: ${response.accessToken}');

    // Encrypt pin token
    final newPinTokenEncrypted =
        await _localAuthCrypto.encrypt(response.pinToken);

    // Save pin token encrypted to secure storage
    await _flutterSecureStorage.write(key: _key, value: newPinTokenEncrypted);
  }
}
