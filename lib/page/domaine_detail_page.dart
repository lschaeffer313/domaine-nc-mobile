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
    if (_domaineInfo.dateExpiration != null) {
      DateTime dateExpiration = _domaineInfo.dateExpiration!;
      var event = Event(
        title:
            'Expiration du domaine ${_domaineInfo.nom}.${_domaineInfo.extension}',
        description: 'Ce domaine doit être renouvellé',
        startDate: dateExpiration,
        endDate: dateExpiration.add(
          const Duration(hours: 3),
        ),
      );
      Add2Calendar.addEvent2Cal(event);
    }
  }

  String _timeBeforeExpire() {
    var days = _domaineInfo.nbDaysBeforeExpires;
    if (days != null) {
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
    return '';
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
    ];
  }

  ListTile _constructWidgetInfo(Icon icon, String title, String? subtitle,
      {bool isTitle = false}) {
    return ListTile(
      contentPadding:
          isTitle ? const EdgeInsets.symmetric(horizontal: 0) : null,
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isTitle ? 35 : null,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: widget.styleDefaultText)
          : null,
    );
  }

  List<Widget> _displayDomaineInfo() {
    var listWidget = List<Widget>.of([
      _constructWidgetInfo(const Icon(Icons.public, size: 40),
          "${_domaineInfo.nom}.${_domaineInfo.extension}", null,
          isTitle: true)
    ]);
    if (!_domaineInfo.isProtected) {
      var dateCreation = DateFormat.yMMMd().format(_domaineInfo.dateCreation!);
      var dateExpiration =
          DateFormat.yMMMd().format(_domaineInfo.dateExpiration!);
      listWidget.addAll([
        _constructWidgetInfo(const Icon(Icons.wallet, size: 35),
            "Bénéficiaire: ", _domaineInfo.beneficiaire),
        _constructWidgetInfo(const Icon(Icons.person, size: 35),
            "Gestionnaire : ", _domaineInfo.gestionnaire!),
        _constructWidgetInfo(const Icon(Icons.task_alt, size: 35),
            "Date de création : ", dateCreation),
        _constructWidgetInfo(const Icon(Icons.event_busy, size: 35),
            "Date d'expiration : ", dateExpiration),
        _constructWidgetInfo(const Icon(Icons.hourglass_bottom, size: 35),
            "Temps avant expiration", _timeBeforeExpire()),
        _constructWidgetInfo(
            const Icon(Icons.dns_rounded, size: 35), "Serveur DNS", _listeDNS())
      ]);
    } else {
      listWidget.add(
        _constructWidgetInfo(
            const Icon(Icons.shield, size: 30), "Ce domaine est protégé", null),
      );
    }
    return listWidget;
  }

  FloatingActionButton? _addEventButton() {
    if (!_isLoading) {
      return _domaineInfo.isProtected
          ? null
          : FloatingActionButton.extended(
              onPressed: _addEventToCalendar,
              label: Text(
                'Ajout rappel expiration',
                style: widget.styleDefaultText,
              ),
              backgroundColor: Colors.yellow,
              icon: const Icon(
                Icons.calendar_today,
                color: Colors.black45,
              ),
            );
    }
    return null;
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
        floatingActionButton: _addEventButton());
  }
}
