import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: 'env/.env')
abstract class Env {
  @EnviedField(varName: 'BLOWFISHKEY', obfuscate: true)
  static final String blowfishKey = _Env.blowfishKey;
}
