part of jester;

typedef void ReceivePortCallback<T>(T arg, SendPort replyTo);

class SafeReceivePort implements ReceivePort, IDisposable {
  final StreamController<ReceivedMessage> _streamController = new StreamController<ReceivedMessage>();
  final ReceivePort _receivePort;
  ReceivePortCallback _customCallback = (dynamic message, SendPort replyTo) { }; // noop by default

  SafeReceivePort._(ReceivePort this._receivePort);

  factory SafeReceivePort([ReceivePort receivePort]) {
    return SafeReceivePort.create(receivePort);
  }

  static final dynamic create = ([ReceivePort receivePort]) {
    if(receivePort == null) {
      receivePort = new ReceivePort();
    }
    var safeReceivePort = new SafeReceivePort._(receivePort);
    receivePort.receive((dynamic message, SendPort replyTo) {
      safeReceivePort._customCallback(message, replyTo);
      safeReceivePort._streamController.add(new ReceivedMessage(message, replyTo));
    });
    return safeReceivePort;
  };

  Stream<ReceivedMessage> get messages => _streamController.stream;

  void receive(ReceivePortCallback callback) {
    if(callback == null) { throw new Exception('Invalid callback'); }
    _customCallback = callback;
  }

  void close() {
    _receivePort.close();
  }

  SendPort toSendPort() {
    return _receivePort.toSendPort();
  }

  void dispose() {
    _receivePort.close();
  }
}

