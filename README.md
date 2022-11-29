# twutter

Isn't everyone writing their own Twitter?

## About
Using Twitter as an example to demonstrate what a front-to-back app
built on Shorebird could look like.

## Blockers to posting to Discord
- Sign-in of some form
- Timeline refresh on login

## Missing features
- Separate per-user timelines.
- Profile pages
- Ability to follow/unfollow.
- Image support (profile images, media in flaps, etc).
- Pull-to-refresh to timeline page
- Notifications
- Likes
- Reflaps
- Search

## Bugs
- /home and other routes don't actually check for login.
- Session is not persisted locally.
- Sessions on the server are fake (and not persisted).
- Possible to create duplicate users.
- Timezones are not handled properly (server time should be utc and authoratative).

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
* Getting the docker image deployed with the correct ports was a pain.
* Separate docker images for client and server make for long builds.