import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_theme.dart';
import '../models/image_item.dart';
import '../models/saved_pdf.dart';
import '../services/storage_service.dart';
import '../widgets/brand_logo.dart';
import 'about_screen.dart';
import 'editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  List<SavedPdf> _recentPdfs = [];
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadRecentPdfs();
  }

  Future<void> _loadRecentPdfs() async {
    setState(() => _isLoadingHistory = true);
    final list = await StorageService.getLocalHistory();
    if (mounted) {
      setState(() {
        _recentPdfs = list;
        _isLoadingHistory = false;
      });
    }
  }

  Future<void> _pickImages(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final photo = await _picker.pickImage(source: ImageSource.camera);
        if (photo != null) {
          final bytes = await photo.readAsBytes();
          _navigateToEditor([
            ImageItem(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: photo.name,
              path: photo.path,
              bytes: bytes,
              sizeInBytes: bytes.length,
            ),
          ]);
        }
      } else {
        final picked = await _picker.pickMultiImage();
        if (picked.isNotEmpty) {
          final List<ImageItem> items = [];
          for (final file in picked) {
            final bytes = await file.readAsBytes();
            items.add(
              ImageItem(
                id: '${DateTime.now().millisecondsSinceEpoch}_${file.name}',
                name: file.name,
                path: file.path,
                bytes: bytes,
                sizeInBytes: bytes.length,
              ),
            );
          }
          _navigateToEditor(items);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting images: $e'),
            backgroundColor: AppTheme.primaryRed,
          ),
        );
      }
    }
  }

  /// Creates 2 sample invoice/document pages on-the-fly for quick instant testing
  Future<void> _generateSampleImages() async {
    final List<ImageItem> sampleItems = [];

    for (int i = 1; i <= 2; i++) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 800, 1100));

      // White background
      final bgPaint = Paint()..color = const Color(0xFFFFFFFF);
      canvas.drawRect(const Rect.fromLTWH(0, 0, 800, 1100), bgPaint);

      // Red header banner
      final headerPaint = Paint()..color = const Color(0xFFE5322D);
      canvas.drawRect(const Rect.fromLTWH(0, 0, 800, 120), headerPaint);

      // Draw Header Text
      final headerText = TextPainter(
        text: TextSpan(
          text: 'SAMPLE DOCUMENT #$i',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      headerText.paint(canvas, const Offset(40, 44));

      // Draw document body lines & title
      final bodyTitle = TextPainter(
        text: TextSpan(
          text: 'Official Image to PDF Converter - Sample Page $i',
          style: const TextStyle(
            color: Color(0xFF242424),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      bodyTitle.paint(canvas, const Offset(40, 160));

      final bodySubtitle = TextPainter(
        text: const TextSpan(
          text: 'AP Programming Tech™ · 100% Free · No Ads · Offline',
          style: TextStyle(
            color: Color(0xFFE5322D),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      bodySubtitle.paint(canvas, const Offset(40, 200));

      // Document simulation lines
      final linePaint = Paint()
        ..color = const Color(0xFFEAEAEA)
        ..strokeWidth = 3;

      for (int y = 260; y <= 980; y += 45) {
        canvas.drawLine(Offset(40, y.toDouble()), Offset(760, y.toDouble()), linePaint);
      }

      // Border outline
      final borderPaint = Paint()
        ..color = const Color(0xFFEAEAEA)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(const Rect.fromLTWH(0, 0, 800, 1100), borderPaint);

      final picture = recorder.endRecording();
      final img = await picture.toImage(800, 1100);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final bytes = byteData.buffer.asUint8List();
        sampleItems.add(
          ImageItem(
            id: 'sample_$i',
            name: 'Sample_Document_Page_$i.png',
            bytes: bytes,
            sizeInBytes: bytes.length,
          ),
        );
      }
    }

    _navigateToEditor(sampleItems);
  }

  void _navigateToEditor(List<ImageItem> images) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditorScreen(initialImages: images),
      ),
    );
    _loadRecentPdfs();
  }

  void _deleteRecentPdf(SavedPdf item) async {
    await StorageService.deletePdf(item);
    _loadRecentPdfs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Row(
          children: const [
            BrandLogo(size: 32),
            SizedBox(width: 10),
            Text(
              'Image to PDF',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'About & Privacy',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.primaryRed,
        onRefresh: _loadRecentPdfs,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // Trust & Tagline banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Your images. One perfect PDF.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMain,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Create professional PDFs from your images. Simple, secure and completely free.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 12),
                  TrustBadgesRow(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Hero Conversion Action Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderGrey, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const BrandLogo(size: 64),
                  const SizedBox(height: 14),
                  const Text(
                    'Convert Images to PDF',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Select photos, arrange order, set layout and export',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Big Red Primary Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library, size: 20),
                      label: const Text('Select Images'),
                      onPressed: () => _pickImages(ImageSource.gallery),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Secondary Button: Camera
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.camera_alt_outlined, size: 18),
                          label: const Text('Camera'),
                          onPressed: () => _pickImages(ImageSource.camera),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.auto_awesome, size: 18, color: AppTheme.primaryRed),
                          label: const Text('Try Sample'),
                          onPressed: _generateSampleImages,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Conversions Section
            Row(
              children: [
                const Text(
                  'Recent Conversions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textMain,
                  ),
                ),
                const SizedBox(width: 8),
                if (_recentPdfs.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceGrey,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.borderGrey),
                    ),
                    child: Text(
                      '${_recentPdfs.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                const Spacer(),
                if (_recentPdfs.isNotEmpty)
                  TextButton(
                    onPressed: () async {
                      await StorageService.clearAllHistory();
                      _loadRecentPdfs();
                    },
                    child: const Text('Clear All'),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            if (_isLoadingHistory)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(color: AppTheme.primaryRed),
                ),
              )
            else if (_recentPdfs.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceGrey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderGrey),
                ),
                child: Column(
                  children: const [
                    Icon(
                      Icons.picture_as_pdf_outlined,
                      size: 40,
                      color: AppTheme.textDisabled,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No documents converted yet',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMain,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Select images above to generate your first offline PDF.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ..._recentPdfs.map((pdf) => _RecentPdfCard(
                    item: pdf,
                    onDelete: () => _deleteRecentPdf(pdf),
                  )),
            const SizedBox(height: 24),

            // Footer branding
            Center(
              child: Column(
                children: const [
                  Text(
                    'Created with care by AP Programming Tech™',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '© 2026 AP Programming Tech · MIT License',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textDisabled,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _RecentPdfCard extends StatelessWidget {
  final SavedPdf item;
  final VoidCallback onDelete;

  const _RecentPdfCard({
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderGrey),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 40,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.primaryRedLight,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppTheme.borderGrey),
          ),
          child: const Center(
            child: Icon(
              Icons.picture_as_pdf,
              color: AppTheme.primaryRed,
              size: 22,
            ),
          ),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textMain,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${item.pageCount} ${item.pageCount == 1 ? "page" : "pages"} · ${item.formattedSize} · ${_formatDate(item.createdAt)}',
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.share_outlined, size: 20, color: AppTheme.textSecondary),
              tooltip: 'Share',
              onPressed: () {
                StorageService.sharePdf(
                  filePath: item.filePath,
                  title: item.title,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: AppTheme.textSecondary),
              tooltip: 'Delete',
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: () {
          StorageService.openInSystemViewer(item.filePath);
        },
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
