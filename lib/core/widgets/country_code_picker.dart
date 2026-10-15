import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_spacing.dart';

class CountryCode {
  final String isoCode;
  final String dialCode;
  final String nameAr;

  const CountryCode({
    required this.isoCode,
    required this.dialCode,
    required this.nameAr,
  });

  String get flag {
    return isoCode
        .toUpperCase()
        .codeUnits
        .map((unit) => String.fromCharCode(0x1F1E6 + unit - 65))
        .join();
  }

  bool get hasCustomFlag => isoCode == 'SY';
}

const String kNewSyriaFlagUrl =
    'https://upload.wikimedia.org/wikipedia/commons/5/54/Flag_of_Syria_%282025-%29.svg';

class CountryFlag extends StatelessWidget {
  const CountryFlag({super.key, required this.country, this.size = 20});

  final CountryCode country;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (country.hasCustomFlag) {
      return _NewSyriaFlag(size: size);
    }
    return Text(
      country.flag,
      style: TextStyle(fontSize: size),
    );
  }
}

class _NewSyriaFlag extends StatelessWidget {
  const _NewSyriaFlag({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SvgPicture.network(
        kNewSyriaFlagUrl,
        width: size,
        height: size * 2 / 3,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => SizedBox(
          width: size,
          height: size * 2 / 3,
        ),
        errorBuilder: (_, __, ___) => _NewSyriaFlagFallback(size: size),
      ),
    );
  }
}

