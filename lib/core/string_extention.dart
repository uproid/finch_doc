import 'package:finch/finch_tools.dart';

extension StringExtension on String {
  String generateKey() {
    var res = this
        .trim()
        .replaceAll(' ', '-')
        .replaceAll('_', '-')
        .toLowerCase()
        .removeHtmlTags()
        .unescape();

    // Remove All Spcial Characters for all Languages except '-'
    res = res.replaceAll(RegExp(r'[^\p{L}\p{N}\-]+', unicode: true), '');

    // Fixed first number issue
    if (res.isNotEmpty && RegExp(r'^[0-9]').hasMatch(res)) {
      res = 'n$res';
    }

    return res;
  }
}
