
# This shouldn't need the Flutter image, but does to fetch pub.
# Should create a docker image for Flutter to share code.
FROM ubuntu:20.04 as build
# Make apt-get not prompt for "geographic area"
ARG DEBIAN_FRONTEND=noninteractive

# Install Dart and Flutter
RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean

# download Flutter SDK from Flutter Github repo
RUN git clone --depth 1 https://github.com/flutter/flutter.git /usr/local/flutter --branch stable

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Setup Flutter
RUN flutter channel stable
# config --enable-web may not be needed anymore?
RUN flutter config --enable-web
RUN flutter doctor
# Copy files to container and build
WORKDIR /app
COPY . .

# pubspec.lock should ensure this pulls the same as locally.
# Would be nice to have a mechanism to ensure that with checksums, etc.
RUN dart pub get
RUN dart compile exe bin/server.dart -o /app/serve

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM scratch
COPY --from=dart:stable /runtime/ /
COPY --from=build /app/serve /app/backend/

EXPOSE 3000
CMD ["/app/backend/serve"]