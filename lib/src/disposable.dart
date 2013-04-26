part of jester;

// TODO: Move this to another library

/// Marks a class which contains references that should be cleaned up after their use
abstract class IDisposable {
  void dispose(); // Triggers cleanup on the target disposable
  void disposeWith(dynamic value); // Triggers cleanup on the target disposable and passes the value to the Future listener
  Future onDispose;
}

/// Provides a stand-alone implementation of ensuring clean-up callback which doesn't require sub classing
class Disposable implements IDisposable {
  final DisposableCallback _callback;
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;
  Completer _onDispose = new Completer();
  Future get onDispose => _onDispose.future;

  Disposable._(DisposableCallback this._callback);

  static final dynamic create = ([DisposableCallback callback]) {
    if(callback == null) { callback = () { }; }
    return new Disposable._(callback);
  };

  /// Dispose cannot be called multiple times on the same instance
  void dispose() {
    if(_isDisposed) { return; }
    _isDisposed = true;
    _callback();
    _onDispose.complete();
  }
}

/// Provides a stand-alone implementation of ensuring a batch of disposable instances are all cleaned-up
class CompositeDisposable implements IDisposable {
  final List<IDisposable> _disposables;
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  CompositeDisposable._(Iterable<IDisposable> this._disposables);

  /// Instantiates a composite which immediately wraps the provided set of disposables
  static final dynamic fromDisposables = (Iterable<IDisposable> disposables) {
    return new CompositeDisposable._(disposables);
  };

  /// Instantiates a composite which has no implicit set of disposables
  static final dynamic empty = () {
    return new CompositeDisposable._([]);
  };

  /// Appends a disposable instance into the set controlled by this composite
  void add(IDisposable disposable) {
    if(_isDisposed) { disposable.dispose(); }
    _disposables.add(disposable);
  }

  /// Removes and also disposes the item removed immediately
  void remove(IDisposable disposable) {
    if(!_disposables.contains(disposable)) { return; }
    int index = _disposables.indexOf(disposable);
    _disposables[index].dispose();
    _disposables.removeAt(index);
  }

  /// Checks for the presence of a disposable instance in the composite set
  bool contains(IDisposable disposable) {
    if(_isDisposed) { return false; }
    return _disposables.contains(disposable);
  }

  /// Triggers disposal of all contained elements and removes them from the composite set
  /// Does not mark the composite set as disposed allowing it to be subsequently disposed at a later point
  void clear() {
    _disposables.forEach((_) => _.dispose());
    _disposables.clear();
  }

  /// Triggers disposal of all contained elements and removes them from the composite set
  /// Also marks the composite set as disposed which disables future dispose calls
  void dispose() {
    if(_isDisposed) { return; }
    _isDisposed = true;
    clear();
  }
}

// TODO: Implement RefCountDisposable - https://github.com/Reactive-Extensions/RxJS/blob/master/rx.js
// TODO: Implement ScheduledDisposable - https://github.com/Reactive-Extensions/RxJS/blob/master/rx.js

/// Provides a method of encapsulating a series of actions which ensure proper disposal of
/// the disposable instance prior to exiting
void using(IDisposable disposable, UsingFunction func) {
  func(disposable);
  disposable.dispose();
}

/// Provides a method of encapsulating a series of actions which ensure proper disposal of
/// the disposable instance prior to exiting but following the completion of a Future value
/// which is expected to be emitted from the contained code block
Future usingAsync(IDisposable disposable, UsingAsyncFunction func) {
  Future future = func(disposable);
  future.then((dynamic ignored) {
    disposable.dispose();
  });
  return future;
}