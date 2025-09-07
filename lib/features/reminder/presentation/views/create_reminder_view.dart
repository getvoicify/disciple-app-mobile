import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/elevated_button_widget.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateReminderView extends StatefulWidget {
  const CreateReminderView({super.key});

  @override
  State<CreateReminderView> createState() => _CreateReminderViewState();
}

class _CreateReminderViewState extends State<CreateReminderView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ImageWidget(imageUrl: AppImage.backIcon, fit: BoxFit.none),
        elevation: 0,
        title: Text('Create Reminder'),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w, vertical: 16.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Daily',
                              style: context.headlineLarge?.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          ImageWidget(
                            imageUrl: AppImage.arrowDownIcon,
                            fit: BoxFit.none,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              Container(
                height: 338.h,
                width: double.infinity,
                color: Colors.red,
              ),
              SizedBox(height: 32.h),
              Text(
                'Details',
                style: context.headlineLarge?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 12.h),
              EditTextFieldWidget(title: 'Title'),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select time',
                          style: context.headlineMedium?.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTimeWidget(time: '12'),
                            SizedBox(width: 12.w),
                            _buildTimeWidget(time: '00'),
                            SizedBox(width: 12.w),
                            _buildTimeWidget(time: 'AM'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 29.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Color Preference',
                          style: context.headlineMedium?.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(radius: 12.r),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'Light Pink',
                                  style: context.bodyMedium?.copyWith(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              ImageWidget(imageUrl: AppImage.arrowDownIcon),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'Get Alert for this Reminder',
                      style: context.headlineMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Switch.adaptive(value: true, onChanged: (value) {}),
                ],
              ),
              SizedBox(height: 60.h),
              ElevatedButtonIconWidget(
                onPressed: () {},
                title: 'Save Reminder',
              ),
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
  }

  Widget _buildTimeWidget({required String time}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.grey200),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Text(
        time,
        style: context.bodyMedium?.copyWith(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
