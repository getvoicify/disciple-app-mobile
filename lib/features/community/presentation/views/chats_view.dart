import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/features/community/presentation/widget/chat_divider_widget.dart';
import 'package:disciple/features/community/presentation/widget/message_entry_widget.dart';
import 'package:disciple/features/community/presentation/widget/receiver_chat_buble_widget.dart';
import 'package:disciple/features/community/presentation/widget/sender_chat_buble_widget.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Becky'),
        centerTitle: false,
        leadingWidth: 100.w,
        leading: Row(
          children: [
            SizedBox(width: 16.w),
            ImageWidget(imageUrl: AppImage.backIcon, fit: BoxFit.none),
            SizedBox(width: 16.w),
            CircleAvatar(),
          ],
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            ChatDividerWidget(title: 'Yesterday'),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  if (index.isEven) return ReceiverChatBubleWidget();
                  return SenderChatBubleWidget();
                },
                itemCount: 20,
              ),
            ),
            SizedBox(height: 16.h),
            MessageEntryWidget(),
          ],
        ),
      ),
    );
  }
}
