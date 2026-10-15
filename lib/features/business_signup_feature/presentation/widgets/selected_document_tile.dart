import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';

/// Shows the commercial register the user picked: a preview (or a PDF icon),
/// its name and size, and actions to change or remove it.
class SelectedDocumentTile extends StatelessWidget {
  const SelectedDocumentTile({
    super.key,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    required this.onChange,
    required this.onRemove,
  });

  static const double _previewSize = 56;
  static const Color _successColor = Color(0xFF16A34A);

  final String fileName;
  final String filePath;

  /// In bytes.
  final int fileSize;
  final VoidCallback onChange;
  final VoidCallback onRemove;

  static const Set<String> _imageExtensions = {
    'png',
    'jpg',
    'jpeg',
    'gif',
    'webp',
    'bmp',
    'heic',
    'heif',
  };

  String get _extension {
    final dot = fileName.lastIndexOf('.');
    return dot == -1 ? '' : fileName.substring(dot + 1).toLowerCase();
  }

  String get _formattedSize {
    const kb = 1024;
    if (fileSize < kb * kb) return '${(fileSize / kb).toStringAsFixed(0)} KB';
    return '${(fileSize / (kb * kb)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onChange,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: Colors.black, width: 1.2),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: SizedBox(
                width: _previewSize,
                height: _previewSize,
                child: _buildPreview(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: _successColor,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Flexible(
                        child: Text(
                          '${l10n.tr('business.document_selected')} • '
                          '$_formattedSize',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _successColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.tr('business.change_document'),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: l10n.tr('business.remove_document'),
              onPressed: onRemove,
              icon: const Icon(Icons.close, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A thumbnail for images, an icon for anything else.
  Widget _buildPreview() {
    if (_imageExtensions.contains(_extension)) {
      return Image.file(
        File(filePath),
        fit: BoxFit.cover,
        // Formats Flutter cannot decode (e.g. HEIC on some devices).
        errorBuilder: (_, __, ___) => _buildIconPreview(Icons.image_outlined),
      );
    }
    if (_extension == 'pdf') {
      return _buildIconPreview(Icons.picture_as_pdf_outlined);
    }
    return _buildIconPreview(Icons.insert_drive_file_outlined);
  }

  Widget _buildIconPreview(IconData icon) {
    return ColoredBox(
      color: Colors.white,
      child: Icon(icon, color: Colors.black, size: 28),
    );
  }
}
