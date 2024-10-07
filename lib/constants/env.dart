part of 'constants.dart';

@Envied(path: '.env', useConstantCase: true)
abstract class Env {
  @EnviedField(varName: 'appName')
  static const String appName = _Env.appName;

  @EnviedField(varName: 'aria2cSecret')
  static const String aria2cSecret = _Env.aria2cSecret;
}
