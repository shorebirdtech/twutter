# twutter

Using Twitter as an example to demonstrate what a front-to-back app
built on Shorebird could look like.

An instance is live at: https://shimmer-c3juc.ondigitalocean.app/

## Running Locally

`dart run lib/src/gen/server.dart` runs the server.
`flutter run` runs the client.
Currently the only db is mongodb running remotely.

# Notes

## Dependencies to remove
- dockerfiles -- move to shorebird (will require github action?)
- bin/server.dart -- move into a shorebird tool?
- gen directory -- make autogenerated (shorebird tool?)
- dependency_override on shorebird -- remove
- dependency on json_serializable -- replace with shorebird annotation?
- remove or autogenerate fromDbJson and toDbJson methods

## Expected dev flow
- Dev writes app, to add some backend adds @secure annotated methods.
- Adds @ShorebirdModel to classes to be stored in datastore.
- Runs `shorebird run` to run the app locally, including code generation?
- `shorebird run` integrates logs from all datastore, server and device.
- `shorebird deploy` deploys to shorebird cloud.

## Easy cleanup
- Add color to user profile
- center views on large screens.

## Known Twutter issues
- Separate per-user timelines.
- Profile pages
- Ability to follow/unfollow.
- Pull-to-refresh to timeline page
- Notifications
- Likes
- Reflaps
- Search
- /home and other routes don't actually check for login.

## Known Shorebird issues
- No way to migrate the database when editing model classes.
- Image support (e.g. for profile images, media in flaps, etc).
- Session is not persisted locally.
- Sessions on the server are fake (and not persisted).
- Possible to create duplicate users.
- Timezones are not handled properly (server time should be utc and authoratative).

## Questions?
- Can we delete the backend directory?
- Can the compiler just decide what parts go where and find the async boundary
  to cut at?
- e.g. @trusted annotation
- Authorization should be expressed in the type system, e.g. AuthorizedContext.

## Pain
* When you forget return Response.ok() from handler, you get:
Error thrown by handler.
type 'Null' is not a subtype of type 'FutureOr<Response>'
package:shelf/src/middleware/logger.dart 30:62  logRequests.<fn>.<fn>.<fn>
* When you make a change to the server you want both it and the client to hotreload.
* No support for renaming fields in database.
* Want to see the output from client and server in one log?
* Had to set up my own custom docker images (there is only one flutter image, from cirrusci).
* Had to use the "flutter" image for the backend, because dart pub get can't fetch a pubspec.yaml that mentions flutter.
* Building docker files takes *minutes*
* Not clear how you have multi-repo packages with dependencies.  When you pull them from git, relative path dependencies don't work.
* CORS headers are a pain. Can you force localhost to have them?
* Getting the docker image deployed with the correct ports was a pain.
* Separate docker images for client and server make for long builds.