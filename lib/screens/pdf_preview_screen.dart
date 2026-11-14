import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import '../constants/app_theme.dart';
import '../models/saved_pdf.dart';
import '../services/storage_service.dart';

class PdfPreviewScreen extends StatefulWidget {
  final Uint8List pdfBytes;
  final String fileName;
  final int pageCount;

  const PdfPreviewScreen({
    super.key,
    required this.pdfBytes,
    required this.fileName,
    required this.pageCount,
  });

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  SavedPdf? _savedRecord;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _autoSaveToLocalStorage();
  }

  Future<void> _autoSaveToLocalStorage() async {
    setState(() => _isSaving = true);
    try {
      final saved = await StorageService.savePdfToLocalAppStorage(
        pdfBytes: widget.pdfBytes,
        fileName: widget.fileName,
        pageCount: widget.pageCount,
      );
      if (mounted) {
        setState(() {
          _savedRecord = saved;
          _isSaving = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String get _formattedFileSize {
    final bytes = widget.pdfBytes.length;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.fileName.endsWith('.pdf') ? widget.fileName : '${widget.fileName}.pdf',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${widget.pageCount} ${widget.pageCount == 1 ? "page" : "pages"} · $_formattedFileSize · 100% Offline',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Share PDF',
            icon: const Icon(Icons.share_outlined, color: AppTheme.primaryRed),
            onPressed: () {
              StorageService.sharePdf(
                filePath: _savedRecord?.filePath ?? '',
                title: widget.fileName,
                rawBytes: widget.pdfBytes,
              );
            },
          ),
          IconButton(
            tooltip: 'Print',
            icon: const Icon(Icons.print_outlined),
            onPressed: () {
              Printing.layoutPdf(
                onLayout: (PdfPageFormat format) async => widget.pdfBytes,
                name: widget.fileName,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Trust Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceGrey,
              border: Border(bottom: BorderSide(color: AppTheme.borderGrey)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppTheme.successGreen, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _isSaving
                        ? 'Saving locally to device...'
                        : 'PDF successfully generated locally on this device',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textMain,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundWhite,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppTheme.borderGrey),
                  ),
                  child: const Text(
                    'No Cloud',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Interactive PDF preview
          Expanded(
            child: PdfPreview(
              build: (format) => widget.pdfBytes,
              useActions: false, // We supply our own polished native controls
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              scrollViewDecoration: const BoxDecoration(
                color: AppTheme.surfaceGrey,
              ),
              loadingWidget: const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryRed),
              ),
            ),
          ),

          // Bottom Action bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppTheme.backgroundWhite,
              border: Border(top: BorderSide(color: AppTheme.borderGrey)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.home_outlined, size: 18),
                      label: const Text('Home'),
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Share PDF'),
                      onPressed: () {
                        StorageService.sharePdf(
                          filePath: _savedRecord?.filePath ?? '',
                          title: widget.fileName,
                          rawBytes: widget.pdfBytes,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
