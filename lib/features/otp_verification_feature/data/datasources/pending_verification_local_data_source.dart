import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/pending_verification_model.dart';

abstract class PendingVerificationLocalDataSource {
  PendingVerificationModel? read();
  Future<void> save(PendingVerificationModel pending);
  Future<void> clear();
}

class PendingVerificationLocalDataSourceImpl
    implements PendingVerificationLocalDataSource {
  PendingVerificationLocalDataSourceImpl(this._prefs);

  static const String _key = 'otp.pending_verification';

  final SharedPreferences _prefs;

  @override
  PendingVerificationModel? read() {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    return PendingVerificationModel.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> save(PendingVerificationModel pending) async {
    await _prefs.setString(_key, jsonEncode(pending.toJson()));
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}
