part of actor;

class MessageTypes {
  final String key;
  const MessageTypes._(this.key);
  const MessageTypes(String scope, String description)
      : this._('${scope}__${description}');
  String toString() => key;
  operator |(MessageHandler messageHandler) {
    return new BehaviorHandler(this, messageHandler);
  }
  operator ==(MessageTypes other) => this.key == other.key;
}

class CommandTypes extends MessageTypes {
  const CommandTypes(String scope, String description)
  : super(scope, description);
}

class EventTypes extends MessageTypes {
  const EventTypes(String scope, String description)
  : super(scope, description);
}

class Message {
  final MessageTypes type;
  final dynamic data;

  const Message._(this.type, [this.data = null]);

  static final dynamic create = (MessageTypes type, [dynamic data]) {
    return new Message._(type, data);
  };
}

class Command extends Message {
  const Command._(CommandTypes type, [dynamic data]) : super._(type, data);

  static final dynamic create = (CommandTypes type, [dynamic data]) {
    return new Command._(type, data);
  };
}

class Event extends Message {
  const Event._(EventTypes type, [dynamic data]) : super._(type, data);

  static final dynamic create = (EventTypes type, [dynamic data]) {
    return new Event._(type, data);
  };
}
