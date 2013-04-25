part of jester;

class MessageTypes {
  final List<int> _uid;

  const MessageTypes._(this._uid);

  const MessageTypes(String scope, String key)
      : this._(
          [PackedInt.pack(scope),
          PackedInt.pack(key)]);

  static final dynamic create = (String scope, String key) {
    return new MessageTypes(scope, key);
  };

  static final dynamic fromUid = (Iterable<int> uid) {
    if(uid == null) { return null; }
    if(uid.length != 2) { return null; }
    return new MessageTypes._(uid);
  };

  String get scope => PackedInt.unpack(_uid[0]);
  String get key => PackedInt.unpack(_uid[1]);
  Iterable<int> get uid => _uid;
  String toString() => '${scope} - ${key}';

  operator |(MessageHandler messageHandler) {
    return new BehaviorHandler(this, messageHandler);
  }
  operator ==(MessageTypes other) => this._uid[0] == other._uid[0] && this._uid[1] == other._uid[1];
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

  static final dynamic deserialize = (Iterable serialized) {
    if(serialized == null || serialized.length == 0 || serialized.length > 2) { return null; }
    MessageTypes messageType = MessageTypes.fromUid(serialized.first);
    var data = null;
    if(serialized.length == 2) {
      data = serialized.elementAt(1);
    }
    return new Message(messageType, data);
  };

  /// Maps the internal structure into a serializable format to send across isolates
  List serialize() {
    if(data == null) { // type only
      List result = new List(1);
      result[0] = type.uid;
      return result;
    } else { // type and data
      List result = new List(2);
      result[0] = type.uid;
      result[1] = data;
      return result;
    }
  }

  String toString() => '${type}: ${data}';

  operator ==(Message other) => this.type == other.type && this.data == other.data;
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