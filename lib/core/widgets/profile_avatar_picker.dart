import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAvatarPicker extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final ValueChanged<File> onImagePicked;
  final bool isUploading;
  final double radius;
  final bool showEditBadge;

  const ProfileAvatarPicker({
    super.key,
    this.imageUrl,
    this.name,
    required this.onImagePicked,
    this.isUploading = false,
    this.radius = 54,
    this.showEditBadge = true,
  });

  static String getInitials(String? name) {
    if (name == null || name.trim().isEmpty) {
      return '';
    }

    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return '';

    if (words.length >= 2) {
      final firstLetter = words[0].characters.first;
      final secondLetter = words[1].characters.first;
      return '$firstLetter$secondLetter'.toUpperCase();
    } else {
      final singleWord = words[0];
      if (singleWord.characters.length >= 2) {
        return singleWord.characters.take(2).toString().toUpperCase();
      } else {
        return singleWord.toUpperCase();
      }
    }
  }

  Future<void> _showPickImageBottomSheet(BuildContext context) async {
    if (isUploading) return;

    final picker = ImagePicker();

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.s24),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s20,
              vertical: AppSizes.s24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSizes.s20),
                  decoration: BoxDecoration(
                    color: AppColors.borderStrong,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  "تغيير الصورة الشخصية",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.s20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(AppSizes.s12),
                    decoration: const BoxDecoration(
                      color: AppColors.primary100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.photo_camera_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    "التقاط صورة بواسطة الكاميرا",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onTap: () async {
                    AppNavigator.pop(context: bottomSheetContext);
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 85,
                      maxWidth: 1024,
                      maxHeight: 1024,
                    );
                    if (pickedFile != null) {
                      onImagePicked(File(pickedFile.path));
                    }
                  },
                ),
                const SizedBox(height: AppSizes.s8),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(AppSizes.s12),
                    decoration: const BoxDecoration(
                      color: AppColors.primary100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.photo_library_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    "اختيار من المعرض",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onTap: () async {
                    AppNavigator.pop(context: bottomSheetContext);
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                      maxWidth: 1024,
                      maxHeight: 1024,
                    );
                    if (pickedFile != null) {
                      onImagePicked(File(pickedFile.path));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final initials = getInitials(name);

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary500,
            AppColors.primary800,
          ],
        ),
      ),
      child: Center(
        child: initials.isNotEmpty
            ? Text(
                initials,
                style: TextStyle(
                  fontSize: radius * 0.65,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              )
            : Icon(
                Icons.person_rounded,
                size: radius * 1.1,
                color: Colors.white.withValues(alpha: 0.9),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasValidUrl = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Center(
      child: GestureDetector(
        onTap: () => _showPickImageBottomSheet(context),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary300,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: SizedBox(
                  width: radius * 2,
                  height: radius * 2,
                  child: hasValidUrl
                      ? CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.backgroundMuted,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              _buildPlaceholder(context),
                        )
                      : _buildPlaceholder(context),
                ),
              ),
            ),
            if (isUploading)
              Container(
                width: (radius * 2) + 6,
                height: (radius * 2) + 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.45),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            if (showEditBadge && !isUploading)
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.s8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    border: Border.all(
                      color: AppColors.surface,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
