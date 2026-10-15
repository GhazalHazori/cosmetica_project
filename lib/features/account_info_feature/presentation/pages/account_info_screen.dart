import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/account_info_entity.dart';
import '../cubit/account_info_cubit.dart';
import '../widgets/account_info_widgets.dart';

/// Expects an [AccountInfoCubit] above it (provided by AppRouter, with the
/// loader overlay).
class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  static const String routeName = '/account-info';

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Fills the form from the server, only after a load or a save so typing
  /// is never overwritten by a rebuild.
  void _fillFields(AccountInfoEntity accountInfo) {
    _fullNameController.text = accountInfo.fullName;
    _emailController.text = accountInfo.email ?? '';
    _phoneController.text = accountInfo.phone;
  }

  void _saveChanges() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AccountInfoCubit>().saveChanges(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
        );
  }

  Future<void> _pickPhoto() async {
    final cubit = context.read<AccountInfoCubit>();
    final result = await FilePicker.pickFiles(type: FileType.image);
    final path = result?.files.single.path;
    if (path == null) return;
    cubit.updatePhoto(path);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'معلومات الحساب',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size(1, 1),
          child: Divider(height: 1, color: Color(0xFFF1F5F9)),
        ),
      ),
      body: BlocConsumer<AccountInfoCubit, AccountInfoState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          final accountInfo = state.accountInfo;
          switch (state.status) {
            case AccountInfoStatus.loaded:
              if (accountInfo != null) _fillFields(accountInfo);
              break;
            case AccountInfoStatus.saved:
              if (accountInfo != null) _fillFields(accountInfo);
              _showMessage(l10n.tr('account.saved'));
              break;
            case AccountInfoStatus.photoUpdated:
              _showMessage(l10n.tr('account.photo_updated'));
              break;
            case AccountInfoStatus.failure:
              final message = state.errorMessage;
              _showMessage(
                message == null || message.isEmpty
                    ? l10n.tr('auth.error_generic')
                    : message,
              );
              break;
            case AccountInfoStatus.initial:
            case AccountInfoStatus.loading:
              break;
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AccountInfoStatus.loading;
          final canEdit = state.accountInfo != null && !isLoading;

          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileImageSection(
                    imageUrl: state.accountInfo?.photoUrl,
                    onCameraTap: canEdit ? _pickPhoto : null,
                  ),
                  const SizedBox(height: 12),
                  EditProfileImageText(onTap: canEdit ? _pickPhoto : null),
                  const SizedBox(height: 32),
                  AccountInfoInputField(
                    label: 'الاسم الكامل',
                    controller: _fullNameController,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? l10n.tr('account.name_required')
                        : null,
                  ),
                  const SizedBox(height: 20),
                  AccountInfoInputField(
                    label: 'البريد الإلكتروني',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      return email.isEmpty || _emailPattern.hasMatch(email)
                          ? null
                          : l10n.tr('account.email_invalid');
                    },
                  ),
                  const SizedBox(height: 20),
                  AccountInfoInputField(
                    label: 'رقم الهاتف',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textDirection: TextDirection.ltr,
                    readOnly: true,
                    helperText: l10n.tr('account.phone_locked'),
                  ),
                  const SizedBox(height: 36),
                  SaveChangesButton(
                    onPressed: _saveChanges,
                    isLoading: !canEdit,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
