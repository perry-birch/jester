part of jester;

typedef void IsolateLoader();
typedef bool IsolateErrorHandler(IsolateUnhandledException ex);
typedef SendPort BaseActorCreator(IsolateLoader loader, [IsolateErrorHandler errorHandler]);
typedef SendPort ActorCreator();
typedef TProxy ProxyCreator<TProxy>();
typedef void MessageHandler(Actor actor, dynamic data, SendPort replyTo);