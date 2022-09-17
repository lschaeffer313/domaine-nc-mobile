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
  final styleInfo = const TextStyle(
    color: Colors.yellow,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  @override
  State<DomaineDetailPage> createState() => _DomaineDetailPage();
}

class _DomaineDetailPage extends State<DomaineDetailPage> {
  late DomaineInfo _domaineInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    DomaineService.getDomainInfo(
      widget.domaineSearchResult.name,
      _removeFirstDotInDomainExtension(),
    ).then((domaineInfo) {
      _domaineInfo = domaineInfo;
      setState(() {
        _isLoading = false;
      });
    });
  }

  String _removeFirstDotInDomainExtension() {
    return widget.domaineSearchResult.extension.substring(1);
  }

  String _timeBeforeExpire() {
    var days = _domaineInfo.nbDaysBeforeExpires;
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

  String _listeDNS() {
    var buffer = StringBuffer();
    for (var dns in _domaineInfo.dns) {
      buffer.write("$dns, ");
    }
    if (buffer.isEmpty) {
      return "Aucun serveur associé";
    }
    return buffer.toString().substring(0, buffer.length - 2);
  }

  List<Widget> _skeletonLoader() {
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

  List<Widget> _displayDomaineInfo() {
    var dateCreation = DateFormat.yMMMd().format(_domaineInfo.dateCreation);
    var dateExpiration = DateFormat.yMMMd().format(_domaineInfo.dateExpiration);
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
          "${_domaineInfo.nom}.${_domaineInfo.extension}",
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
          style: widget.styleInfo,
        ),
        subtitle: Text(_domaineInfo.beneficiaire),
      ),
      ListTile(
        leading: const Icon(
          Icons.person,
          color: Colors.yellow,
          size: 40,
        ),
        title: Text(
          "Gestionnaire : ",
          style: widget.styleInfo,
        ),
        subtitle: Text(_domaineInfo.gestionnaire),
      ),
      ListTile(
        leading: const Icon(
          Icons.task_alt,
          color: Colors.yellow,
          size: 40,
        ),
        title: Text(
          "Date de création : ",
          style: widget.styleInfo,
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
          style: widget.styleInfo,
        ),
        subtitle: Text(dateExpiration),
      ),
      ListTile(
        leading: Icon(
          _domaineInfo.isProtected ? Icons.shield : Icons.remove_moderator,
          color: Colors.yellow,
          size: 40,
        ),
        title: Text(
          _domaineInfo.isProtected ? "Est protéger" : "N'est pas protéger",
          style: widget.styleInfo,
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
          style: widget.styleInfo,
        ),
        subtitle: Text(_timeBeforeExpire()),
      ),
      ListTile(
        leading: const Icon(
          Icons.dns_rounded,
          color: Colors.yellow,
          size: 40,
        ),
        title: Text(
          "Serveur DNS",
          style: widget.styleInfo,
        ),
        subtitle: Text(_listeDNS()),
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
          children: _isLoading ? _skeletonLoader() : _displayDomaineInfo(),
        ),
      ),
    );
  }
}
