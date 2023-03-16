import 'dart:isolate';

import 'package:integral_isolates/integral_isolates.dart';
import 'package:test/test.dart';

void main() {
  group('IsolateStream tests', () {
    final isolate = StatefulIsolate();

    test('Send different data types and expect answers', () async {
      expect(
        isolate.isolateStream(
          (_) => Stream.fromIterable([2, 3, 5, 42]),
          const Object(),
        ),
        emitsInOrder([2, 3, 5, 42]),
      );

      expect(
        isolate.isolateStream(
          (_) => Stream.fromFutures([
            Future.delayed(const Duration(milliseconds: 100), () => 'are'),
            Future.value('Async calls'),
            Future.delayed(
              const Duration(milliseconds: 200),
              () => 'difficult',
            ),
          ]),
          const Object(),
        ),
        emitsInOrder(['Async calls', 'are', 'difficult']),
      );
    });

    test('Send unsupported data type should throw exception', () async {
      expect(
        isolate.isolateStream(
          (_) => Stream.fromIterable([2, 3, 5, 42]),
          const Object(),
        ),
        emitsInOrder([2, 3, 5, 42]),
      );

      await expectLater(
        isolate.isolateStream(
          (_) => Stream.fromIterable([2, 3, 5, 42]),
          ReceivePort(),
        ),
        throwsArgumentError,
      );

      expect(
        await isolate.isolate((number) => number + 2, 5),
        equals(7),
      );
    });

    test('Trying to return unsupported data type should throw exception',
        () async {
      expect(
        await isolate.isolate((number) => number + 8, 1),
        equals(9),
      );

      await expectLater(
        isolate.isolateStream(
          (_) => ReceivePort(),
          'Test String',
        ),
        throwsArgumentError,
      );

      expect(
        isolate.isolateStream(
          (_) => Stream.fromIterable([2, 3, 5, 42]),
          const Object(),
        ),
        emitsInOrder([2, 3, 5, 42]),
      );
    });

    tearDownAll(isolate.dispose);
  });

  group('Tailored IsolateStream tests', () {
    final isolated = TailoredStatefulIsolate<int, int>();
    final isolate = isolated.isolate;

    test('Send different data types and expect answers', () async {
      expect(
        await isolate((number) => number + 2, 1),
        equals(3),
      );
    });

    tearDownAll(isolated.dispose);
  });
}
