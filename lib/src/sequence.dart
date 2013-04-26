part of jester;

typedef void Action<T>(T arg1);

abstract class Seq<T> {
  final Action<Action<T>> feed;

  factory Seq(Action<Action<T>> feed) => null;//new _Seq(feed);

  IDisposable sip(void next(T value));
}

class _Seq<T> implements Seq<T> {
  final Action<Action<T>> _feed;
  dynamic sipper = (T value) { };

  _Seq._(Action<Action<T>> _feed);

  factory _Seq(Action<Action<T>> feed) {
    return null;//new _Seq._(feed);
  }

  /*void _next(T value) {
    sipper(value);
  }*/

  IDisposable sip(void next(T value)) {
    sipper = next;
    return new Disposable();
  }
}

class SeqSubscription<T> implements IDisposable {
  final Action<T> observer;

  SeqSubscription._(Action<T> this.observer);

  factory SeqSubscription(Action<T> observer, Action<Action<T>> observableFactory) {
    SeqSubscription subscription = new SeqSubscription._(observer); // Create the subscription
    observableFactory(subscription._dispatcher); // Wire it to the dispatcher
    return subscription; // Return the subscription
  }

  void _dispatcher(T value) {
    observer(value);
  }
}

abstract class SeqSource<T> {
  factory SeqSource([Scheduler scheduler]) => new _SeqSource<T>(scheduler);

  Seq get sequence;
  void next(T value);
  void error(Object exception, [Object stackTrace]);
}

class _SeqSource<T> implements SeqSource<T> {
  final Scheduler _scheduler;
  final Seq _sequence;

  Seq get sequence => _sequence;

  _SeqSource._(Seq this._sequence, [Scheduler scheduler]) : _scheduler = scheduler != null ? scheduler : null;

  factory _SeqSource([Scheduler scheduler]) {
    Seq sequence = null;//new Seq(feeder);
    return new _SeqSource._(sequence, scheduler);
  }

  Action<T> feeder(Action<T> feed) {
    return feed;
  }

  void next(T value) {
    feeder(() { return value; });
    //sequence._next(value);
  }
}