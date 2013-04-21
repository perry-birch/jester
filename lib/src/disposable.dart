part of jester;

abstract class IDisposable {
  void dispose();
}

void using(IDisposable disposable, UsingFunction func) {
  func(disposable);
  disposable.dispose();
}

Future usingAsync(IDisposable disposable, UsingAsyncFunction func) {
  Future future = func(disposable);
  future.then((dynamic ignored) {
    disposable.dispose();
  });
  return future;
}