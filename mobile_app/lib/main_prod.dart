import 'package:access_control/core/main.dart' as runner show main;
import 'package:access_control/flavors.dart';

Future<void> main() async {
  Flavors.appFlavor = FlavorOption.prod;
  await runner.main();
}
