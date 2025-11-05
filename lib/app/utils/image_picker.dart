import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';

enum ProfileOptionAction { viewImage, profileCamera, library, remove }

class ImagePickerHandler {
  final logger = getLogger("ImagePickerHandler");

  Future<List<XFile>> pickMultipleImages() async {
    try {
      final List<XFile> images = await ImagePicker().pickMultiImage(limit: 3);
      if (images.isEmpty) return [];

      // Process all images in parallel
      final compressedImages = await Future.wait(
        images.map((image) => _compressAndGetFile(image)),
      );

      // Filter out any null values from failed compressions
      return compressedImages.whereType<XFile>().toList();
    } on PlatformException catch (e) {
      logger.e('Failed to pick images: $e');
      return [];
    }
  }

  Future<XFile?> _compressAndGetFile(XFile file) async {
    try {
      // Get the file size in MB
      final fileSize = await file.length() / (1024 * 1024);

      // Only compress if file is larger than 1MB
      if (fileSize < 1) return file;

      // Compress image
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        file.path,
        minWidth: 1200, // Adjust based on your needs
        minHeight: 1200, // Adjust based on your needs
        quality: 85, // 85% quality is a good balance
      );

      if (compressedBytes == null) {
        return file; // Return original if compression fails
      }

      // Create a temporary file for the compressed image
      final tempDir = await getTemporaryDirectory();
      final targetPath =
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final compressedFile = File(targetPath);
      await compressedFile.writeAsBytes(compressedBytes);

      return XFile(compressedFile.path);
    } catch (e) {
      logger.e('Error compressing image: $e');
      return file; // Return original if any error occurs
    }
  }

  Future<void> pickImage({required Function(XFile file) onFilePicked}) async {
    final action = await _showModalBottomSheet();
    if (action != null) {
      final pickedFile = await _handleProfileAction(action);
      if (pickedFile != null) onFilePicked(pickedFile);
    }
  }

  Future<ProfileOptionAction?> _showModalBottomSheet() async {
    final isAndroid = Platform.isAndroid;
    if (isAndroid) {
      return showModalBottomSheet<ProfileOptionAction>(
        context: PageNavigator.context,
        showDragHandle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (context) => _buildAndroidBottomSheet(context),
      );
    } else {
      return showCupertinoModalPopup<ProfileOptionAction>(
        context: PageNavigator.context,
        builder: (context) => _buildIOSActionSheet(context),
      );
    }
  }

  Widget _buildAndroidBottomSheet(BuildContext context) => BottomSheet(
    onClosing: () {},
    builder: (context) => Wrap(
      children: <Widget>[
        _buildListTile(
          context,
          AppString.pickFromLibrary,
          ProfileOptionAction.library,
        ),
        const Divider(),
        _buildListTile(
          context,
          AppString.pickFromPhoto,
          ProfileOptionAction.profileCamera,
        ),
        const Divider(),
        _buildCancelTile(context),
      ],
    ),
  );

  Widget _buildIOSActionSheet(BuildContext context) => CupertinoActionSheet(
    actions: <Widget>[
      Container(
        color: context.cardColor,
        child: _buildCupertinoButton(
          context,
          AppString.pickFromLibrary,
          ProfileOptionAction.library,
        ),
      ),
      Container(
        color: context.cardColor,
        child: _buildCupertinoButton(
          context,
          AppString.pickFromPhoto,
          ProfileOptionAction.profileCamera,
        ),
      ),
    ],
    cancelButton: CupertinoButton(
      color: context.cardColor,
      child: Text(AppString.cancel, style: const TextStyle()),
      onPressed: () => PageNavigator.pop(),
    ),
  );

  ListTile _buildListTile(
    BuildContext context,
    String title,
    ProfileOptionAction action,
  ) => ListTile(
    title: Center(
      child: Text(
        title,
        style: context.headlineLarge?.copyWith(fontSize: 12.sp),
      ),
    ),
    onTap: () => PageNavigator.pop(action),
  );

  InkWell _buildCancelTile(BuildContext context) => InkWell(
    onTap: () => PageNavigator.pop(ProfileOptionAction.remove),
    child: Container(
      padding: const EdgeInsets.all(12.0),
      color: context.cardColor,
      child: Center(child: Text(AppString.cancel, style: const TextStyle())),
    ),
  );

  CupertinoActionSheetAction _buildCupertinoButton(
    BuildContext context,
    String title,
    ProfileOptionAction action,
  ) => CupertinoActionSheetAction(
    child: Text(title, style: context.headlineLarge?.copyWith(fontSize: 12.sp)),
    onPressed: () => PageNavigator.pop(action),
  );

  Future<XFile?> _handleProfileAction(ProfileOptionAction action) async {
    switch (action) {
      case ProfileOptionAction.viewImage:
        return null;
      case ProfileOptionAction.library:
        return _requestPhotoPermission();
      case ProfileOptionAction.profileCamera:
        return _requestCameraPermission();
      case ProfileOptionAction.remove:
        return null;
    }
  }

  Future<XFile?> getImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    try {
      final pickedFile = await imagePicker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 50,
      );
      if (pickedFile != null) return await _cropImage(pickedFile);
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  Future<XFile?> _cropImage(XFile imageFile) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      maxWidth: 1080,
      maxHeight: 1080,
      compressFormat: ImageCompressFormat.png,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Disciple',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(minimumAspectRatio: 1.0),
      ],
    );
    if (croppedImage != null) return _compressImageFiles(croppedImage);
    return null;
  }

  Future<XFile?> _compressImageFiles(CroppedFile file) async {
    final dir = await _findLocalPath();
    final targetPath = "${dir.path}/${_generateKey(15)}.jpg";
    return await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 10,
    );
  }

  Future<Directory> _findLocalPath() async => Platform.isAndroid
      ? await getExternalStorageDirectory() ?? Directory.systemTemp
      : await getApplicationDocumentsDirectory();

  String _generateKey(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  Future<XFile?> _requestPhotoPermission() async =>
      getImage(ImageSource.gallery);

  Future<XFile?> _requestCameraPermission() async =>
      getImage(ImageSource.camera);
}
