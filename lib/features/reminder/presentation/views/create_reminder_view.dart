import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/app/utils/field_validator.dart';
import 'package:disciple/features/reminder/data/model/reminder_model.dart';
import 'package:disciple/features/reminder/domain/entity/reminder_entity.dart';
import 'package:disciple/features/reminder/presentation/notifier/reminder_notifier.dart';
import 'package:disciple/widgets/back_arrow_widget.dart';
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
  late final TabController _tabController;
  final _hourController = TextEditingController();
  final _minuteController = TextEditingController();
  final _titleController = TextEditingController();

  String _period = 'AM';
  bool _enableAlert = false;
  late final CalendarNotifier _calendarNotifier;

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

  late ReminderNotifier _reminderNotifier;

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _reminderNotifier = ref.read(reminderProvider.notifier);
    _calendarNotifier = ref.read(calendarProvider.notifier);
    _setOtherValues();
    // Listen to calendar changes to validate form
    _calendarNotifier.addListener(_validateForm);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    _titleController.dispose();
    _calendarNotifier
      ..reset()
      ..removeListener(_validateForm);
    super.dispose();
  }

  void _setOtherValues() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.watch(calendarProvider);

      final reminder = state.reminder;
      if (reminder == null) return;

      final dt = reminder.scheduledAt;
      if (dt != null) {
        final int hour24 = dt.hour;
        final int minute = dt.minute;

        // Convert to 12h
        final period = hour24 >= 12 ? "PM" : "AM";
        int hour12 = hour24 % 12;
        if (hour12 == 0) hour12 = 12; // 00 → 12 AM or PM

        _hourController.text = hour12.toString();
        _minuteController.text = minute.toString().padLeft(2, '0');
        _period = period;
      }

      _titleController.text = reminder.title ?? '';

      final savedColor = reminder.colorValue;
      final savedLabel = reminder.colorLabel;
      if (savedColor != null && savedLabel != null) {
        final match = _colors.firstWhere(
          (c) => (c.value as Color).toARGB32() == savedColor,
          orElse: () => _colors.first,
        );
        _color = match;
      }

      _enableAlert = reminder.reminder ?? _enableAlert;

      setState(() {});
    });
  }

  void _validateForm() {
    final hour = int.tryParse(_hourController.text) ?? -1;
    final minute = int.tryParse(_minuteController.text) ?? -1;
    final titleValid = _titleController.text.trim().isNotEmpty;
    final timeValid = hour >= 1 && hour <= 12 && minute >= 0 && minute <= 59;
    final calendarValid =
        _calendarNotifier.weekDay != null ||
        _calendarNotifier.dateRange().isNotEmpty;

    setState(() {
      _isFormValid = titleValid && timeValid && calendarValid;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const BackArrowWidget(),
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
            const CalendarWidget(),
            SizedBox(height: 32.h),
            _buildDetailsSection(context),
            SizedBox(height: 60.h),
            ElevatedButtonIconWidget(
              onPressed: _isFormValid ? _addReminder : null,
              title: 'Save Reminder',
            ),
            SizedBox(height: 18.h),
            ElevatedButtonIconWidget(
              onPressed: _discardChanges,
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
        Consumer(
          builder: (context, ref, child) {
            final calendarState = ref.watch(calendarProvider);
            return DropdownButton<String>(
              value: calendarState.frequency,
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
                ref.read(calendarProvider.notifier)
                  ..setFrequency(value!)
                  ..setCalendarFormat(value);
                _validateForm();
              },
            );
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
        controller: _titleController,
        onChanged: (_) => _validateForm(),
        validator: FieldValidator.validateString(error: 'Title is required.'),
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
          _buildTimeField(_hourController, 12),
          SizedBox(width: 12.w),
          _buildTimeField(_minuteController, 59),
          SizedBox(width: 12.w),
          _amPmSelector(context),
        ],
      ),
    ],
  );

  Widget _buildTimeField(TextEditingController controller, int max) => SizedBox(
    width: 52.w,
    height: 52.h,
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        context.limit(max: 2),
      ],
      onChanged: (_) => _validateForm(),
      validator: FieldValidator.validateString(),
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
        value: _period,
        isExpanded: true,
        icon: const SizedBox.shrink(),
        style: context.bodyMedium?.copyWith(fontSize: 16.sp),
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
        onChanged: (v) {
          setState(() => _period = v!);
          _validateForm();
        },
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
            onChanged: (v) {
              setState(() => _color = v!);
              _validateForm();
            },
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
        onChanged: (value) => setState(() {
          _enableAlert = value;
          _validateForm();
        }),
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

  Future<void> _addReminder() async {
    final calendarState = ref.watch(calendarProvider);

    int hour = int.tryParse(_hourController.text) ?? 0;
    final minute = int.tryParse(_minuteController.text) ?? 0;

    // Convert 12h to 24h
    if (_period == "PM" && hour != 12) {
      hour += 12;
    } else if (_period == "AM" && hour == 12) {
      hour = 0;
    }

    final now = DateTime.now();
    final baseTime = calendarState.weekDay != null
        ? _calendarNotifier.nextWeekday(
            weekday: calendarState.weekDay!,
            hour: hour,
            minute: minute,
          )
        : DateTime(now.year, now.month, now.day, hour, minute);

    final reminder = ReminderEntity(
      title: _titleController.text.trim(),
      color: ReminderColor(
        label: _color.label,
        color: (_color.value as Color).toARGB32(),
      ),
      reminder: _enableAlert,
      scheduledAt: baseTime,
      scheduledDates: calendarState.dateRange(),
    );

    await _reminderNotifier.addReminder(entity: reminder);
  }

  void _discardChanges() {
    _calendarNotifier.reset();
    _hourController.clear();
    _minuteController.clear();
    _titleController.clear();
    setState(() {});
  }
}
