part of jester;


/*
abstract class IsolateActor implements IDisposable {

  final SafeReceivePort _actorPort;

  IsolateActor(SafeReceivePort this._actorPort);




}*/

void createActor() {
  return new Actor.fromReceivePort(port);
}

bool _defaultActorErrorHandler(IsolateUnhandledException ex) {
  Actor.errorHandler(ex);
}

abstract class Actor implements IDisposable {
  // *****  IMPORTANT: Scope and Descriptions are oly unique to 12 chars ***** //
  // Defines the root scope for the Jester library
  static const String ROOT_SCOPE = 'JESTER';

  // Define 'unhandled' message keys
  /// Triggered when an actor receives a command that wasn't defined in it's behavior and a default handler is defined
  static const MessageTypes DEFAULT_COMMAND_HANDLER = const MessageTypes(ROOT_SCOPE, 'DEFAULT_COMMAND_HANDLER');
  /// Triggered when an actor receives an event that wasn't defined in it's behavior and a default handler is defined
  static const MessageTypes DEFAULT_EVENT_HANDLER = const MessageTypes(ROOT_SCOPE, 'DEFAULT_EVENT_HANDLER');

  // Define global actor commands
  /// Communicates to the actor the intent that it clean up resources and dispose itself
  static const CommandTypes CLOSE_COMMAND = const CommandTypes(ROOT_SCOPE, 'CLOSE_COMMAND');

  // Define global actor events
  /// Indicates that the actor has entered an un-recoverable state and should be disposed/replaced
  static const EventTypes INVALID_STATE_EVENT = const EventTypes(ROOT_SCOPE, 'INVALID_STATE_EVENT');
  /// Indicates that the actor has received a message that was null
  static const EventTypes INVALID_MESSAGE_EVENT = const EventTypes(ROOT_SCOPE, 'INVALID_MESSAGE_EVENT');
  /// Indicates that the actor has received an event that isn't valid for the current behavior
  static const EventTypes INVALID_EVENT_EVENT = const EventTypes(ROOT_SCOPE, 'INVALID_EVENT_EVENT');
  /// Indicates that the actor has received a command that isn't valid for the current behavior
  static const EventTypes INVALID_COMMAND_EVENT = const EventTypes(ROOT_SCOPE, 'INVALID_COMMAND_EVENT');
  /// Indicates that the actor has caught an exception that wasn't handled in is't behavior code
  static const EventTypes UNHANDLED_EXCEPTION_EVENT = const EventTypes(ROOT_SCOPE, 'UNHANDLED_EXCEPTION_EVENT');

  /// Actor behaviors are defined by a series of COMMAND and EVENT handlers
  /// Changing behaviors provides a way that actors can mutate besides holding state or becoming state machines
  static final Behavior defaultB = new Behavior([
    Actor.CLOSE_COMMAND | (Actor actor, dynamic data, StreamSink replyTo) {
      print('close');
    }
    ]);

  // Keep tabs on the message subscription that was passed to the actor
  ISubscription _actorChannelSubscription;
  final ISend _actorChannel;
  Behavior _currentBehavior = Actor.defaultB;

  Actor(ISend this._actorChannel) {
    //this._actorChannelSubscription = this._actorChannel.listen(this.handler);
  }

  static final ActorCreator createIsolated = (IsolateLoader loader, [IsolateErrorHandler errorHandler]) {
    if(errorHandler == null) { errorHandler = _defaultActorErrorHandler; }
    return spawnFunction(loader, errorHandler);
  };

  static final IsolateErrorHandler errorHandler = (IsolateUnhandledException ex) {
    // Handle it
    print('Unhandled error from Actor');
  };

  void become(Behavior behavior) {
    _currentBehavior = behavior;
  }

  void sendTo(IListener to) {
    if(to == null) { throw new Exception('Invalid send port in actor'); }
    return (dynamic message, [IListener from]) {
      to.onData(message, from);
    };
  }

  operator |(Behavior behavior) {
    become(behavior);
  }
/*
  operator >(SendPort replyTo) {
    return (MessageTypes messageType, [dynamic data]) {
      if(messageType is EventTypes) {
        send(Event.create(messageType, data), replyTo);
      } else if(messageType is CommandTypes) {
        send(Command.create(messageType, data), replyTo);
      }
    };
  }*/

  // Commands are requests for mutation and should be in imperative form (aka. DoThis!, Please)
  // Events are notifications of state mutation (aka. ThisHappened!, So handle it)
  void handler(Message message, [IStream from]) {
    if(_currentBehavior == null) { // Shouldn't ever get here
      sendTo(this._actorChannel)(Event.create(INVALID_STATE_EVENT)); return;
    }
    if(message == null) { // Shouldn't send nulls to actors
      sendTo(this._actorChannel)(Event.create(INVALID_MESSAGE_EVENT)); return;
    }
    // Try to get the handler by message type
    var handler = _currentBehavior[message.type];
    if(handler != null) { // This should be the main occurance
      handler(this, message.data, from); return;
    }
    if(message.type is CommandTypes) {
      handler = _currentBehavior[DEFAULT_COMMAND_HANDLER];
      if(handler == null) {
        sendTo(this._actorChannel)(Event.create(INVALID_COMMAND_EVENT)); return;
      }
      handler(this, message, from); return;
    }
    if(message.type is EventTypes){
      handler = _currentBehavior[DEFAULT_EVENT_HANDLER];
      if(handler == null) {
        sendTo(this._actorChannel)(Event.create(INVALID_EVENT_EVENT)); return;
      }
      handler(this, message, from); return;
    }
    // Silently ignore if the message hasn't been handled
  }

  // Clean up the main subscription handle
  // This should be extended for descended types to clean-up
  void dispose() {
    _actorChannel.dispose();
  }

}

