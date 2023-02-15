class DomaineInfo {
  final String? beneficiaire;
  final DateTime? dateCreation;
  final DateTime? dateExpiration;
  final List<String> dns;
  final bool? expired;
  final String nom;
  final String extension;
  final String? gestionnaire;
  final bool isProtected;
  final String? note;
  final String? status;
  final int? nbDaysBeforeExpires;

  DomaineInfo({
    required this.beneficiaire,
    required this.dateCreation,
    required this.dateExpiration,
    required this.dns,
    required this.expired,
    required this.extension,
    required this.gestionnaire,
    required this.isProtected,
    required this.nbDaysBeforeExpires,
    required this.nom,
    required this.note,
    required this.status,
  });

  factory DomaineInfo.fromJson(Map<String, dynamic> json) {
    var listDNS = List<String>.empty();
    if (json['dns'] != null) {
      Iterable<dynamic> iterableJsonDNS = json['dns'] as Iterable<dynamic>;
      listDNS = List<String>.of(iterableJsonDNS.map((dns) => dns as String));
    }

    return DomaineInfo(
      beneficiaire: json['beneficiaire'] as String,
      dateCreation: json['dateCreation'] != null
          ? DateTime.parse(json['dateCreation'] as String)
          : null,
      dateExpiration: json['dateExpiration'] != null
          ? DateTime.parse(json['dateExpiration'] as String)
          : null,
      dns: listDNS,
      expired: json['expired'] as bool,
      extension: json['extension'] as String,
      gestionnaire: json['gestionnaire'] as String,
      isProtected: json['isProtected'] as bool,
      nbDaysBeforeExpires: json['nbDaysBeforeExpires'] as int,
      nom: json['nom'] as String,
      note: json['note'] as String,
      status: json['status'] as String,
    );
  }
}
