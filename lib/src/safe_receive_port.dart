part of jester;

class SafeReceivePort implements ReceivePort, IAsyncDisposable {
  final StreamController<ReceivedMessage> _streamController = new StreamController<ReceivedMessage>();
  final ReceivePort _receivePort;
  final AsyncDisposable _disposable;

  ReceivePortCallback _customCallback = (dynamic message, SendPort replyTo) { }; // noop by default

  SafeReceivePort._(ReceivePort this._receivePort, Disposable this._disposable);

  factory SafeReceivePort([ReceivePort receivePort]) {
    if(receivePort == null) {
      receivePort = new ReceivePort();
    }
    AsyncDisposable disposable = new AsyncDisposable(() => receivePort.close());
    var safeReceivePort = new SafeReceivePort._(receivePort, disposable);
    receivePort.receive((dynamic message, SendPort replyTo) {
      safeReceivePort._customCallback(message, replyTo);
      safeReceivePort._streamController.add(new ReceivedMessage(message, replyTo));
    });
    return safeReceivePort;
  }

  static final dynamic create = ([ReceivePort receivePort]) {
    return new SafeReceivePort(receivePort);
  };

  Stream<ReceivedMessage> get messages => _streamController.stream;

  void receive(ReceivePortCallback callback) {
    if(callback == null) { throw new Exception('Invalid callback'); }
    _customCallback = callback;
  }

  void close() {
    dispose();
    //_receivePort.close();
  }

  SendPort toSendPort() {
    return _receivePort.toSendPort();
  }

  // IFutureDisposable
  Future get disposed => _disposable.future;

  void dispose([dynamic value]) {
    _disposable.dispose();
    //_receivePort.close();
  }

  void disposeError(dynamic error) {
    _disposable.disposeError(error);
  }
}

