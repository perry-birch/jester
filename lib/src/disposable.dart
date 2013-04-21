part of jester;

abstract class IDisposable {
  void dispose();
}
typedef void UsingFunction(IDisposable target);
typedef Future<IDisposable> UsingAsyncFunction(IDisposable target);

void using(IDisposable disposable, UsingFunction func) {
  func(disposable);
  disposable.dispose();
}

void usingAsync(IDisposable disposable, UsingAsyncFunction func) {
  Future<IDisposable> future = func(disposable);
  future.then((IDisposable target) {
    target.dispose();
  });
}