import 'dart:async';

import 'package:domaine_nc_mobile/assets/constants.dart';

String errorMessageType(Exception e) {
  switch (e.runtimeType) {
    case TimeoutException:
      return timeoutErrorMessage;
    default:
      return "Erreur inconnu";
  }
}
