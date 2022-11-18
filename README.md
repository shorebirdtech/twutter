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

