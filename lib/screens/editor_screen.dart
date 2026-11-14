import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_theme.dart';
import '../models/image_item.dart';
import '../models/pdf_config.dart';
import '../services/pdf_generator_service.dart';
import '../widgets/image_card.dart';
import '../widgets/pdf_options_bottom_sheet.dart';
import 'pdf_preview_screen.dart';

class EditorScreen extends StatefulWidget {
  final List<ImageItem> initialImages;

  const EditorScreen({
    super.key,
    required this.initialImages,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late List<ImageItem> _images;
  late PdfConfig _config;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.initialImages);
    final now = DateTime.now();
    final defaultName =
        'PDF_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
    _config = PdfConfig(fileName: defaultName);
  }

  Future<void> _pickMoreImages(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final photo = await _picker.pickImage(source: ImageSource.camera);
        if (photo != null) {
          final bytes = await photo.readAsBytes();
          setState(() {
            _images.add(
              ImageItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: photo.name,
                path: photo.path,
                bytes: bytes,
                sizeInBytes: bytes.length,
              ),
            );
          });
        }
      } else {
        final picked = await _picker.pickMultiImage();
        if (picked.isNotEmpty) {
          for (final file in picked) {
            final bytes = await file.readAsBytes();
            _images.add(
              ImageItem(
                id: '${DateTime.now().millisecondsSinceEpoch}_${file.name}',
                name: file.name,
                path: file.path,
                bytes: bytes,
                sizeInBytes: bytes.length,
              ),
            );
          }
          setState(() {});
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding images: $e')),
        );
      }
    }
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundWhite,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppTheme.primaryRed),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Add one or multiple pictures'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickMoreImages(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppTheme.primaryRed),
                title: const Text('Take Photo with Camera'),
                subtitle: const Text('Snap a new document page'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickMoreImages(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _rotateAll() {
    setState(() {
      for (final img in _images) {
        img.rotateRight();
      }
    });
  }

  void _moveUp(int index) {
    if (index <= 0) return;
    setState(() {
      final item = _images.removeAt(index);
      _images.insert(index - 1, item);
    });
  }

  void _moveDown(int index) {
    if (index >= _images.length - 1) return;
    setState(() {
      final item = _images.removeAt(index);
      _images.insert(index + 1, item);
    });
  }

  void _deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    if (_images.isEmpty) {
      Navigator.of(context).pop();
    }
  }

  void _openSettings() async {
    final updated = await PdfOptionsBottomSheet.show(
      context,
      initialConfig: _config,
    );
    if (updated != null) {
      setState(() => _config = updated);
    }
  }

  Future<void> _startConversion() async {
    if (_images.isEmpty) return;

    double currentProgress = 0.0;
    String currentStatus = 'Preparing images...';
    StateSetter? dialogSetState;

    // Show conversion modal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            dialogSetState = setModalState;
            return AlertDialog(
              backgroundColor: AppTheme.backgroundWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppTheme.borderGrey),
              ),
              title: Row(
                children: const [
                  Icon(Icons.picture_as_pdf, color: AppTheme.primaryRed, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Creating PDF',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMain,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: currentProgress,
                      backgroundColor: AppTheme.surfaceGrey,
                      color: AppTheme.primaryRed,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentStatus,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '100% on-device processing. No internet used.',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    try {
      final pdfBytes = await PdfGeneratorService.generatePdf(
        images: _images,
        config: _config,
        onProgress: (p, s) {
          if (dialogSetState != null) {
            dialogSetState!(() {
              currentProgress = p;
              currentStatus = s;
            });
          }
        },
      );

      // Dismiss dialog
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Navigate to preview
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PdfPreviewScreen(
              pdfBytes: pdfBytes,
              fileName: _config.fileName,
              pageCount: _images.length,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: AppTheme.primaryRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Arrange & Edit'),
            Text(
              '${_images.length} ${_images.length == 1 ? "page" : "pages"} selected',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Rotate All Pages',
            icon: const Icon(Icons.rotate_right),
            onPressed: _rotateAll,
          ),
          IconButton(
            tooltip: 'Add More Images',
            icon: const Icon(Icons.add_photo_alternate_outlined),
            onPressed: _showAddSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Settings pill bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceGrey,
              border: Border(bottom: BorderSide(color: AppTheme.borderGrey)),
            ),
            child: InkWell(
              onTap: _openSettings,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundWhite,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderGrey),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tune_outlined, size: 16, color: AppTheme.primaryRed),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_config.pageFormat.label} · ${_config.orientation.label} · ${_config.compression.label.split(" ").first} Quality',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textMain,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 18, color: AppTheme.textSecondary),
                  ],
                ),
              ),
            ),
          ),

          // Images list / grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final item = _images[index];
                return ImageCard(
                  pageIndex: index,
                  totalCount: _images.length,
                  item: item,
                  onRotate: () => setState(() => item.rotateRight()),
                  onDelete: () => _deleteImage(index),
                  onMoveUp: () => _moveUp(index),
                  onMoveDown: () => _moveDown(index),
                );
              },
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
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Images'),
                    onPressed: _showAddSheet,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf, size: 18),
                      label: Text('Convert (${_images.length} Pages)'),
                      onPressed: _startConversion,
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
