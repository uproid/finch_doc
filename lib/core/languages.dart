class Language {
  final String code;
  final String localName;
  final String name;
  final String emojiFlag;

  Language(this.code, this.localName, this.name, this.emojiFlag);

  bool get isRtl {
    const rtlLanguages = [
      'ar', // Arabic
      'he', // Hebrew
      'fa', // Persian
      'ur', // Urdu
      'ps', // Pashto
      'sd', // Sindhi
      'ug', // Uyghur
      'yi', // Yiddish
    ];
    return rtlLanguages.contains(code);
  }

  @override
  String toString() {
    return localName;
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'localName': localName,
      'name': name,
      'emojiFlag': emojiFlag,
      'isRtl': isRtl,
      'dir': isRtl ? 'rtl' : 'ltr',
    };
  }
}

final Map<String, Language> languages = {
  'en': Language('en', 'English', 'English', '🇺🇸'),
  'es': Language('es', 'Español', 'Spanish', '🇪🇸'),
  'fr': Language('fr', 'Français', 'French', '🇫🇷'),
  'de': Language('de', 'Deutsch', 'German', '🇩🇪'),
  'zh': Language('zh', '中文', 'Chinese', '🇨🇳'),
  'ja': Language('ja', '日本語', 'Japanese', '🇯🇵'),
  'ru': Language('ru', 'Русский', 'Russian', '🇷🇺'),
  'ar': Language('ar', 'العربية', 'Arabic', '🇸🇦'),
  'hi': Language('hi', 'हिन्दी', 'Hindi', '🇮🇳'),
  'pt': Language('pt', 'Português', 'Portuguese', '🇵🇹'),
  'bn': Language('bn', 'বাংলা', 'Bengali', '🇧🇩'),
  'pa': Language('pa', 'ਪੰਜਾਬੀ', 'Punjabi', '🇮🇳'),
  'jv': Language('jv', 'ꦧꦱꦗꦮ', 'Javanese', '🇮🇩'),
  'ko': Language('ko', '한국어', 'Korean', '🇰🇷'),
  'vi': Language('vi', 'Tiếng Việt', 'Vietnamese', '🇻🇳'),
  'te': Language('te', 'తెలుగు', 'Telugu', '🇮🇳'),
  'mr': Language('mr', 'मराठी', 'Marathi', '🇮🇳'),
  'ta': Language('ta', 'தமிழ்', 'Tamil', '🇮🇳'),
  'tr': Language('tr', 'Türkçe', 'Turkish', '🇹🇷'),
  'it': Language('it', 'Italiano', 'Italian', '🇮🇹'),
  'th': Language('th', 'ไทย', 'Thai', '🇹🇭'),
  'pl': Language('pl', 'Polski', 'Polish', '🇵🇱'),
  'nl': Language('nl', 'Nederlands', 'Dutch', '🇳🇱'),
  'uk': Language('uk', 'Українська', 'Ukrainian', '🇺🇦'),
  'id': Language('id', 'Bahasa Indonesia', 'Indonesian', '🇮🇩'),
  'fa': Language('fa', 'فارسی', 'Persian', '🇮🇷'),
  'sw': Language('sw', 'Kiswahili', 'Swahili', '🇰🇪'),
  'ro': Language('ro', 'Română', 'Romanian', '🇷🇴'),
  'hu': Language('hu', 'Magyar', 'Hungarian', '🇭🇺'),
  'cs': Language('cs', 'Čeština', 'Czech', '🇨🇿'),
  'el': Language('el', 'Ελληνικά', 'Greek', '🇬🇷'),
  'sv': Language('sv', 'Svenska', 'Swedish', '🇸🇪'),
  'fi': Language('fi', 'Suomi', 'Finnish', '🇫🇮'),
  'da': Language('da', 'Dansk', 'Danish', '🇩🇰'),
  'no': Language('no', 'Norsk', 'Norwegian', '🇳🇴'),
  'he': Language('he', 'עברית', 'Hebrew', '🇮🇱'),
  'ms': Language('ms', 'Bahasa Melayu', 'Malay', '🇲🇾'),
  'bg': Language('bg', 'Български', 'Bulgarian', '🇧🇬'),
  'sk': Language('sk', 'Slovenčina', 'Slovak', '🇸🇰'),
  'hr': Language('hr', 'Hrvatski', 'Croatian', '🇭🇷'),
  'sr': Language('sr', 'Српски', 'Serbian', '🇷🇸'),
  'lt': Language('lt', 'Lietuvių', 'Lithuanian', '🇱🇹'),
  'sl': Language('sl', 'Slovenščina', 'Slovenian', '🇸🇮'),
  'lv': Language('lv', 'Latviešu', 'Latvian', '🇱🇻'),
  'et': Language('et', 'Eesti', 'Estonian', '🇪🇪'),
  'ur': Language('ur', 'اردو', 'Urdu', '🇵🇰'),
  'kn': Language('kn', 'ಕನ್ನಡ', 'Kannada', '🇮🇳'),
  'ml': Language('ml', 'മലയാളം', 'Malayalam', '🇮🇳'),
  'gu': Language('gu', 'ગુજરાતી', 'Gujarati', '🇮🇳'),
  'si': Language('si', 'සිංහල', 'Sinhala', '🇱🇰'),
  'ne': Language('ne', 'नेपाली', 'Nepali', '🇳🇵'),
  'my': Language('my', 'မြန်မာဘာသာ', 'Burmese', '🇲🇲'),
  'km': Language('km', 'ភាសាខ្មែរ', 'Khmer', '🇰🇭'),
  'lo': Language('lo', 'ລາວ', 'Lao', '🇱🇦'),
  'ka': Language('ka', 'ქართული', 'Georgian', '🇬🇪'),
  'am': Language('am', 'አማርኛ', 'Amharic', '🇪🇹'),
  'az': Language('az', 'Azərbaycan', 'Azerbaijani', '🇦🇿'),
  'kk': Language('kk', 'Қазақ', 'Kazakh', '🇰🇿'),
  'uz': Language('uz', 'Oʻzbekcha', 'Uzbek', '🇺🇿'),
  'af': Language('af', 'Afrikaans', 'Afrikaans', '🇿🇦'),
  'sq': Language('sq', 'Shqip', 'Albanian', '🇦🇱'),
  'hy': Language('hy', 'Հայերեն', 'Armenian', '🇦🇲'),
  'be': Language('be', 'Беларуская', 'Belarusian', '🇧🇾'),
  'bs': Language('bs', 'Bosanski', 'Bosnian', '🇧🇦'),
  'ca': Language('ca', 'Català', 'Catalan', '🇪🇸'),
  'eu': Language('eu', 'Euskara', 'Basque', '🇪🇸'),
  'gl': Language('gl', 'Galego', 'Galician', '🇪🇸'),
  'is': Language('is', 'Íslenska', 'Icelandic', '🇮🇸'),
  'ga': Language('ga', 'Gaeilge', 'Irish', '🇮🇪'),
  'mk': Language('mk', 'Македонски', 'Macedonian', '🇲🇰'),
  'mt': Language('mt', 'Malti', 'Maltese', '🇲🇹'),
  'mn': Language('mn', 'Монгол', 'Mongolian', '🇲🇳'),
  'tg': Language('tg', 'Тоҷикӣ', 'Tajik', '🇹🇯'),
  'tk': Language('tk', 'Türkmençe', 'Turkmen', '🇹🇲'),
  'cy': Language('cy', 'Cymraeg', 'Welsh', '🏴'),
};
