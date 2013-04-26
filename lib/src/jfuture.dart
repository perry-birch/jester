part of jester;

/// JFuture provides a wrapper around the standard Future library
/// Ostensibly the main purpose is to enable future extension
class JFuture<T> implements Future<T> {
  final Future<T> _future;

  const JFuture._(this._future);

  factory JFuture.wrap(Future<T> future) {
    return new JFuture._(future);
  }

  static final dynamic $ = (Future future) {
    return new JFuture.wrap(future);
  };

  factory JFuture(computation()) {
    return JFuture.$(new Future(computation));
  }

  factory JFuture.sync(computation()) {
    return JFuture.$(new Future.sync(computation));
  }

  factory JFuture.value([T value]) {
    return JFuture.$(new Future.value(value));
  }

  factory JFuture.error(var error, [Object stackTrace]) {
    return JFuture.$(new Future.error(error, stackTrace));
  }

  factory JFuture.delayed(Duration duration, [T computation()]) {
    return JFuture.$(new Future.delayed(duration, computation));
  }

  static JFuture<List> wait(Iterable<Future> futures) {
    return JFuture.$(Future.wait(futures));
  }

  static JFuture forEach(Iterable input, Future f(element)) {
    return JFuture.$(Future.forEach(input, f));
  }

  JFuture then(void onValue(T value), { void onError(Object error) }) {
    return $(_future.then(onValue, onError: onError));
  }

  JFuture catchError(void onError(Object error), { bool test(Object error) }) {
    return $(_future.catchError(onError, test: test));
  }

  JFuture<T> whenComplete(void action()) {
    return $(_future.whenComplete(action));
  }

  Stream<T> asStream() {
    return _future.asStream();
  }
}