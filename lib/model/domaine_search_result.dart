class DomaineSearchResult {
  final String extension;
  final String name;

  DomaineSearchResult({
    required this.extension,
    required this.name,
  });

  factory DomaineSearchResult.fromJson(Map<String, dynamic> json) {
    return DomaineSearchResult(
      extension: json['extension'] as String,
      name: json['name'] as String,
    );
  }
}
