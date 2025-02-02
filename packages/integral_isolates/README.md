Easy to use isolates for Dart and Flutter.

## Usage

Almost as easy to use as [compute](https://api.flutter.dev/flutter/foundation/compute-constant.html),
but using a long lived isolate. For example:

```dart
void main() async {
  final statefulIsolate = StatefulIsolate();
  final computation = statefulIsolate.isolate;
  print(await computation(_isPrime, 7));
  print(await computation(_isPrime, 42));
  statefulIsolate.dispose();
}

bool _isPrime(int value) {
  if (value == 1) {
    return false;
  }
  for (int i = 2; i < value; ++i) {
    if (value % i == 0) {
      return false;
    }
  }
  return true;
}
```

Remember to always dispose once you are done using the isolate to clean up and close the isolate.
```dart
isolated.dispose();
```

Different backpressure strategies are also supported by just sending in the desired strategy:
```dart
Isolated(backpressureStrategy: DiscardNewBackPressureStrategy());
```

Currently supported strategies can be found in the
[documentation](https://pub.dev/documentation/integral_isolates/latest/integral_isolates/BackpressureStrategy-class.html).


## Additional information

The API of this package is not final, and is subject to change.

### Breaking change

* `integral_isolates` v0.4.0: deprecated the class `Isolated` in favor of `StatefulIsolate`. The class
`TailoredStatefulIsolate` was also added, adding support for an isolate that allows for specifying input and output
types.

### Are you using hooks?

Try the [use_isolate](https://pub.dev/packages/use_isolate) package that controls the lifecycle of
the isolate, so you don't have to.
