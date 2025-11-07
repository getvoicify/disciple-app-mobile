import 'package:auto_route/auto_route.dart';
<<<<<<< HEAD
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/app/utils/field_validator.dart';
=======
import 'package:dio/dio.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/app/utils/field_validator.dart';
import 'package:disciple/app/utils/image_picker.dart';
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/domain/entity/parsed_note_data.dart';
import 'package:disciple/features/notes/presentation/notifier/note_notifier.dart';
import 'package:disciple/features/notes/presentation/widget/add_scripture_section.dart';
import 'package:disciple/features/notes/presentation/widget/scripture_chips.dart';
import 'package:disciple/features/notes/presentation/widget/upload_image_section.dart';
<<<<<<< HEAD
=======
import 'package:disciple/features/uploads/presentation/notifier/upload_notifier.dart';
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
import 'package:disciple/widgets/back_arrow_widget.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// TODO: Implement functionalities for getting Scriptures to be added
<<<<<<< HEAD
/// TODO: Implement functionalities for image uploading

=======
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
@RoutePage()
class NewNotesView extends ConsumerStatefulWidget {
  const NewNotesView({super.key, this.existingNote});

  final ParsedNoteData? existingNote;

  @override
  ConsumerState<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends ConsumerState<NewNotesView> {
  final _titleContoller = TextEditingController();
  final _detailContoller = TextEditingController();

  final _titleFocusNode = FocusNode();
  final _detailFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final Set<ScriptureReference> _scriptures = {};

  bool get _isUpdating => widget.existingNote != null;

<<<<<<< HEAD
  bool _hasScriptures = false;
=======
  final ImagePickerHandler _imagePickerHandler = ImagePickerHandler();
  List<String> _successfulUploads = [];
  final CancelToken _cancelToken = CancelToken();
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b

  @override
  void initState() {
    super.initState();
    if (_isUpdating) {
      final note = widget.existingNote;
      _titleContoller.text = note?.title ?? '';
      _detailContoller.text = note?.content ?? '';
      _scriptures.addAll(note?.scriptureReferences ?? []);
    }
  }

  @override
  void dispose() {
<<<<<<< HEAD
=======
    _cancelToken.cancel();
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
    _titleContoller.dispose();
    _detailContoller.dispose();
    _titleFocusNode.dispose();
    _detailFocusNode.dispose();
    super.dispose();
  }

  void _toggleScripture(ScriptureReference scripture) {
    setState(() {
      if (!_scriptures.add(scripture)) {
        _scriptures.remove(scripture);
      }
<<<<<<< HEAD
      _hasScriptures = false;
    });
  }

  Future<void> _saveNote() async {
    // Run both validation checks to show all errors at once.
    final isFormValid = _formKey.currentState!.validate();
    final hasScriptures = _scriptures.isNotEmpty;

    // Update state for scripture error if necessary.
    if (!hasScriptures) {
      setState(() => _hasScriptures = true);
    }

    // If either check fails, do not proceed.
    if (!isFormValid || !hasScriptures) return;
=======
    });
  }

  Future<void> _pickImage() async {
    final images = await _imagePickerHandler.pickMultipleImages();
    if (!mounted || images.isEmpty) return;

    _successfulUploads = await ref
        .read(uploadProvider.notifier)
        .uploadAll(files: images, cancelToken: _cancelToken);
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b

    final entity = NoteEntity(
      title: _titleContoller.text.trim(),
      content: _detailContoller.text.trim(),
      scriptureReferences: _scriptures.toList(),
<<<<<<< HEAD
      images: const [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
=======
      images: _successfulUploads,
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final provider = ref.read(noteProvider.notifier);

    if (_isUpdating) {
      await provider.updateNote(
        entity: entity.copyWith(id: widget.existingNote?.id),
<<<<<<< HEAD
      );
    } else {
      await provider.addNote(entity: entity);
=======
        cancelToken: _cancelToken,
      );
    } else {
      provider
          .addNote(entity: entity, cancelToken: _cancelToken)
          .then((_) => PageNavigator.pop());
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_isUpdating ? AppString.editNote : AppString.newNote),
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
            if (_scriptures.isNotEmpty) ...[
              SizedBox(height: 8.h),
              ScriptureChips(
                scriptures: _scriptures.toList(),
                onRemove: _toggleScripture,
              ),
            ],

            SizedBox(height: 8.h),

<<<<<<< HEAD
            AddScriptureSection(
              onAdd: _toggleScripture,
              hasError: _hasScriptures,
            ),
=======
            AddScriptureSection(onAdd: _toggleScripture, hasError: false),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b

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

<<<<<<< HEAD
            const UploadImageSection(),

            SizedBox(height: 56.h),

            ElevatedButtonIconWidget(
              title: AppString.save,
              onPressed: _saveNote,
=======
            UploadImageSection(onPickImage: _pickImage),

            SizedBox(height: 56.h),

            Consumer(
              builder: (context, ref, child) {
                final isBusy =
                    ref.watch(noteProvider).isAddingNote ||
                    ref.watch(noteProvider).isUpdatingNote ||
                    ref.watch(uploadProvider).isUploading;
                return ElevatedButtonIconWidget(
                  title: AppString.save,
                  isBusy: isBusy,
                  onPressed: _saveNote,
                );
              },
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
            ),
          ],
        ),
      ),
    ),
  );
}
