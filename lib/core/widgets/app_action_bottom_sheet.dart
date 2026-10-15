import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// One button of [showAppActionBottomSheet]; the sheet resolves to [value].
class AppSheetAction<T> {
  const AppSheetAction({
    required this.label,
    required this.value,
    this.isPrimary = false,
  });

  final String label;
  final T value;

  /// Filled black button; otherwise outlined.
  final bool isPrimary;
}

/// A bottom sheet in the app's style: icon, title, message and a column of
/// actions. Resolves to the chosen action's value, or `null` when dismissed.
Future<T?> showAppActionBottomSheet<T>(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String message,
  required List<AppSheetAction<T>> actions,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AppActionSheet<T>(
      icon: icon,
      title: title,
      message: message,
      actions: actions,
    ),
  );
}

class _AppActionSheet<T> extends StatelessWidget {
  const _AppActionSheet({
    required this.icon,
    required this.title,
    required this.message,
    required this.actions,
  });

  final IconData icon;
  final String title;
  final String message;
  final List<AppSheetAction<T>> actions;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.black, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              for (final action in actions) ...[
                _buildButton(context, action),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, AppSheetAction<T> action) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
    );
    final label = Text(
      action.label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: action.isPrimary ? Colors.white : Colors.black,
        fontFamily: 'Almarai',
      ),
    );
    void onPressed() => Navigator.pop(context, action.value);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: action.isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: shape,
              ),
              child: label,
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: shape,
              ),
              child: label,
            ),
    );
  }
}
