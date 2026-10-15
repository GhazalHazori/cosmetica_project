import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../../core/widgets/country_code_picker.dart';
import '../../domain/entities/business_signup_entity.dart';
import '../cubit/business_signup_cubit.dart';
import '../widgets/dotted_border_painter.dart';
import '../widgets/selected_document_tile.dart';
import '../../../../core/theme/app_spacing.dart';

class CompanySignUpPage extends StatefulWidget {
  const CompanySignUpPage({super.key});

  static const String routeName = '/business-signup';

  @override
  State<CompanySignUpPage> createState() => _CompanySignUpPageState();
}

class _CompanySignUpPageState extends State<CompanySignUpPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  static const int _maxDocumentBytes = 10 * 1024 * 1024;

  CountryCode _countryCode = kDefaultCountryCode;
  String? _selectedFileName;
  String? _selectedFilePath;
  int _selectedFileSize = 0;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // The cubit and its success / failure listener are provided by AppRouter.
  @override
  Widget build(BuildContext context) {
    return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: SizedBox.shrink(),
              actions: [ IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.black, size: 28),
                onPressed: () => Navigator.pop(context),
              ),]),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                   
                    const SizedBox(height: 10),
                  Center(
                  child: Image.asset(
                    "assets/images/cosmatica_logo.png",width: 100,height: 100,
                  )
                ),
                    const SizedBox(height: 24),
                    const Text(
                      'إنشاء حساب',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Almarai',
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildInputField(
                      label: 'اسم المستخدم',
                      hint: 'أدخل اسم المستخدم',
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: 'البريد الإلكتروني',
                      hint: 'example@mail.com',
                      controller: _emailController,
                      textDirection: TextDirection.ltr,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: 'رقم الهاتف المحمول',
                      hint: '5X XXX XXXX',
                      controller: _phoneController,
                      textDirection: TextDirection.ltr,
                      keyboardType: TextInputType.phone,
                      prefix: CountryCodeSelector(
                        country: _countryCode,
                        onTap: _selectCountryCode,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'صورة السجل التجاري',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFileUploadBox(),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: 'كلمة المرور',
                      hint: '••••••••',
                      controller: _passwordController,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: 'تأكيد كلمة المرور',
                      hint: '••••••••',
                      controller: _confirmPasswordController,
                      isPassword: true,
                      obscureText: _obscureConfirmPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<BusinessSignupCubit, BusinessSignupState>(
                      builder: (context, state) {
                        final isLoading = state.status == BusinessSignupStatus.loading;
                        return SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleSignup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                                    'إنشاء حساب',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold, fontFamily: 'Almarai',
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'لديك حساب بالفعل؟ ',
                          style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Almarai',),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  /// Any file type; no extension filter, which would grey out gallery
  /// photos in the system picker.
  Future<void> _pickCommercialRegister() async {
    final result = await FilePicker.pickFiles(type: FileType.any);
    final file = result?.files.single;
    if (file == null || file.path == null || !mounted) {
      return;
    }
    if (file.size > _maxDocumentBytes) {
      _showMessage(AppLocalizations.of(context).tr('auth.document_too_large'));
      return;
    }
    setState(() {
      _selectedFileName = file.name;
      _selectedFilePath = file.path;
      _selectedFileSize = file.size;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _removeCommercialRegister() {
    setState(() {
      _selectedFileName = null;
      _selectedFilePath = null;
      _selectedFileSize = 0;
    });
  }

  Future<void> _selectCountryCode() async {
    final CountryCode? selected = await showCountryCodePicker(context);
    if (selected == null || !mounted) {
      return;
    }
    setState(() => _countryCode = selected);
  }

  Widget _buildFileUploadBox() {
    final fileName = _selectedFileName;
    final filePath = _selectedFilePath;
    if (fileName != null && filePath != null) {
      return SelectedDocumentTile(
        fileName: fileName,
        filePath: filePath,
        fileSize: _selectedFileSize,
        onChange: _pickCommercialRegister,
        onRemove: _removeCommercialRegister,
      );
    }

    return InkWell(
      onTap: _pickCommercialRegister,
      child: CustomPaint(
        painter: const DottedBorderPainter(
          color: Colors.black,
          strokeWidth: 1.2,
          gap: 4,
          radius: AppSpacing.radiusMd,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: const Icon(
                  Icons.file_upload_outlined,
                  color: Colors.black,
                  size: 22,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'اضغط لرفع صورة أو ملف السجل التجاري',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '( الحد الأقصى 10 ميجابايت )',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextDirection? textDirection,
    TextInputType? keyboardType,
    Widget? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textDirection: textDirection,
          style: const TextStyle(fontSize: 15, color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            fillColor: Colors.white,
            filled: true,
            hintTextDirection: textDirection,
            hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            prefixIcon: prefix,
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  void _handleSignup() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final localPhone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final l10n = AppLocalizations.of(context);

    if (username.isEmpty ||
        email.isEmpty ||
        localPhone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء ملء جميع الحقول')),
      );
      return;
    }

    final documentPath = _selectedFilePath;
    if (documentPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.tr('auth.document_required'))),
      );
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.tr('auth.password_too_short'))),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمتا المرور غير متطابقتين')),
      );
      return;
    }

    context.read<BusinessSignupCubit>().businessSignup(
          BusinessSignupEntity(
            fullName: username,
            email: email,
            phone: composeInternationalPhone(_countryCode.dialCode, localPhone),
            password: password,
            commercialRegisterFilePath: documentPath,
            language: Localizations.localeOf(context).languageCode,
          ),
        );
  }
}
