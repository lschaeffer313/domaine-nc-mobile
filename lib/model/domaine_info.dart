class DomaineInfo {
  final String beneficiaire;
  final DateTime dateCreation;
  final DateTime dateExpiration;
  final List<String> dns;
  final bool expired;
  final String extension;
  final String gestionnaire;
  final bool isProtected;
  final int nbDaysBeforeExpires;
  final String nom;
  final String note;
  final String status;

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
    Iterable iterableJsonDNS = json['dns'];
    var listDNS = List<String>.from(iterableJsonDNS.map((dns) => dns));
    return DomaineInfo(
      beneficiaire: json['beneficiaire'],
      dateCreation: DateTime.parse(json['dateCreation']),
      dateExpiration: DateTime.parse(json['dateExpiration']),
      dns: listDNS,
      expired: json['expired'],
      extension: json['extension'],
      gestionnaire: json['gestionnaire'],
      isProtected: json['isProtected'],
      nbDaysBeforeExpires: json['nbDaysBeforeExpires'],
      nom: json['nom'],
      note: json['note'],
      status: json['status'],
    );
  }
}
