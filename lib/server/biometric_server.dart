import 'dart:convert';

import 'package:flutter_secure_biometric/server/model/access_token.dart';
import 'package:uuid/uuid.dart';

class BiometricServer {
  String _pinToken = '';
  final String _uuid = '018f446a-c2f1-7804-9867-aa003559f996';
  final _accessToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

  Future<AccessToken> createPin(String pin) async {
    // Simple validate
    if (pin == '123456') {
      // Simple generate pin token
      _pinToken = base64.encode(utf8.encode(const Uuid().v7()));

      return AccessToken(_uuid, _pinToken, _accessToken);
    }

    throw Exception('Pin not match');
  }

  Future<AccessToken> biometricAuth(String uuid, String pinToken) async {
    // Simple validate
    if (_pinToken == pinToken && _uuid == uuid) {
      // Simple generate pin token
      _pinToken = base64.encode(utf8.encode(const Uuid().v7()));

      return AccessToken(_uuid, _pinToken, _accessToken);
    }

    throw Exception('Pin token mot match');
  }
}
