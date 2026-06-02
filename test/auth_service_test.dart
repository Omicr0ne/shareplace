import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/features/auth/data/auth_service.dart';

void main() {
  test('exposes authentication service from auth feature', () {
    expect(AuthService, isNotNull);
  });
}
