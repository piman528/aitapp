import 'package:aitapp/infrastructure/secure_storage.dart';

Future<void> logIn() async {
  await SecureStorage.instance.write(key: 'id', value: 'aaaaaa');
  await SecureStorage.instance.write(key: 'password', value: 'aaaaaa');
}
