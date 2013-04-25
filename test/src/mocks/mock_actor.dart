part of jester_test;

// Use as a top level entry point for isolate creation
void createMockActor() {
  new MockActor(port);
}
class MockActor extends Actor {
  /*MockActor._(ReceivePort receivePort) : super(receivePort);

  factory MockActor(ReceivePort receivePort) {
    var mockActor = new MockActor._(receivePort);
    mockActor | MockActor.initialB; // Assign a starting behavior
    return mockActor;
  }*/
  MockActor._(ISubscription actorChannel) : super(actorChannel);//, actorChannel.listen(super.handler));

  factory MockActor(ISubscription actorChannel) {
    var actor = new MockActor._(actorChannel);
    ;
    actor | MockActor.initialB;
    return actor;
  }

  // To enable creation inside an isolate boundary try:
  static final MockActor createIsolated = () {
    return Actor.createIsolated(createMockActor);
  };

  /// Define the scope for all commands and events in this type
  static const String SCOPE = 'UNIQUE_KEY_FOR_ACTOR';

  /// Define commands the type a ccepts
  static const CommandTypes START_COMMAND = const CommandTypes(SCOPE, 'START_COMMAND');
  static const CommandTypes STOP_COMMAND = const CommandTypes(SCOPE, 'STOP_COMMAND');

  /// Define events the type emits
  static const EventTypes STARTING_EVENT = const EventTypes(SCOPE, 'STARTING_EVENT');
  static const EventTypes STARTED_EVENT = const EventTypes(SCOPE, 'STARTED_EVENT');
  static const EventTypes STOPPING_EVENT = const EventTypes(SCOPE, 'STOPPING_EVENT');
  static const EventTypes STOPPED_EVENT = const EventTypes(SCOPE, 'STOPPED_EVENT');

  static final Behavior initialB = new Behavior([
    Actor.CLOSE_COMMAND | Actor.defaultB[Actor.CLOSE_COMMAND]
    //Actor.CLOSE_COMMAND | (Actor actor, dynamic data, )
    ]);
}