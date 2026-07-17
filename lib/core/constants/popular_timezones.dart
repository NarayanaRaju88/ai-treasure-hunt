import 'package:timezone/timezone.dart' as tz;

class PopularTimeZones {
  static const Map<String, String> zones = {
    // Americas
    'America/New_York': '🗽 New York (EST/EDT)',
    'America/Chicago': '🏙️ Chicago (CST/CDT)',
    'America/Denver': '⛰️ Denver (MST/MDT)',
    'America/Los_Angeles': '🌴 Los Angeles (PST/PDT)',
    'America/Anchorage': '🏔️ Anchorage (AKST/AKDT)',
    'Pacific/Honolulu': '🌺 Honolulu (HST)',
    'America/Toronto': '🍁 Toronto (EST/EDT)',
    'America/Mexico_City': '🌮 Mexico City (CST)',
    'America/Sao_Paulo': '🇧🇷 São Paulo (BRT)',
    'America/Buenos_Aires': '🇦🇷 Buenos Aires (ART)',

    // Europe
    'Europe/London': '🇬🇧 London (GMT/BST)',
    'Europe/Dublin': '☘️ Dublin (GMT/IST)',
    'Europe/Paris': '🗼 Paris (CET/CEST)',
    'Europe/Berlin': '🇩🇪 Berlin (CET/CEST)',
    'Europe/Amsterdam': '🚴 Amsterdam (CET/CEST)',
    'Europe/Brussels': '🇧🇪 Brussels (CET/CEST)',
    'Europe/Vienna': '🇦🇹 Vienna (CET/CEST)',
    'Europe/Prague': '🇨🇿 Prague (CET/CEST)',
    'Europe/Rome': '🇮🇹 Rome (CET/CEST)',
    'Europe/Madrid': '🇪🇸 Madrid (CET/CEST)',
    'Europe/Athens': '🇬🇷 Athens (EET/EEST)',
    'Europe/Istanbul': '🕌 Istanbul (EET)',
    'Europe/Moscow': '🇷🇺 Moscow (MSK)',

    // Asia
    'Asia/Dubai': '🏙️ Dubai (GST)',
    'Asia/Kolkata': '🇮🇳 India (IST)',
    'Asia/Bangkok': '🇹🇭 Bangkok (ICT)',
    'Asia/Hong_Kong': '🇭🇰 Hong Kong (HKT)',
    'Asia/Shanghai': '🇨🇳 Shanghai (CST)',
    'Asia/Tokyo': '🗾 Tokyo (JST)',
    'Asia/Seoul': '🇰🇷 Seoul (KST)',
    'Asia/Singapore': '🇸🇬 Singapore (SGT)',
    'Asia/Manila': '🇵🇭 Manila (PST)',
    'Asia/Jakarta': '🇮🇩 Jakarta (WIB)',

    // Australia & Pacific
    'Australia/Perth': '🇦🇺 Perth (AWST)',
    'Australia/Sydney': '🦘 Sydney (AEDT/AEST)',
    'Australia/Brisbane': '🇦🇺 Brisbane (AEST)',
    'Australia/Melbourne': '🇦🇺 Melbourne (AEDT/AEST)',
    'Pacific/Auckland': '🇳🇿 Auckland (NZDT/NZST)',
    'Pacific/Fiji': '🇫🇯 Fiji (FJT)',
    'Pacific/Tongatapu': '🇹🇴 Tonga (TOT)',

    // Africa
    'Africa/Cairo': '🇪🇬 Cairo (EET)',
    'Africa/Johannesburg': '🇿🇦 Johannesburg (SAST)',
    'Africa/Lagos': '🇳🇬 Lagos (WAT)',
    'Africa/Nairobi': '🇰🇪 Nairobi (EAT)',

    // UTC
    'UTC': '🌍 UTC (Coordinated Universal Time)',
  };

  static List<MapEntry<String, String>> getAmerica() {
    return zones.entries
        .where((entry) => entry.key.startsWith('America'))
        .toList();
  }

  static List<MapEntry<String, String>> getEurope() {
    return zones.entries
        .where((entry) => entry.key.startsWith('Europe'))
        .toList();
  }

  static List<MapEntry<String, String>> getAsia() {
    return zones.entries
        .where((entry) => entry.key.startsWith('Asia'))
        .toList();
  }

  static List<MapEntry<String, String>> getAustralia() {
    return zones.entries
        .where((entry) =>
            entry.key.startsWith('Australia') ||
            entry.key.startsWith('Pacific'))
        .toList();
  }

  static List<MapEntry<String, String>> getAfrica() {
    return zones.entries
        .where((entry) => entry.key.startsWith('Africa'))
        .toList();
  }
}
