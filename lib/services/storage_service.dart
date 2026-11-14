import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
import '../models/saved_pdf.dart';

class StorageService {
  static const String _kHistoryKey = 'saved_pdf_history_v1';

  /// Save PDF bytes locally to app storage and record in local history
  static Future<SavedPdf> savePdfToLocalAppStorage({
    required Uint8List pdfBytes,
    required String fileName,
    required int pageCount,
  }) async {
    String cleanName = fileName.trim();
    if (!cleanName.toLowerCase().endsWith('.pdf')) {
      cleanName = '$cleanName.pdf';
    }

    String fullPath = cleanName;
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      final pdfsDir = Directory('${dir.path}/generated_pdfs');
      if (!await pdfsDir.exists()) {
        await pdfsDir.create(recursive: true);
      }
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueFileName = '${timestamp}_$cleanName';
      final file = File('${pdfsDir.path}/$uniqueFileName');
      await file.writeAsBytes(pdfBytes, flush: true);
      fullPath = file.path;
    }

    final saved = SavedPdf(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: cleanName,
      filePath: fullPath,
      pageCount: pageCount,
      fileSizeBytes: pdfBytes.length,
      createdAt: DateTime.now(),
    );

    await _recordPdfInHistory(saved);
    return saved;
  }

  /// Retrieve local history of saved PDFs
  static Future<List<SavedPdf>> getLocalHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList(_kHistoryKey) ?? [];
      final list = rawList.map((e) => SavedPdf.fromJson(e)).toList();
      // Sort newest first
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (e) {
      debugPrint('Error reading history: $e');
      return [];
    }
  }

  /// Delete a saved PDF from history and disk
  static Future<void> deletePdf(SavedPdf item) async {
    try {
      if (!kIsWeb && item.filePath.isNotEmpty) {
        final file = File(item.filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList(_kHistoryKey) ?? [];
      final updated = rawList.where((str) {
        try {
          final obj = json.decode(str);
          return obj['id'] != item.id;
        } catch (_) {
          return false;
        }
      }).toList();
      await prefs.setStringList(_kHistoryKey, updated);
    } catch (e) {
      debugPrint('Error deleting PDF: $e');
    }
  }

  /// Clear all local history
  static Future<void> clearAllHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kHistoryKey);
    } catch (e) {
      debugPrint('Error clearing history: $e');
    }
  }

  /// Share PDF file via native platform share dialog
  static Future<void> sharePdf({
    required String filePath,
    required String title,
    Uint8List? rawBytes,
  }) async {
    if (!kIsWeb && filePath.isNotEmpty && await File(filePath).exists()) {
      await Share.shareXFiles(
        [XFile(filePath, mimeType: 'application/pdf', name: title)],
        subject: title,
        text: 'Sharing $title created with Image to PDF Converter.',
      );
    } else if (rawBytes != null) {
      final xFile = XFile.fromData(
        rawBytes,
        mimeType: 'application/pdf',
        name: title,
      );
      await Share.shareXFiles([xFile], subject: title);
    }
  }

  /// Open PDF with default system reader
  static Future<void> openInSystemViewer(String filePath) async {
    if (!kIsWeb && filePath.isNotEmpty) {
      await OpenFilex.open(filePath);
    }
  }

  static Future<void> _recordPdfInHistory(SavedPdf item) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_kHistoryKey) ?? [];
      list.insert(0, item.toJson());
      // Keep up to 50 recent items
      if (list.length > 50) {
        list.removeRange(50, list.length);
      }
      await prefs.setStringList(_kHistoryKey, list);
    } catch (e) {
      debugPrint('Error recording history: $e');
    }
  }
}
