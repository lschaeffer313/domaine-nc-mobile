import 'package:domaine_nc_mobile/model/domaine_info.dart';
import 'package:domaine_nc_mobile/model/domaine_search_result.dart';
import 'package:domaine_nc_mobile/service/domaine_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';

class DomaineDetailPage extends StatefulWidget {
  const DomaineDetailPage({
    super.key,
    required this.domaineSearchResult,
  });
  final DomaineSearchResult domaineSearchResult;
  final colorPageTheme = Colors.grey;

  @override
  State<DomaineDetailPage> createState() => _DomaineDetailPage();
}

class _DomaineDetailPage extends State<DomaineDetailPage> {
  late DomaineInfo domaineInfo;
  bool isLoading = true;
  final styleInfo = const TextStyle(
    color: Colors.yellow,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  @override
  void initState() {
    super.initState();
    DomaineService.getDomainInfo(
      widget.domaineSearchResult.name,
      widget.domaineSearchResult.extension.split('.')[1],
    ).then((domaineInfo) {
      this.domaineInfo = domaineInfo;
      setState(() {
        isLoading = false;
      });
    });
  }

  String timeBeforeExpire() {
    var days = domaineInfo.nbDaysBeforeExpires;
    if (days < 30) {
      return "$days jours restant";
    } else if (days >= 30 && days < 365) {
      var month = (days / 30).floor();
      return "$month mois restant";
    } else {
      var year = (days / 365).floor();
      return "$year année(s) restante";
    }
  }

  String listeDNS() {
    var buffer = StringBuffer();
    for (var dns in domaineInfo.dns) {
      buffer.write("$dns, ");
    }
    if (buffer.isEmpty) {
      return "Aucun serveur associé";
    }
    return buffer.toString().substring(0, buffer.length - 2);
  }

  List<Widget> skeletonLoader() {
    final defaultSkeletonTile = SkeletonListTile(
      leadingStyle: const SkeletonAvatarStyle(
        shape: BoxShape.circle,
      ),
      titleStyle: const SkeletonLineStyle(
        width: 180,
      ),
      subtitleStyle: const SkeletonLineStyle(
        width: 100,
      ),
      hasSubtitle: true,
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 8,
      ),
    );
    return [
      SkeletonListTile(
        titleStyle: const SkeletonLineStyle(
          width: 200,
          height: 40,
        ),
        leadingStyle: const SkeletonAvatarStyle(
          width: 80,
          height: 80,
          shape: BoxShape.circle,
        ),
      ),
      defaultSkeletonTile,
      defaultSkeletonTile,
      defaultSkeletonTile,
      defaultSkeletonTile,
      defaultSkeletonTile,
      defaultSkeletonTile,
      defaultSkeletonTile,
    ];
  }

  List<Widget> displayDomaineInfo() {
    var dateCreation = DateFormat.yMMMd().format(domaineInfo.dateCreation);
    var dateExpiration = DateFormat.yMMMd().format(domaineInfo.dateExpiration);
    return [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 10,
        ),
        leading: const Icon(
          Icons.public,
          color: Colors.yellow,
          size: 50,
        ),
        title: Text(
          "${domaineInfo.nom}.${domaineInfo.extension}",
          style: const TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
      ),
      ListTile(
        leading: const Icon(
          Icons.wallet,
          color: Colors.yellow,
          size: 40,
        ),
        title: Text(
          "Bénéficiaire: ",
          style: styleInfo,
        ),
        subtitle: Text(domaineInfo.beneficiaire),
      ),
      ListTile(
        leading: const Icon(
          Icons.person,
          color: Colors.yellow,
          size: 40,
        ),
        title: Text(
          "Gestionnaire : ",
          style: styleInfo,
        ),
        subtitle: Text(domaineInfo.gestionnaire),
      ),
      ListTile(
        leading: const Icon(
          Icons.task_alt,
          color: Colors.yellow,
          size: 40,
        ),
        title: Text(
          "Date de création : ",
          style: styleInfo,
        ),
        subtitle: Text(dateCreation),
      ),
      ListTile(
        leading: const Icon(
          Icons.event_busy,
          color: Colors.yellow,
          size: 40,
        ),
        title: Text(
          "Date d'expiration : ",
          style: styleInfo,
        ),
        subtitle: Text(dateExpiration),
      ),
      ListTile(
        leading: Icon(
          domaineInfo.isProtected ? Icons.shield : Icons.remove_moderator,
          color: Colors.yellow,
          size: 40,
        ),
        title: Text(
          domaineInfo.isProtected ? "Est protéger" : "N'est pas protéger",
          style: styleInfo,
        ),
      ),
      ListTile(
        leading: const Icon(
          Icons.hourglass_bottom,
          color: Colors.yellow,
          size: 40,
        ),
        title: Text(
          "Temps avant expiration",
          style: styleInfo,
        ),
        subtitle: Text(timeBeforeExpire()),
      ),
      ListTile(
        leading: const Icon(
          Icons.dns_rounded,
          color: Colors.yellow,
          size: 40,
        ),
        title: Text(
          "Serveur DNS",
          style: styleInfo,
        ),
        subtitle: Text(listeDNS()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
      ),
      backgroundColor: widget.colorPageTheme,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          left: 30,
          right: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isLoading ? skeletonLoader() : displayDomaineInfo(),
        ),
      ),
    );
  }
}
