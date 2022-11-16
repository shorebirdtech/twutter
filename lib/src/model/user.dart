class User {
  final String id;
  final String displayName;
  final String handle;
  final bool official;
  final bool verified;

  // Good enough hack for now.
  String get initials => displayName.split(' ').map((s) => s[0]).join();

  const User({
    required this.id,
    required this.displayName,
    required this.handle,
    this.official = false,
    this.verified = false,
  });
}
