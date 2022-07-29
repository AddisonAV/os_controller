import 'package:get_it/get_it.dart';
import 'package:event_bus/event_bus.dart';

final GetIt getIt = GetIt.instance;

setupProviders() {
  getIt.registerSingleton<EventBus>(EventBus(sync: true));
}
