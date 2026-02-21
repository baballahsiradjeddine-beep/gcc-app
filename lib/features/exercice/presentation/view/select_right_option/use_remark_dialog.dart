import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tayssir/providers/data/models/latex_field.dart';
import 'package:tayssir/services/actions/dialog_service.dart';

void useRemarkDialog(
    BuildContext context, List<LatexField<String>>? remark, String? remarkImage,
    {bool shouldDelay = false}) {
  useEffect(() {
    if (remark != null && remark.isNotEmpty) {
      final timeToWait = shouldDelay ? 2000 : 1000;
      Future.delayed(Duration(milliseconds: timeToWait), () {
        // ignore: use_build_context_synchronously
        DialogService.showRemarkDialog(context, remark, remarkImage);
      });
    }
    return null;
  }, []);
}
