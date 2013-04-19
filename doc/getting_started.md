# Jester: Getting Started Doc

----

> But I'm proud to recall that in no time at all, with no other recourses but my own resources, with firm application and determination... I made a fool of myself!

> A jester unemployed is nobody's fool!

  - Gotta have [Dart]: http://dartlang.org
  
----

There are just a few core concepts to implement an actor graph, however implementation is the easy part...

> If you aren't familiar with DDD *Domain Driven Design* then I suggest reading up on it, fun stuff!

This document will be expanded to provide more info on:
- Running actors inside of isolates
- Defining behaviors for an actor
- Scoping Messages
	- Message scope should be named after the Pub library name to help ensure that collisions are avoided
	- Names should also be defined in all caps which helps compact the hash for scope to fit 16 chars into a 64 bit value
- Defining Commands and Events
- Sending commands to an actor
- Receiving responses from an actor

----

Version
----

0.0.1 ish

Tech
----

* [Dart] - Dartlang.org: get the JS out!
* [Jester] - An Actor framework for Dart.

Installation
----

[Jester]: http://pub.dartlang.org/packages/jester

License
----

https://github.com/Vizidrix/jester/blob/master/LICENSE

----
## Edited
* 18-April-2013 initial release

----
## Credits
* Vizidrix <https://github.com/organizations/Vizidrix>
* Perry Birch <https://github.com/PerryBirch>
