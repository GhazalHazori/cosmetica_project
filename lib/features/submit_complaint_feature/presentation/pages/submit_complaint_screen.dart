import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class SubmitComplaintScreen extends StatefulWidget {
  const SubmitComplaintScreen({super.key});

  static const String routeName = '/submit-complaint';

  @override
  State<SubmitComplaintScreen> createState() => _SubmitComplaintScreenState();
}

class _SubmitComplaintScreenState extends State<SubmitComplaintScreen> {
  String? _selectedComplaintType;
  final TextEditingController _detailsController = TextEditingController();
  bool _hasImage = true;
  int _selectedIndex = 4;

  final List<String> _complaintTypes = [
    'تأخير في التوصيل',
    'مشكلة في المنتج',
    'خطأ في الطلب',
    'سلوك مندوب التوصيل',
    'شكوى أخرى',
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    if (_selectedComplaintType == null ||
        _detailsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار نوع الشكوى وكتابة التفاصيل')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال الشكوى بنجاح')),
    );
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text(
            'إرسال شكوى',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _FieldLabel('نوع الشكوى'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                initialValue: _selectedComplaintType,
                
                style: TextStyle(       
                   fontFamily: 'Almarai'
,color: Colors.black),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                decoration: _inputDecoration('اختر نوع الشكوى'),
                items: _complaintTypes
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type, style: const TextStyle(fontSize: 13)),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedComplaintType = value),
              ),
              const SizedBox(height: 24),
              const _FieldLabel('تفاصيل الشكوى'),
              const SizedBox(height: 8),
              TextField(
                controller: _detailsController,
                maxLines: 5,
                style: const TextStyle(fontSize: 13, color: Colors.black),
                decoration: _inputDecoration('اكتب تفاصيل شكواك هنا...').copyWith(
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),
              const _FieldLabel('إرفاق صورة'),
              const SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _hasImage = true),
                    child: _AttachmentTile(
                      icon: Icons.add_a_photo_outlined,
                      label: 'إضافة صورة',
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_hasImage)
                    Stack(
                      children: [
                        const _AttachmentTile(),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => setState(() => _hasImage = false),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.redAccent,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitComplaint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'إرسال الشكوى',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                              fontFamily: 'Almarai'

                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
       
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: const BorderSide(color: Colors.black),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Almarai'
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({this.icon, this.label});

  final IconData? icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: icon == null
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: const Color(0xFF94A3B8), size: 26),
                const SizedBox(height: 6),
                Text(
                  label ?? '',
                  style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
    );
  }
}
