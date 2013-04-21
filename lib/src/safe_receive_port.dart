part of jester;

typedef void ReceivePortCallback<T1, T2>(T1 arg1, T2 arg2);

class SafeReceivePort implements ReceivePort, IDisposable {
  final StreamController<ReceivedMessage> _streamController = new StreamController<ReceivedMessage>();
  final ReceivePort _receivePort;
  ReceivePortCallback _customCallback = null;

  SafeReceivePort._(ReceivePort this._receivePort);

  factory SafeReceivePort([ReceivePort receivePort]) {
    if(receivePort == null) {
      receivePort = new ReceivePort();
    }
    var safeReceivePort = new SafeReceivePort._(receivePort);
    receivePort.receive((dynamic message, SendPort replyTo) {
      safeReceivePort._streamController.add(new ReceivedMessage(message, replyTo));
      if(safeReceivePort._customCallback == null) { return; }
      safeReceivePort._customCallback(message, replyTo);
    });
    return safeReceivePort;
  }

  void receive(ReceivePortCallback callback) {
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

