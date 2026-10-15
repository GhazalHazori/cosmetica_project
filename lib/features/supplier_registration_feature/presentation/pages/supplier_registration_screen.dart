import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class SupplierRegistrationScreen extends StatefulWidget {
  const SupplierRegistrationScreen({super.key});

  static const String routeName = '/supplier-registration';

  @override
  State<SupplierRegistrationScreen> createState() =>
      _SupplierRegistrationScreenState();
}

class _SupplierRegistrationScreenState
    extends State<SupplierRegistrationScreen> {
  final _fullNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedProductCountRange;

  bool _hasCommercialRegister = true;
  bool _hasBrand = true;
  bool _isImporter = true;
  bool _isFreeImporter = false;
  bool _isLocalAgent = true;
  bool _isGeneralAgent = false;
  bool _isBrandOwner = false;
  bool _isAgreed = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _companyNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
           elevation: 0,
          actions:[ IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),],
        
          leading: SizedBox.shrink(),
              bottom: PreferredSize(preferredSize: Size(1, 1), child:     const Divider(height: 1, color: Color(0xFFF1F5F9)),
),
          title: const Column(
            children: [
              Text(
                'انضم إلينا كمورد',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'شراكة النجاح والنمو في كوزماتيكا',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/cosmatica_logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Text(
                    'COSMETICA',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'نموذج تسجيل الموردين والشركاء',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'يسرنا انضمامك لشريكة موردي كوزماتيكا. يرجى تزويدنا بالبيانات\nالتالية لمراجعة طلبكم والبدء في إجراءات الشراكة.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              const _SectionHeader(
                icon: Icons.card_travel,
                title: 'المعلومات الأساسية',
              ),
              const SizedBox(height: 16),
              _InputField(
                label: 'الاسم الكامل *',
                hint: 'أدخل الاسم الثلاثي للشخص المسؤول',
                controller: _fullNameController,
              ),
              const SizedBox(height: 12),
              _InputField(
                label: 'اسم الشركة / المؤسسة *',
                hint: 'أدخل الاسم التجاري المعتمد',
                controller: _companyNameController,
              ),
              const SizedBox(height: 12),
              _InputField(
                label: 'رقم الموبايل للتواصل *',
                hint: '+963 9XX XXX XXX',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 12),
              _ProductCountField(
                value: _selectedProductCountRange,
                onChanged: (value) {
                  setState(() => _selectedProductCountRange = value);
                },
              ),
              const SizedBox(height: 28),
              const _SectionHeader(
                icon: Icons.assignment_outlined,
                title: 'بيانات النشاط والصفة التجارية',
              ),
              const SizedBox(height: 16),
              _QuestionToggleCard(
                title: 'هل تملك سجل تجاري؟',
                subtitle: 'سجل تجاري نظامي ساري المفعول',
                value: _hasCommercialRegister,
                onChanged: (value) =>
                    setState(() => _hasCommercialRegister = value),
              ),
              const SizedBox(height: 10),
              _QuestionToggleCard(
                title: 'هل تملك اسم علامة تجارية (ماركة) خاصة بك؟',
                subtitle: 'علامة تجارية مسجلة أو تحت التسجيل',
                value: _hasBrand,
                onChanged: (value) => setState(() => _hasBrand = value),
              ),
              const SizedBox(height: 10),
              _QuestionToggleCard(
                title: 'هل أنت مستورد للمنتجات؟',
                subtitle: 'استيراد مباشر من الخارج',
                value: _isImporter,
                onChanged: (value) => setState(() => _isImporter = value),
              ),
              const SizedBox(height: 10),
              _QuestionToggleCard(
                title: 'هل أنت مستورد حر للمنتجات؟',
                subtitle: 'استيراد بضائع متنوعة دون وكالة حصرية',
                value: _isFreeImporter,
                onChanged: (value) => setState(() => _isFreeImporter = value),
              ),
              const SizedBox(height: 10),
              _QuestionToggleCard(
                title: 'وكيل معتمد في محافظة لـماركة؟',
                subtitle: 'وكالة توزيع محلية على مستوى المحافظة',
                value: _isLocalAgent,
                onChanged: (value) => setState(() => _isLocalAgent = value),
              ),
              const SizedBox(height: 10),
              _QuestionToggleCard(
                title: 'وكيل عام معتمد في سوريا؟',
                subtitle: 'الوكالة الرسمية الحصرية على مستوى القطر',
                value: _isGeneralAgent,
                onChanged: (value) => setState(() => _isGeneralAgent = value),
              ),
              const SizedBox(height: 10),
              _QuestionToggleCard(
                title: 'أنت صاحب العلامة التجارية والمصنع؟',
                subtitle: 'نملك خط إنتاج وتصنيع خاص بك',
                value: _isBrandOwner,
                onChanged: (value) => setState(() => _isBrandOwner = value),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isAgreed,
                      checkColor: Colors.white,
                      activeColor: Colors.black,
                      onChanged: (value) =>
                          setState(() => _isAgreed = value ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        'أقر بأن كافة البيانات والمعلومات الواردة أعلاه صحيحة ودقيقة، وأوافق على شروط وسياسة انضمام الموردين في كوزماتيكا.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF475569),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isAgreed ? _submit : null,
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                  label: const Text(
                    'إرسال طلب الانضمام',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                        fontFamily: 'Almarai',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'سيتم مراجعة طلبكم والتواصل معكم عبر رقم الموبايل خلال 24 - 48 ساعة عمل.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال طلب الانضمام بنجاح')),
    );
  }
}

class _ProductCountField extends StatelessWidget {
  const _ProductCountField({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'عدد المنتجات التقديري لديك *',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
          decoration: InputDecoration(
            hintText: 'اختر النطاق التقديري لعدد المنتجات',
            hintStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8),
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: Colors.black),
            ),
          ),
          items: ['١ - ١٠', '١١ - ٥٠', '٥١ - ٢٠٠', 'أكثر من ٢٠٠']
              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        Row(
          children: [
             Icon(icon, size: 18, color: Colors.black),
        const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Divider(color: Color(0xFFE2E8F0), thickness: 1),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textDirection,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textDirection: textDirection,
          style: const TextStyle(fontSize: 13, color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8),
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionToggleCard extends StatelessWidget {
  const _QuestionToggleCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
        
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
            Row(
            children: [
              _ToggleButton(
                text: 'لا',
                isSelected: !value,
                onTap: () => onChanged(false),
              ),
              const SizedBox(width: 6),
              _ToggleButton(
                text: 'نعم',
                isSelected: value,
                onTap: () => onChanged(true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
