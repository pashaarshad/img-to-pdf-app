import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/image_item.dart';

class ImageCard extends StatelessWidget {
  final int pageIndex;
  final int totalCount;
  final ImageItem item;
  final VoidCallback onRotate;
  final VoidCallback onDelete;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  const ImageCard({
    super.key,
    required this.pageIndex,
    required this.totalCount,
    required this.item,
    required this.onRotate,
    required this.onDelete,
    this.onMoveUp,
    this.onMoveDown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Page pill + rotation indicator + delete
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // Page Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRedLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Page ${pageIndex + 1}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryRedDark,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (item.rotationDegrees > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceGrey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${item.rotationDegrees}°',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                const Spacer(),
                // Reorder controls if provided
                if (onMoveUp != null && pageIndex > 0)
                  InkWell(
                    onTap: onMoveUp,
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.arrow_upward, size: 16, color: AppTheme.textSecondary),
                    ),
                  ),
                if (onMoveDown != null && pageIndex < totalCount - 1)
                  InkWell(
                    onTap: onMoveDown,
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.arrow_downward, size: 16, color: AppTheme.textSecondary),
                    ),
                  ),
                const SizedBox(width: 4),
                // Delete
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, size: 16, color: AppTheme.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderGrey),

          // Image preview container
          Expanded(
            child: Container(
              color: AppTheme.surfaceGrey,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              child: RotatedBox(
                quarterTurns: item.rotationDegrees ~/ 90,
                child: Image.memory(
                  item.bytes,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          const Divider(height: 1, color: AppTheme.borderGrey),

          // Bottom Bar: Size & Rotate Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.formattedSize,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: onRotate,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceGrey,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppTheme.borderGrey),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.rotate_right, size: 14, color: AppTheme.primaryRed),
                        SizedBox(width: 4),
                        Text(
                          'Rotate',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textMain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
