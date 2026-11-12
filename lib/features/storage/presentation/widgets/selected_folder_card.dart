import 'package:flutter/material.dart';
import '../../domain/entities/storage_info.dart';

class SelectedFolderCard extends StatelessWidget {
  const SelectedFolderCard({super.key, required this.storageInfo});

  final StorageInfo storageInfo;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _descColor = Color(0xFF806A60);
  static const Color _greenBadgeBg = Color(0xFFE8F5E9);
  static const Color _greenBadgeText = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFEADBCE)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF38251F).withValues(alpha: 0.05),
            blurRadius: 14.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE2CC),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: const Icon(
                  Icons.folder_shared_rounded,
                  color: _primaryOrange,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storageInfo.folderName,
                      style: const TextStyle(
                        color: _titleColor,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      storageInfo.pathDisplay ?? 'Local SAF Storage',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _descColor, fontSize: 13.0),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: _greenBadgeBg,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  'Connected',
                  style: TextStyle(
                    color: _greenBadgeText,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14.0),
          const Divider(height: 1.0, color: Color(0xFFF0E5DC)),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Permission Status',
                style: TextStyle(color: _descColor, fontSize: 13.0),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    storageInfo.isWritable
                        ? Icons.check_circle_rounded
                        : Icons.warning_rounded,
                    color: storageInfo.isWritable
                        ? _greenBadgeText
                        : Colors.orange,
                    size: 16.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    storageInfo.isWritable
                        ? 'Read & Write Granted'
                        : 'Read Only',
                    style: TextStyle(
                      color: storageInfo.isWritable
                          ? _greenBadgeText
                          : Colors.orange,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
