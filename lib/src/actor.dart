part of jester;

bool _defaultActorErrorHandler(IsolateUnhandledException ex) {
  Actor.errorHandler(ex);
}

abstract class Actor {
  final SafeReceivePort _actorPort;
  static const String ROOT_SCOPE = 'JESTER';

  // Define 'unhandled' message keys
  static const MessageTypes INVALID_EVENT = const MessageTypes(ROOT_SCOPE, 'INVALID_EVENT');
  static const MessageTypes INVALID_COMMAND = const MessageTypes(ROOT_SCOPE, 'INVALID_COMMAND');

  // Define global actor commands
  static const CommandTypes CONFIGURE_COMMAND = const CommandTypes(ROOT_SCOPE, 'CONFIGURE_COMMAND');

  // Define global actor events
  static const EventTypes CONFIGURING_EVENT = const EventTypes(ROOT_SCOPE, 'CONFIGURING_EVENT');
  static const EventTypes CONFIGURED_EVENT = const EventTypes(ROOT_SCOPE, 'CONFIGURED_EVENT');
  static const EventTypes INVALID_EVENT_EVENT = const EventTypes(ROOT_SCOPE, 'INVALID_EVENT_EVENT');
  static const EventTypes INVALID_COMMAND_EVENT = const EventTypes(ROOT_SCOPE, 'INVALID_COMMAND_EVENT');

  Actor._(SafeReceivePort this._actorPort);

  Actor(ReceivePort actorPort) {
    // If the provided receive port isn't already safe then upgrage it
    if(actorPort is! SafeReceivePort) {
      actorPort = new SafeReceivePort(actorPort);
    }
    actorPort.receive(handler);
    //return new Actor._(actorPort);
  }

  static final ActorCreator create = (IsolateLoader loader, [IsolateErrorHandler errorHandler]) {
    if(errorHandler == null) { errorHandler = _defaultActorErrorHandler; }
    return spawnFunction(loader, errorHandler);
  };

  static final IsolateErrorHandler errorHandler = (IsolateUnhandledException ex) {
    // Handle it
    print('Unhandled error from Actor');
  };

  void handler(Message message, SendPort replyTo) {
    if(_currentBehavior == null) { throw new Exception('Invalid actor state'); } // TODO: Throw if null?
    // Check for a handler and call it if found
    if(_currentBehavior.contains(message.type)) {
      _currentBehavior[message.type](this, message.data, replyTo);
      return;
    }
    // Don't accept invalid commands by default (events are okay)
    if(message.type is CommandTypes) {
      // Check for custom invalid command handler and call if found
      if(_currentBehavior.contains(INVALID_COMMAND)) {
        _currentBehavior[INVALID_COMMAND](this, message, replyTo);
        return;
      }
      send(Event.create(INVALID_COMMAND_EVENT, message), replyTo);
      return;
    }
    // Just in case check for a default event handler
    if(message.type is EventTypes) {
      // Check for custom invalid event handler and call if found
      if(_currentBehavior.contains(INVALID_EVENT)) {
        _currentBehavior[INVALID_EVENT](this, message, replyTo);
        return;
      }
      send(Event.create(INVALID_EVENT_EVENT, message), replyTo);
      return;
    }
    // Silently ignore if the message hasn't been handled
  }

  Behavior _currentBehavior;
  void become(Behavior behavior) {
    _currentBehavior = behavior;
  }
  operator |(Behavior behavior) {
    become(behavior);
    return this;
  }

  operator >(SendPort replyTo) {
    return (MessageTypes messageType, [dynamic data]) {
      if(messageType is EventTypes) {
        send(Event.create(messageType, data), replyTo);
      } else if(messageType is CommandTypes) {
        send(Command.create(messageType, data), replyTo);
      }
    };
  }

  void send(Message message, SendPort to) {
    if(to == null) { throw new Exception('Invalid send port in actor'); }
    to.send(message, _actorPort.toSendPort());
  }

  void sendRaw(dynamic message, SendPort to) {
    if(to == null) { throw new Exception('Invalid send port in actor'); }
    to.send(message, _actorPort.toSendPort());
  }
}

