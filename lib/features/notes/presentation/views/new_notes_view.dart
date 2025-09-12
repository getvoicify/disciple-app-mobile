import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/app/utils/field_validator.dart';
import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:disciple/features/notes/domain/entity/note_entity.dart';
import 'package:disciple/features/notes/presentation/notifier/note_notifier.dart';
import 'package:disciple/features/notes/presentation/widget/add_scripture_section.dart';
import 'package:disciple/features/notes/presentation/widget/scripture_chips.dart';
import 'package:disciple/features/notes/presentation/widget/upload_image_section.dart';
import 'package:disciple/widgets/back_arrow_widget.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/elevated_button_widget.dart';
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
  final _titleContoller = TextEditingController();
  final _detailContoller = TextEditingController();

  final _titleFocusNode = FocusNode();
  final _detailFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final Set<ScriptureReference> _scriptures = {};

  @override
  void dispose() {
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
    });
  }

  Future<void> _addNote() async {
    if (!_formKey.currentState!.validate()) return;

    final entity = NoteEntity(
      title: _titleContoller.text.trim(),
      content: _detailContoller.text.trim(),
      scriptureReferences: _scriptures.toList(),
      images: const [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await ref.read(noteProvider.notifier).addNote(entity: entity);
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
            if (_scriptures.isNotEmpty) ...[
              SizedBox(height: 8.h),
              ScriptureChips(
                scriptures: _scriptures.toList(),
                onRemove: _toggleScripture,
              ),
            ],

            SizedBox(height: 8.h),

            AddScriptureSection(onAdd: _toggleScripture),

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

            const UploadImageSection(),

            SizedBox(height: 56.h),

            ElevatedButtonIconWidget(
              title: AppString.save,
              onPressed: _addNote,
            ),
          ],
        ),
      ),
    ),
  );
}
