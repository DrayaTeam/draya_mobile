class MaterialStream {
  final String provider;
  final String videoId;
  final String streamUrl;
  final DateTime expiresAt;

  const MaterialStream({
    required this.provider,
    required this.videoId,
    required this.streamUrl,
    required this.expiresAt,
  });
}
