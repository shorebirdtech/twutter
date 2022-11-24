# twutter

Isn't everyone writing their own Twitter?

## About
Using Twitter as an example to demonstrate what a front-to-back app
built on Shorebird could look like.

## Burndown List
- Publish to web via github hook?
- Figure out images.
- Add separate type for DatabaseId for Flaps, Users, etc.
- Add pull-to-refresh to timeline page
- Add notifications
- Add Profile pages
- Make it possible to follow/unfollow.
- Add Likes
- Add Reflaps
- Add Search

# Arch
Client holds open an EventSource connection to the server to receive
notification of timeline, message or notifciation updates.
Then when the user takes action, the client sends a request to the
server to pull the latest timeline, message or notification data.
Maybe messages are sent down in this open connection already?

App should act as though everything is local, with many requests being
async and failable.  The server should be able to run on the phone or in
the cloud and it not matter.


Views reach through to model which caches or requests from client as necessary.



* View layer
* Data layer
* Connection management layer
Is this just Model View Controller?

* Want a data layer that can just store Dart objects.


# Questions?
- Can we delete the backend directory?
- Can the compiler just decide what parts go where and find the async boundary
  to cut at?
- e.g. @trusted annotation
- Authorization should be expressed in the type system, e.g. AuthorizedContext.


# Pain
* When you forget return Response.ok() from handler, you get:
Error thrown by handler.
type 'Null' is not a subtype of type 'FutureOr<Response>'
package:shelf/src/middleware/logger.dart 30:62  logRequests.<fn>.<fn>.<fn>
* When you make a change to the server you want both it and the client to hotreload.
* No support for renaming fields in database.
* Want to see the output from client and server in one log?
* Sembast methods will happily accept 'db' (instead of 'txn') inside a transcation callback and then just hang.  Need some sort of lint to catch that.
* Had to set up my own custom docker images (there is only one flutter image, from cirrusci).
* Had to use the "flutter" image for the backend, because dart pub get can't fetch a pubspec.yaml that mentions flutter.
* Building docker files takes *minutes*
* Not clear how you have multi-repo packages with dependencies.  When you pull them from git, relative path dependencies don't work.
* CORS headers are a pain. Can you force localhost to have them?
