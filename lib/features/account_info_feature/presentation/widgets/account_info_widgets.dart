import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class AccountInfoInputField extends StatelessWidget {
  const AccountInfoInputField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.helperText,
    this.keyboardType = TextInputType.text,
    this.textDirection,
    this.readOnly = false,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? helperText;
  final TextInputType keyboardType;
  final TextDirection? textDirection;
  final bool readOnly;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textDirection: textDirection,
          readOnly: readOnly,
          validator: validator,
          style: TextStyle(
            fontSize: 15,
            color: readOnly ? const Color(0xFF64748B) : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            filled: true,
            fillColor: readOnly ? const Color(0xFFF8FAFC) : Colors.white,
            hintStyle: const TextStyle(
              color: Color(0xFFA0AEC0),
              fontSize: 14,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class SaveChangesButton extends StatelessWidget {
  const SaveChangesButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: const Text(
                'حفظ التغييرات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Almarai'
                ),
              ),
      ),
    );
  }
}

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({
    super.key,
    required this.imageUrl,
    this.onCameraTap,
    this.onEditTap,
  });

  final String? imageUrl;
  final VoidCallback? onCameraTap;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: const Color(0xFFF0C8B8),
            backgroundImage: imageUrl != null
                ? NetworkImage(imageUrl!)
                : null,
            child: imageUrl == null
                ? const Icon(Icons.person, size: 60, color: Colors.white)
                : null,
          ),
          GestureDetector(
            onTap: onCameraTap,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfileImageText extends StatelessWidget {
  const EditProfileImageText({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF6C757D),
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text(
        'تعديل الصورة الشخصية',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF8C98A6),
        ),
      ),
    );
  }
}