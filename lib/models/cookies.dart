class Cookies {
  Cookies({
    required this.jSessionId,
    required this.liveAppsCookie,
  });
  final String jSessionId;
  final String liveAppsCookie;

  String get toHeaderString => '$jSessionId; $liveAppsCookie';
}
