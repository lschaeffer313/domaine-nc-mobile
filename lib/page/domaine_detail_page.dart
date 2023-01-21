import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:domaine_nc_mobile/model/domaine_info.dart';
import 'package:domaine_nc_mobile/model/domaine_search_result.dart';
import 'package:domaine_nc_mobile/service/domaine_service.dart';
import 'package:domaine_nc_mobile/utils/error_utils.dart';
import 'package:domaine_nc_mobile/widget/domain_specific_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';

class DomaineDetailPage extends StatefulWidget {
  const DomaineDetailPage({
    super.key,
    required this.domaineSearchResult,
  });
  final DomaineSearchResult domaineSearchResult;

  @override
  State<DomaineDetailPage> createState() => _DomaineDetailPage();
}

class _DomaineDetailPage extends State<DomaineDetailPage> {
  DomaineInfo? _domaineInfo;
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    DomaineService.getDomainInfo(
            widget.domaineSearchResult.name, _removeFirstDotInDomainExtension())
        .then((domainInfo) => {
              setState(() {
                _domaineInfo = domainInfo;
                _isLoading = false;
              })
            })
        .onError((Exception error, stackTrace) => {
              setState(() {
                _isError = true;
                _errorMessage = errorMessageType(error);
                _isLoading = false;
              })
            });
  }

  String _removeFirstDotInDomainExtension() {
    return widget.domaineSearchResult.extension.substring(1);
  }

  void _addEventToCalendar() {
    if (_domaineInfo!.dateExpiration != null) {
      DateTime? dateExpiration = _domaineInfo!.dateExpiration;
      var event = Event(
        title:
            'Expiration du domaine ${_domaineInfo?.nom}.${_domaineInfo?.extension}',
        description: 'Ce domaine doit être renouvellé',
        startDate: dateExpiration!,
        endDate: dateExpiration.add(
          const Duration(hours: 3),
        ),
      );
      Add2Calendar.addEvent2Cal(event);
    }
  }

  String _timeBeforeExpire() {
    var days = _domaineInfo?.nbDaysBeforeExpires;
    if (days != null) {
      if (days < 30) {
        return days == 1 ? "$days jours restant" : "$days jours restant(s)";
      } else if (days >= 30 && days < 365) {
        var month = (days / 30).floor();
        return month == 1 ? "$month mois restant" : "$month mois restant(s)";
      } else {
        var year = (days / 365).floor();
        return year == 1
            ? "$year année restante"
            : "$year année(s) restante(s)";
      }
    }
    return '';
  }

  String _listeDNS() {
    var buffer = StringBuffer();
    for (var dns in _domaineInfo!.dns) {
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

  List<Widget> _handleResponse() {
    if (_isError) {
      return [Text(_errorMessage)];
    } else {
      return _displayDomaineInfo();
    }
  }

  List<Widget> _displayDomaineInfo() {
    var listWidget = List<Widget>.of([
      DomainSpecificInfo(
        icon: const Icon(Icons.public, size: 40),
        title: _domaineInfo!.nom,
        subtitle: _domaineInfo!.extension,
        isTitle: true,
      )
    ]);
    if (!_domaineInfo!.isProtected) {
      var dateCreation = DateFormat.yMMMd().format(_domaineInfo!.dateCreation!);
      var dateExpiration =
          DateFormat.yMMMd().format(_domaineInfo!.dateExpiration!);
      listWidget.addAll([
        DomainSpecificInfo(
            icon: const Icon(Icons.wallet, size: 35),
            title: "Bénéficiaire: ",
            subtitle: _domaineInfo!.beneficiaire),
        DomainSpecificInfo(
            icon: const Icon(Icons.person, size: 35),
            title: "Gestionnaire : ",
            subtitle: _domaineInfo!.gestionnaire!),
        DomainSpecificInfo(
            icon: const Icon(Icons.task_alt, size: 35),
            title: "Date de création : ",
            subtitle: dateCreation),
        DomainSpecificInfo(
            icon: const Icon(Icons.event_busy, size: 35),
            title: "Date d'expiration : ",
            subtitle: dateExpiration),
        DomainSpecificInfo(
          icon: const Icon(Icons.hourglass_bottom, size: 35),
          title: "Temps avant expiration",
          subtitle: _timeBeforeExpire(),
        ),
        DomainSpecificInfo(
          icon: const Icon(Icons.dns_rounded, size: 35),
          title: "Serveur DNS",
          subtitle: _listeDNS(),
        )
      ]);
    } else {
      listWidget.add(
        const Center(
          child: Icon(
            Icons.shield,
            size: 120,
          ),
        ),
      );
      listWidget.add(
        const Center(
          child: Text(
            "Ce domaine est protégé",
          ),
        ),
      );
    }
    return listWidget;
  }

  FloatingActionButton? _addEventButton(BuildContext context) {
    if (!_isLoading && !_isError) {
      return _domaineInfo!.isProtected
          ? null
          : FloatingActionButton.extended(
              onPressed: _addEventToCalendar,
              label: Text(
                'Ajout rappel expiration',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              icon: Icon(
                Icons.calendar_today,
                color: Theme.of(context).colorScheme.surface,
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
          top: 20,
          left: 25,
          right: 20,
          bottom: 65,
        ),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: _isLoading ? _skeletonLoader() : _handleResponse(),
        ),
      ),
      floatingActionButton: _addEventButton(context),
    );
  }
}
