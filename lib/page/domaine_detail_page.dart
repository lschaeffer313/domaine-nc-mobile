import 'package:add_2_calendar_new/add_2_calendar_new.dart';
import 'package:domaine_nc_mobile/model/domaine_info.dart';
import 'package:domaine_nc_mobile/model/domaine_search_result.dart';
import 'package:domaine_nc_mobile/service/domaine_service.dart';
import 'package:domaine_nc_mobile/utils/error_utils.dart';
import 'package:domaine_nc_mobile/widget/domain_specific_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  String _title = "";

  @override
  void initState() {
    _title =
        widget.domaineSearchResult.name + widget.domaineSearchResult.extension;
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
        description: 'Ce domaine doit être renouvelé',
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
        return days == 1 ? "$days jour restant" : "$days jours restants";
      } else if (days >= 30 && days < 365) {
        var month = (days / 30).floor();
        return month == 1 ? "$month mois restant" : "$month mois restants";
      } else {
        var year = (days / 365).floor();
        return year == 1 ? "$year année restante" : "$year années restantes";
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
    final defaultSkeletonTile = Skeletonizer(
      effect: const ShimmerEffect(
        baseColor: Color.fromARGB(255, 196, 179, 23),
        highlightColor: Colors.white,
        duration: Duration(seconds: 1),
      ),
      child: DomainSpecificInfo(
        icon: const Icon(Icons.work_outlined, size: 35),
        title: "Placeholder",
        subtitle: "This is a placeholder for skeleton loader",
      ),
    );
    return [
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
    _title = _domaineInfo!.nom;
    var isMultipleDNS = _domaineInfo!.dns.length > 1;
    var listWidget = List<Widget>.of([]);
    if (!_domaineInfo!.isProtected) {
      var dateCreation = DateFormat.yMMMd().format(_domaineInfo!.dateCreation!);
      var dateExpiration =
          DateFormat.yMMMd().format(_domaineInfo!.dateExpiration!);
      listWidget.addAll([
        DomainSpecificInfo(
            icon: const Icon(Icons.wallet, size: 35),
            title: "Bénéficiaire : ",
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
          title: "Temps avant expiration :",
          subtitle: _timeBeforeExpire(),
        ),
        DomainSpecificInfo(
          icon: const Icon(Icons.dns_rounded, size: 35),
          title: isMultipleDNS ? "Serveurs DNS :" : "Serveur DNS :",
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
      appBar: AppBar(
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(Icons.public, size: 28),
            Text(
              " $_title",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
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
