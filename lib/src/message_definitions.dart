part of jester;

class MessageTypes {
  final int _scope;
  final int _key;
  const MessageTypes._(int this._scope, int this._key);
  const MessageTypes(String scope, String key)
      : this._(
          PackedInt.pack(scope),
          PackedInt.pack(key));
  String get scope => PackedInt.unpack(_scope);
  String get key => PackedInt.unpack(_key);
  String toString() => '${scope} - ${key}';
  operator |(MessageHandler messageHandler) {
    return new BehaviorHandler(this, messageHandler);
  }
  operator ==(MessageTypes other) => this._scope == other._scope && this._key == other._key;
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
  static const MessageTypes RAW_MESSAGE = const MessageTypes('JESTER', 'RAW_MESSAGE');
  final MessageTypes type;
  final dynamic data;

  const Message._(MessageTypes this.type, [dynamic this.data = null]);
  factory Message(MessageTypes type, [dynamic data]) {
    if(type is CommandTypes) { return Command.create(type, data); }
    if(type is EventTypes) { return Event.create(type, data); }
    return Message.create(type, data);
  }

  static final dynamic create = (MessageTypes type, [dynamic data]) {
    return new Message._(type, data);
  };
}

class Command extends Message {
  const Command._(CommandTypes type, [dynamic data]) : super._(type, data);
  factory Command(CommandTypes type, [dynamic data]) {
    return Command.create(type, data);
  }

  static final dynamic create = (CommandTypes type, [dynamic data]) {
    return new Command._(type, data);
  };
}

class Event extends Message {
  const Event._(EventTypes type, [dynamic data]) : super._(type, data);
  factory Event(EventTypes type, [dynamic data]) {
    return Event.create(type, data);
  }

  static final dynamic create = (EventTypes type, [dynamic data]) {
    return new Event._(type, data);
  };
}

class ReceivedMessage {
  final Message message;
  final SendPort replyTo;

  const ReceivedMessage._(dynamic this.message, SendPort this.replyTo);
  factory ReceivedMessage(dynamic message, SendPort replyTo) {
    if(message is Command) { return ReceivedCommand.create(message, replyTo); }
    if(message is Event) { return ReceivedEvent.create(message, replyTo); }
    if(message is Message) { return ReceivedMessage.create(message, replyTo); }
    return ReceivedMessage.create(new Message(Message.RAW_MESSAGE, message), replyTo);
  }

  static final dynamic create = (Message message, SendPort replyTo) {
    return new ReceivedMessage._(message, replyTo);
  };
}

class ReceivedCommand extends ReceivedMessage {
  const ReceivedCommand._(Command command, SendPort replyTo) : super._(command, replyTo);
  factory ReceivedCommand(Command command, SendPort replyTo) {
    return ReceivedCommand.create(command, replyTo);
  }

  static final dynamic create = (Command command, SendPort replyTo) {
    return new ReceivedCommand._(command, replyTo);
  };
}

class ReceivedEvent extends ReceivedMessage {
  const ReceivedEvent._(Event event, SendPort replyTo) : super._(event, replyTo);

  static final dynamic create = (Event event, SendPort replyTo) {
    return new ReceivedEvent._(event, replyTo);
  };
}