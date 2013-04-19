part of jester_test;

// TODO: Wrap receive port in List<Future> or stream
// Create actor directly in test to make calls easier!
class ReceivePortProxy {
  final ReceivePort receivePort;
  final SendPort sendPort;
  Completer _completer;
  dynamic _predicate;

  ReceivePortProxy._(this.receivePort, this.sendPort);

  static final dynamic wrap = (ReceivePort receivePort) {
    var proxy = new ReceivePortProxy._(receivePort, receivePort.toSendPort());
    receivePort.receive(proxy.receivePortHandler);
    return proxy;
  };

  Future<dynamic> where(dynamic predicate, {timeout: 100}) {
    if(_completer != null) {
      if(!_completer.isCompleted) {
        _completer.completeError('Predicate replaced');
      }
      _completer = null;
    }
    _completer = new Completer();
    _predicate = predicate;
    new Timer(new Duration(milliseconds:timeout), () {
      if(!_completer.isCompleted) {
        _completer.completeError('Timeout Expired');
      }
    });

    return _completer.future;
  }
  void receivePortHandler(dynamic message, SendPort replyTo) {
    if(_completer != null && _predicate != null && _predicate(message)) {
      if(_completer.isCompleted) { return; }
      _completer.complete(message);
    }
  }
}

