import 'core/di/service_locator.dart';
import 'main_common.dart';

Future<void> main() async {
  await mainCommon(Env.staging);
}
