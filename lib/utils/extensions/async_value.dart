import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/exceptions/app_exception.dart';

import '../../services/actions/snack_bar_service.dart';

extension AsyncValueX on AsyncValue {
  handleSideThings(BuildContext context, callback,
      {bool shouldShowError = true}) {
    if (this is AsyncError && !isScreenError && shouldShowError) {
      SnackBarService.showErrorSnackBar(
          ((this as AsyncError).error as AppException).message.toString(),
          context: context);
    }
    if (this is AsyncData) {
      callback();
    }
  }

  bool get isScreenError =>
      this is AsyncError &&
      ((error as AppException).type == AppExceptionType.invalidPin);
}
