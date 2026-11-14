import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/pdf_config.dart';

class PdfOptionsBottomSheet extends StatefulWidget {
  final PdfConfig initialConfig;
  final ValueChanged<PdfConfig> onSave;

  const PdfOptionsBottomSheet({
    super.key,
    required this.initialConfig,
    required this.onSave,
  });

  static Future<PdfConfig?> show(
    BuildContext context, {
    required PdfConfig initialConfig,
  }) {
    return showModalBottomSheet<PdfConfig>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.backgroundWhite,
      builder: (ctx) => PdfOptionsBottomSheet(
        initialConfig: initialConfig,
        onSave: (cfg) => Navigator.of(ctx).pop(cfg),
      ),
    );
  }

  @override
  State<PdfOptionsBottomSheet> createState() => _PdfOptionsBottomSheetState();
}

class _PdfOptionsBottomSheetState extends State<PdfOptionsBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _pwdController;
  late PdfPageFormatType _pageFormat;
  late PdfOrientationType _orientation;
  late PdfMarginType _margin;
  late PdfCompressionType _compression;
  late bool _isGrayscale;
  late bool _showPageNumbers;
  bool _enablePassword = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialConfig.fileName);
    _pageFormat = widget.initialConfig.pageFormat;
    _orientation = widget.initialConfig.orientation;
    _margin = widget.initialConfig.margin;
    _compression = widget.initialConfig.compression;
    _isGrayscale = widget.initialConfig.isGrayscale;
    _showPageNumbers = widget.initialConfig.showPageNumbers;
    _enablePassword = widget.initialConfig.password != null &&
        widget.initialConfig.password!.isNotEmpty;
    _pwdController = TextEditingController(
      text: widget.initialConfig.password ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final updated = widget.initialConfig.copyWith(
      fileName: _nameController.text.trim().isEmpty
          ? 'Document_${DateTime.now().millisecondsSinceEpoch}'
          : _nameController.text.trim(),
      pageFormat: _pageFormat,
      orientation: _orientation,
      margin: _margin,
      compression: _compression,
      isGrayscale: _isGrayscale,
      showPageNumbers: _showPageNumbers,
      password: _enablePassword && _pwdController.text.isNotEmpty
          ? _pwdController.text
          : null,
    );
    widget.onSave(updated);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top grab handle & header
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    'PDF Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMain,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppTheme.borderGrey),

            // Scrollable settings list
            Flexible(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // File Name
                  const _SectionTitle(title: 'File Name'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Invoices_Nov2026',
                      prefixIcon: const Icon(
                        Icons.description_outlined,
                        color: AppTheme.primaryRed,
                        size: 20,
                      ),
                      suffixText: '.pdf',
                      suffixStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Page Format
                  const _SectionTitle(title: 'Page Format'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: PdfPageFormatType.values.map((fmt) {
                      final selected = _pageFormat == fmt;
                      return ChoiceChip(
                        label: Text(fmt.label),
                        selected: selected,
                        onSelected: (val) {
                          if (val) setState(() => _pageFormat = fmt);
                        },
                        selectedColor: AppTheme.primaryRed,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : AppTheme.textMain,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 13,
                        ),
                        backgroundColor: AppTheme.surfaceGrey,
                        side: BorderSide(
                          color: selected ? AppTheme.primaryRed : AppTheme.borderGrey,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // Page Orientation
                  const _SectionTitle(title: 'Page Orientation'),
                  const SizedBox(height: 8),
                  Row(
                    children: PdfOrientationType.values.map((ori) {
                      final selected = _orientation == ori;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: InkWell(
                            onTap: () => setState(() => _orientation = ori),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selected ? AppTheme.primaryRedLight : AppTheme.surfaceGrey,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selected ? AppTheme.primaryRed : AppTheme.borderGrey,
                                  width: selected ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    ori == PdfOrientationType.portrait
                                        ? Icons.portrait
                                        : ori == PdfOrientationType.landscape
                                            ? Icons.landscape
                                            : Icons.auto_awesome,
                                    size: 18,
                                    color: selected ? AppTheme.primaryRed : AppTheme.textSecondary,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ori.label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: selected ? AppTheme.primaryRedDark : AppTheme.textMain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // Margins
                  const _SectionTitle(title: 'Page Margin'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: PdfMarginType.values.map((m) {
                      final selected = _margin == m;
                      return ChoiceChip(
                        label: Text(m.label),
                        selected: selected,
                        onSelected: (val) {
                          if (val) setState(() => _margin = m);
                        },
                        selectedColor: AppTheme.primaryRed,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : AppTheme.textMain,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 13,
                        ),
                        backgroundColor: AppTheme.surfaceGrey,
                        side: BorderSide(
                          color: selected ? AppTheme.primaryRed : AppTheme.borderGrey,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // Quality & Compression
                  const _SectionTitle(title: 'Image Quality & Compression'),
                  const SizedBox(height: 8),
                  ...PdfCompressionType.values.map((comp) {
                    final selected = _compression == comp;
                    return RadioListTile<PdfCompressionType>(
                      value: comp,
                      groupValue: _compression,
                      onChanged: (val) {
                        if (val != null) setState(() => _compression = val);
                      },
                      activeColor: AppTheme.primaryRed,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(
                        comp.label,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                          color: AppTheme.textMain,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 10),

                  // Toggles
                  SwitchListTile(
                    value: _isGrayscale,
                    onChanged: (val) => setState(() => _isGrayscale = val),
                    activeThumbColor: AppTheme.primaryRed,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Black & White / Grayscale',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'Ideal for document scans, receipts and reduced file size',
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ),
                  SwitchListTile(
                    value: _showPageNumbers,
                    onChanged: (val) => setState(() => _showPageNumbers = val),
                    activeThumbColor: AppTheme.primaryRed,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Show Page Numbers',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'Adds "Page X of Y" at the bottom of each page',
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom action bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: AppTheme.backgroundWhite,
                border: Border(top: BorderSide(color: AppTheme.borderGrey)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      child: const Text('Apply Settings'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppTheme.textMain,
        letterSpacing: -0.2,
      ),
    );
  }
}
