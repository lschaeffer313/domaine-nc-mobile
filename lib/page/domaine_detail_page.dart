import 'package:add_2_calendar/add_2_calendar.dart';
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
  final styleTextTitle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  final styleDefaultText = const TextStyle(
    color: Colors.black45,
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

  void _addEventToCalendar() {
    var event = Event(
      title:
          'Expiration du domaine ${_domaineInfo.nom}.${_domaineInfo.extension}',
      description: 'Ce domaine doit être renouvellé',
      startDate: _domaineInfo.dateExpiration,
      endDate: _domaineInfo.dateExpiration.add(
        const Duration(hours: 3),
      ),
    );
    Add2Calendar.addEvent2Cal(event);
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
        horizontal: 20,
        vertical: 8,
      ),
    );
    return [
      SkeletonListTile(
        titleStyle: const SkeletonLineStyle(
          width: 180,
          height: 40,
        ),
        leadingStyle: const SkeletonAvatarStyle(
          width: 50,
          height: 50,
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
        ),
        leading: const Icon(
          Icons.public,
          size: 40,
        ),
        title: Text(
          "${_domaineInfo.nom}.${_domaineInfo.extension}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
      ),
      ListTile(
        leading: const Icon(
          Icons.wallet,
          size: 35,
        ),
        title: Text(
          "Bénéficiaire: ",
          style: widget.styleTextTitle,
        ),
        subtitle: Text(
          _domaineInfo.beneficiaire,
          style: widget.styleDefaultText,
        ),
      ),
      ListTile(
        leading: const Icon(
          Icons.person,
          size: 40,
        ),
        title: Text(
          "Gestionnaire : ",
          style: widget.styleTextTitle,
        ),
        subtitle: Text(
          _domaineInfo.gestionnaire,
          style: widget.styleDefaultText,
        ),
      ),
      ListTile(
        leading: const Icon(
          Icons.task_alt,
          size: 40,
        ),
        title: Text(
          "Date de création : ",
          style: widget.styleTextTitle,
        ),
        subtitle: Text(
          dateCreation,
          style: widget.styleDefaultText,
        ),
      ),
      ListTile(
        leading: const Icon(
          Icons.event_busy,
          size: 40,
        ),
        title: Text(
          "Date d'expiration : ",
          style: widget.styleTextTitle,
        ),
        subtitle: Text(
          dateExpiration,
          style: widget.styleDefaultText,
        ),
      ),
      ListTile(
        leading: Icon(
          _domaineInfo.isProtected ? Icons.shield : Icons.remove_moderator,
          size: 40,
        ),
        title: Text(
          _domaineInfo.isProtected ? "Est protéger" : "N'est pas protéger",
          style: widget.styleTextTitle,
        ),
      ),
      ListTile(
        leading: const Icon(
          Icons.hourglass_bottom,
          size: 40,
        ),
        title: Text(
          "Temps avant expiration",
          style: widget.styleTextTitle,
        ),
        subtitle: Text(
          _timeBeforeExpire(),
          style: widget.styleDefaultText,
        ),
      ),
      ListTile(
        leading: const Icon(
          Icons.dns_rounded,
          size: 40,
        ),
        title: Text(
          "Serveur DNS",
          style: widget.styleTextTitle,
        ),
        subtitle: Text(
          _listeDNS(),
          style: widget.styleDefaultText,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 35,
          left: 25,
          right: 20,
        ),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: _isLoading ? _skeletonLoader() : _displayDomaineInfo(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _addEventToCalendar,
        label: Text(
          'Ajout rappel expiration',
          style: widget.styleDefaultText,
        ),
        backgroundColor: Colors.yellow,
        icon: const Icon(
          Icons.calendar_today,
          color: Colors.black45,
        ),
      ),
    );
  }
}
