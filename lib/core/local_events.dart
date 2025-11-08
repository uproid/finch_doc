var localEvents = <String, Object>{
  'now': DateTime.now(),
  'maxLength': (String? text, int maxLength) {
    text ??= '';
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + '...';
    }
  },
};