class _NewSyriaFlagFallback extends StatelessWidget {
  const _NewSyriaFlagFallback({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        width: size,
        height: size * 2 / 3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: const [
                Expanded(child: ColoredBox(color: Color(0xFF007A3D))),
                Expanded(child: ColoredBox(color: Colors.white)),
                Expanded(child: ColoredBox(color: Colors.black)),
              ],
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  3,
                  (_) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: size * 0.05),
                    child: Icon(
                      Icons.star,
                      size: size * 0.24,
                      color: const Color(0xFFCE1126),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const List<CountryCode> kCountryCodes = <CountryCode>[
  CountryCode(isoCode: 'SA', dialCode: '+966', nameAr: 'السعودية'),
  CountryCode(isoCode: 'AE', dialCode: '+971', nameAr: 'الإمارات'),
  CountryCode(isoCode: 'KW', dialCode: '+965', nameAr: 'الكويت'),
  CountryCode(isoCode: 'QA', dialCode: '+974', nameAr: 'قطر'),
  CountryCode(isoCode: 'BH', dialCode: '+973', nameAr: 'البحرين'),
  CountryCode(isoCode: 'OM', dialCode: '+968', nameAr: 'عُمان'),
  CountryCode(isoCode: 'JO', dialCode: '+962', nameAr: 'الأردن'),
  CountryCode(isoCode: 'EG', dialCode: '+20', nameAr: 'مصر'),
  CountryCode(isoCode: 'IQ', dialCode: '+964', nameAr: 'العراق'),
  CountryCode(isoCode: 'LB', dialCode: '+961', nameAr: 'لبنان'),
  CountryCode(isoCode: 'SY', dialCode: '+963', nameAr: 'سوريا'),
  CountryCode(isoCode: 'YE', dialCode: '+967', nameAr: 'اليمن'),
  CountryCode(isoCode: 'PS', dialCode: '+970', nameAr: 'فلسطين'),
  CountryCode(isoCode: 'LY', dialCode: '+218', nameAr: 'ليبيا'),
  CountryCode(isoCode: 'TN', dialCode: '+216', nameAr: 'تونس'),
  CountryCode(isoCode: 'DZ', dialCode: '+213', nameAr: 'الجزائر'),
  CountryCode(isoCode: 'MA', dialCode: '+212', nameAr: 'المغرب'),
  CountryCode(isoCode: 'SD', dialCode: '+249', nameAr: 'السودان'),
  CountryCode(isoCode: 'TR', dialCode: '+90', nameAr: 'تركيا'),
  CountryCode(isoCode: 'IR', dialCode: '+98', nameAr: 'إيران'),
  CountryCode(isoCode: 'AF', dialCode: '+93', nameAr: 'أفغانستان'),
  CountryCode(isoCode: 'PK', dialCode: '+92', nameAr: 'باكستان'),
  CountryCode(isoCode: 'IN', dialCode: '+91', nameAr: 'الهند'),
  CountryCode(isoCode: 'ID', dialCode: '+62', nameAr: 'إندونيسيا'),
  CountryCode(isoCode: 'MY', dialCode: '+60', nameAr: 'ماليزيا'),
  CountryCode(isoCode: 'CN', dialCode: '+86', nameAr: 'الصين'),
  CountryCode(isoCode: 'RU', dialCode: '+7', nameAr: 'روسيا'),
  CountryCode(isoCode: 'TR', dialCode: '+90', nameAr: 'تركيا'),
  CountryCode(isoCode: 'US', dialCode: '+1', nameAr: 'أمريكا'),
  CountryCode(isoCode: 'CA', dialCode: '+1', nameAr: 'كندا'),
  CountryCode(isoCode: 'GB', dialCode: '+44', nameAr: 'بريطانيا'),
  CountryCode(isoCode: 'FR', dialCode: '+33', nameAr: 'فرنسا'),
  CountryCode(isoCode: 'DE', dialCode: '+49', nameAr: 'ألمانيا'),
  CountryCode(isoCode: 'ES', dialCode: '+34', nameAr: 'إسبانيا'),
  CountryCode(isoCode: 'IT', dialCode: '+39', nameAr: 'إيطاليا'),
  CountryCode(isoCode: 'NL', dialCode: '+31', nameAr: 'هولندا'),
  CountryCode(isoCode: 'SE', dialCode: '+46', nameAr: 'السويد'),
  CountryCode(isoCode: 'CH', dialCode: '+41', nameAr: 'سويسرا'),
  CountryCode(isoCode: 'ZA', dialCode: '+27', nameAr: 'جنوب أفريقيا'),
  CountryCode(isoCode: 'AU', dialCode: '+61', nameAr: 'أستراليا'),
  CountryCode(isoCode: 'BR', dialCode: '+55', nameAr: 'البرازيل'),
  CountryCode(isoCode: 'MX', dialCode: '+52', nameAr: 'المكسيك'),
  CountryCode(isoCode: 'AR', dialCode: '+54', nameAr: 'الأرجنتين'),
];

final CountryCode kDefaultCountryCode = kCountryCodes.first;

Future<CountryCode?> showCountryCodePicker(BuildContext context) {
  return showModalBottomSheet<CountryCode>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const CountryCodePickerSheet(),
  );
}

class CountryCodeSelector extends StatelessWidget {
  const CountryCodeSelector({
    super.key,
    required this.country,
    required this.onTap,
  });

  final CountryCode country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CountryFlag(country: country, size: 20),
            const SizedBox(width: 6),
            Text(
              country.dialCode,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.black, size: 20),
          ],
        ),
      ),
    );
  }
}

class CountryCodePickerSheet extends StatefulWidget {
  const CountryCodePickerSheet({super.key});

  @override
  State<CountryCodePickerSheet> createState() => _CountryCodePickerSheetState();
}

class _CountryCodePickerSheetState extends State<CountryCodePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CountryCode> get _filteredCodes {
    final String query = _query.trim();
    if (query.isEmpty) {
      return kCountryCodes;
    }
    return kCountryCodes
        .where(
          (code) =>
              code.nameAr.contains(query) || code.dialCode.contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'اختر رمز الدولة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                style: const TextStyle(fontSize: 14,color: Colors.black),
                
                decoration: const InputDecoration(
                  hintText: 'ابحث عن الدولة',
                  
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppSpacing.radiusSm)),
                    borderSide: BorderSide(color: Colors.black, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppSpacing.radiusSm)),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: _filteredCodes.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final CountryCode code = _filteredCodes[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CountryFlag(country: code, size: 26),
                      title: Text(
                        code.nameAr,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Text(
                        code.dialCode,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () => Navigator.pop(context, code),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
