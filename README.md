# twutter

Isn't everyone writing their own Twitter?

## About
Using Twitter as an example to demonstrate what a front-to-back app
built on Shorebird could look like.

## Burndown List
- Make it possible to post.
- Make it possible to refresh timeline.
- Make it possible to follow/unfollow.
- Publish to web via github hook?
- Remove real people names.
- Add Likes
- Add Reflaps
- Figure out images.
- Add notifications
- Add Search
- Add Profile pages

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



# Questions?
- Can we delete the backend directory?
- Can the compiler just decide what parts go where and find the async boundary
  to cut at?
- e.g. @trusted annotation
- Authorization should be expressed in the type system, e.g. AuthorizedContext.