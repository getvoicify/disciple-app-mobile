import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/app/utils/field_validator.dart';
import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/presentation/notifier/note_notifier.dart';
import 'package:disciple/widgets/back_arrow_widget.dart';
import 'package:disciple/widgets/drop_down_widget.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/elevated_button_widget.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class NewNotesView extends ConsumerStatefulWidget {
  const NewNotesView({super.key});

  @override
  ConsumerState<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends ConsumerState<NewNotesView> {
  final TextEditingController _titleContoller = TextEditingController();
  final TextEditingController _detailContoller = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _detailFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleContoller.dispose();
    _detailContoller.dispose();
    _titleFocusNode.dispose();
    _detailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(AppString.newNote),
      leading: const BackArrowWidget(),
    ),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          children: [
            EditTextFieldWidget(
              title: AppString.title,
              controller: _titleContoller,
              focusNode: _titleFocusNode,
              validator: FieldValidator.validateString(),
            ),
            SizedBox(height: 14.h),
            Text(
              AppString.addScripture,
              style: context.headlineLarge?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                border: BoxBorder.all(color: AppColors.grey200, width: 1.w),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildDropdownWidget(title: AppString.kjv),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BuildDropdownWidget(title: 'Book'),
                      const BuildDropdownWidget(title: 'Chapter'),
                      const BuildDropdownWidget(title: 'Verse'),
                      BuildDropdownWidget(
                        title: 'Add',
                        dropdown: false,
                        color: AppColors.purple,
                        borderColor: AppColors.purple,
                        textColor: AppColors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 4.h,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            EditTextFieldWidget(
              title: AppString.noteDetails,
              maxLines: 20,
              controller: _detailContoller,
              focusNode: _detailFocusNode,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              validator: FieldValidator.validateString(),
            ),
            SizedBox(height: 14.h),

            RichText(
              text: TextSpan(
                text: AppString.addImages,
                style: context.headlineLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: ' (optional)',
                    style: context.headlineLarge?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                border: BoxBorder.all(color: AppColors.grey200, width: 1.w),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ImageWidget(imageUrl: AppImage.uploadIcon),
                  SizedBox(height: 8.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: AppString.clickToUpload,
                      style: context.headlineMedium?.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.purple,
                      ),
                      children: [
                        TextSpan(
                          text: AppString.dragAndDrop,
                          style: context.titleSmall?.copyWith(fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 56.h),
            ElevatedButtonIconWidget(title: 'Save', onPressed: _addNote),
          ],
        ),
      ),
    ),
  );

  Future<void> _addNote() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(noteProvider.notifier)
        .addNote(
          entity: NoteEntity(
            title: _titleContoller.text,
            content: _detailContoller.text,
            scriptureReferences: const [
              ScriptureReference(book: 'Genesis'),
              ScriptureReference(book: 'Exodus'),
              ScriptureReference(book: 'Titus'),
              ScriptureReference(book: 'Proverbs'),
              ScriptureReference(book: 'Timothy'),
            ],
            images: const [
              'https://via.placeholder.com/150',
              'https://via.placeholder.com/150',
              'https://via.placeholder.com/150',
            ],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
  }
}
