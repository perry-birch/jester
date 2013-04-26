part of jester;

// TODO: Move this to another library
// Disposable
typedef void UsingFunction(IDisposable target);
typedef Future<T> UsingAsyncFunction<T>(IDisposable target);
typedef Future<T> UsingAsync<T>(IDisposable target, UsingAsyncFunction<T> func);
//typedef void DisposableCallback([dynamic value]);

/// Marks a class which contains references that should be cleaned up after their use
abstract class IDisposable {
  void dispose([dynamic value]); // Triggers cleanup on the target disposable
}

abstract class IFutureDisposable implements IDisposable {
  void disposeError(dynamic error); // Triggers cleanup on the target disposable and passes the error to the Future listener
  Future get disposed;
}

/// Provides a stand-alone implementation of ensuring clean-up callback which doesn't require sub classing
class Disposable implements IFutureDisposable {
  static dynamic noop = () { };
  static dynamic noop1 = (dynamic value) { };
  final dynamic _callback;
  final dynamic _onData;
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;
  Completer _onDispose = new Completer();
  Future get disposed => _onDispose.future;

  Disposable._([dynamic callback(), dynamic onData(dynamic value)])
    : this._callback = callback != null ? callback : Disposable.noop,
        this._onData = onData != null ? onData : Disposable.noop1;

  /*
   * Creates a disposable instance which triggers (if provided) the supplied callback, potentially with a completing value
   */
  factory Disposable([dynamic callback(), dynamic onData(dynamic value)]) {
    return new Disposable._(callback, onData);
  }

  /*
   * Triggers the cleanup callback provided to the disposable
   * Dispose cannot be called multiple times on the same instance
   */
  void dispose([dynamic value]) {
    if(_isDisposed) { return; }
    _isDisposed = true;
    _callback();
    if(value != null) {
      _onData(value);
    }
    _onDispose.complete(value);
  }

  void disposeError(dynamic error) {
    if(_isDisposed) { return; }
    _isDisposed = true;
    _callback(error);
    _onDispose.completeError(error);
  }
}

/// Provides a stand-alone implementation of ensuring a batch of disposable instances are all cleaned-up
class CompositeDisposable implements IFutureDisposable {
  final List<IDisposable> _disposables;
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  CompositeDisposable._(Iterable<IDisposable> this._disposables);

  /// Instantiates a composite which immediately wraps the provided set of disposables
  factory CompositeDisposable.fromDisposables(Iterable<IDisposable> disposables) {
    return new CompositeDisposable._(disposables);
  }

  /// Instantiates a composite which has no implicit set of disposables
  factory CompositeDisposable.empty() {
    return new CompositeDisposable._([]);
  }

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
Future usingAsync(IFutureDisposable disposable, UsingAsyncFunction func) {
  return func(disposable).then(
      (value) {
        disposable.dispose(value);
        return disposable.disposed;
      },
      onError: (error) {
        disposable.disposeError(error);
        return disposable.disposed;
      });
}