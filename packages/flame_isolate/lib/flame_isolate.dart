library flame_isolate;

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:integral_isolates/integral_isolates.dart';

/// Mixin on [Component] that holds an instance of a long running isolate using
/// the library integral_isolates.
///
/// Using isolate is done by just running [isolate] function the same way you
/// would run Flutter's compute function.
///
/// The following is an example of running a world update cycle when enough time
/// has passed.
///
/// class MyGame extends FlameGame with FlameIsolate {
///   @override
///   void update(double dt) {
///     if (shouldRecalculate) {
///       isolate(recalculateWorld, worldData).then(updateWorld);
///     }
///     return super.update(dt);
///   }
/// }
mixin FlameIsolate on Component implements IsolateGetter {
  final _isolate = Isolated();

  @override
  Future onMount() async {
    _isolate.init();
    return super.onMount();
  }

  @override
  void onRemove() {
    _isolate.dispose();
  }

  @override
  Future<R> isolate<Q, R>(
    ComputeCallback<Q, R> callback,
    Q message, {
    String? debugLabel,
  }) =>
      _isolate.isolate(callback, message, debugLabel: debugLabel);
}
