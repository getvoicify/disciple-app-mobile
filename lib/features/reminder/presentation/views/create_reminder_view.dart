// Cleaned version of CreateReminderView
// (logic and UI preserved, redundant code removed, structure improved)

import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/app/utils/field_validator.dart';
import 'package:disciple/widgets/calendar/calendar_widget.dart';
import 'package:disciple/widgets/calendar/module/calendar_notifier.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/elevated_button_widget.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:disciple/widgets/popup_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CreateReminderView extends ConsumerStatefulWidget {
  const CreateReminderView({super.key});

  @override
  ConsumerState<CreateReminderView> createState() => _CreateReminderViewState();
}

class _CreateReminderViewState extends ConsumerState<CreateReminderView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );
  final _searchController = TextEditingController();
  final _hourController = TextEditingController();
  final _minuteController = TextEditingController();
  final _titleController = TextEditingController();

  String _frequency = 'Daily';
  String period = 'AM';
  bool _enableAlert = false;

  PopupMenuItemData _color = const PopupMenuItemData(
    value: AppColors.lightPink,
    label: "Light Pink",
  );

  final List<PopupMenuItemData> _colors = const [
    PopupMenuItemData(value: AppColors.lightPink, label: "Light Pink"),
    PopupMenuItemData(value: AppColors.green50, label: "Pastel Green"),
    PopupMenuItemData(value: AppColors.softPeach, label: "Soft Peach"),
    PopupMenuItemData(value: AppColors.babyBlue, label: "Baby Blue"),
    PopupMenuItemData(value: AppColors.skyBlue, label: "Sky Blue"),
  ];

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const ImageWidget(imageUrl: AppImage.backIcon, fit: BoxFit.none),
      elevation: 0,
      title: const Text('Create Reminder'),
    ),
    body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(context),
            SizedBox(height: 24.h),
            CalendarWidget(frequency: _frequency),
            SizedBox(height: 32.h),
            _buildDetailsSection(context),
            SizedBox(height: 60.h),
            ElevatedButtonIconWidget(onPressed: () {}, title: 'Save Reminder'),
            SizedBox(height: 18.h),
            ElevatedButtonIconWidget(
              onPressed: () {},
              backgroundColor: AppColors.purple50,
              textStyle: context.bodyLarge?.copyWith(color: AppColors.purple),
              title: 'Discard Changes',
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildDateSelector(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          'Select date',
          style: context.headlineLarge?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      _styledCard(
        DropdownButton<String>(
          value: _frequency,
          isDense: true,
          style: context.headlineLarge?.copyWith(fontSize: 14.sp),
          icon: const ImageWidget(imageUrl: AppImage.arrowDownIcon),
          items: ['Daily', 'Weekly', 'Monthly']
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: context.bodyMedium),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() => _frequency = value!);
            ref.read(calendarProvider.notifier).setCalendarFormat(_frequency);
          },
        ),
      ),
    ],
  );

  Widget _buildDetailsSection(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Details', style: context.headlineLarge?.copyWith(fontSize: 20.sp)),
      SizedBox(height: 12.h),
      EditTextFieldWidget(
        title: 'Title',
        validator: FieldValidator.validateString(error: 'Title is required.'),
        keyboardType: TextInputType.name,
        controller: _titleController,
      ),
      SizedBox(height: 16.h),
      Row(
        children: [
          Expanded(child: _buildTimeInputBlock(context)),
          SizedBox(width: 29.w),
          Expanded(child: _buildColorSelector(context)),
        ],
      ),
      SizedBox(height: 32.h),
      _buildAlertToggle(context),
    ],
  );

  Widget _buildTimeInputBlock(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Select time',
        style: context.headlineMedium?.copyWith(fontSize: 16.sp),
      ),
      SizedBox(height: 4.h),
      Row(
        children: [
          _buildTimeField(_hourController),
          SizedBox(width: 12.w),
          _buildTimeField(_minuteController),
          SizedBox(width: 12.w),
          _amPmSelector(context),
        ],
      ),
    ],
  );

  Widget _buildTimeField(TextEditingController controller) => SizedBox(
    width: 52.w,
    height: 52.h,
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        context.limit(max: 2),
      ],
      validator: FieldValidator.validateString(),
      onChanged: (value) {
        // Hour/Minute range validation
        if (controller == _hourController) {
          final intVal = int.tryParse(value) ?? 0;
          if (intVal > 12) {
            controller
              ..text = '12'
              ..selection = TextSelection.fromPosition(
                const TextPosition(offset: 2),
              );
          }
        } else if (controller == _minuteController) {
          final intVal = int.tryParse(value) ?? 0;
          if (intVal > 59) {
            controller
              ..text = '59'
              ..selection = TextSelection.fromPosition(
                const TextPosition(offset: 2),
              );
          }
        }
      },
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.r)),
      ),
      style: context.bodyMedium?.copyWith(fontSize: 16.sp),
    ),
  );

  Widget _amPmSelector(BuildContext context) => Container(
    width: 52.w,
    height: 52.h,
    decoration: _inputBorderStyle,
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: period,
        isExpanded: true,
        icon: const SizedBox.shrink(),
        selectedItemBuilder: (_) => ['AM', 'PM']
            .map((t) => Center(child: Text(t, style: context.bodyMedium)))
            .toList(),
        items: ['AM', 'PM']
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Center(child: Text(e)),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => period = v!),
      ),
    ),
  );

  Widget _buildColorSelector(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Color Preference',
        style: context.headlineMedium?.copyWith(fontSize: 16.sp),
      ),
      SizedBox(height: 4.h),
      Container(
        decoration: _inputBorderStyle,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<PopupMenuItemData>(
            value: _color,
            isExpanded: true,
            style: context.bodyMedium?.copyWith(fontSize: 14.sp),
            icon: const ImageWidget(imageUrl: AppImage.arrowDownIcon),
            items: _colors
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Row(
                      children: [
                        CircleAvatar(radius: 12.r, backgroundColor: c.value),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(c.label, style: context.bodyMedium),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _color = v!),
          ),
        ),
      ),
    ],
  );

  Widget _buildAlertToggle(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          'Get Alert for this Reminder',
          style: context.headlineMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Switch.adaptive(
        value: _enableAlert,
        onChanged: (value) => setState(() => _enableAlert = value),
      ),
    ],
  );

  BoxDecoration get _inputBorderStyle => BoxDecoration(
    borderRadius: BorderRadius.circular(4.r),
    border: Border.all(color: AppColors.grey200),
  );

  Widget _styledCard(Widget child) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    elevation: .3,
    color: AppColors.white,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: DropdownButtonHideUnderline(child: child),
    ),
  );
}
