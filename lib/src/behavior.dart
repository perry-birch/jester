part of jester;

class Behavior {
  List<MessageTypes> _keys;
  List<MessageHandler> _handlers;

  Behavior(List<BehaviorHandler> handlers) {
    _keys = new List<MessageTypes>(handlers.length);
    _handlers = new List<MessageHandler>(handlers.length);
    for(var i = 0; i < handlers.length; i++) {
      _keys[i] = handlers[i].messageType;
      _handlers[i] = handlers[i].messageHandler;
    }
  }

  bool contains(MessageTypes messageType) {
    return _keys.contains(messageType);
  }

  operator [](MessageTypes messageType) {
    return _handlers[_keys.indexOf(messageType)];
  }
}

class BehaviorHandler {
  final MessageTypes messageType;
  final MessageHandler messageHandler;

  BehaviorHandler(MessageTypes this.messageType, MessageHandler this.messageHandler);
}