import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/features/community/presentation/widget/build_friends_tile_widget.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/floating_side_action_button.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
<<<<<<< HEAD

class FindFriendsView extends StatefulWidget {
  const FindFriendsView({super.key});

  @override
  State<FindFriendsView> createState() => _FindFriendsViewState();
}

class _FindFriendsViewState extends State<FindFriendsView> {
=======
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class FindFriendsView extends ConsumerStatefulWidget {
  const FindFriendsView({super.key});

  @override
  ConsumerState<FindFriendsView> createState() => _FindFriendsViewState();
}

class _FindFriendsViewState extends ConsumerState<FindFriendsView> {
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const ImageWidget(imageUrl: AppImage.backIcon, fit: BoxFit.none),
    ),
    body: SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                const EditTextFieldWidget(
                  prefix: ImageWidget(
                    imageUrl: AppImage.searchIcon,
                    fit: BoxFit.none,
                  ),
                  label: 'Search friends',
                ),
                SizedBox(height: 20.h),

                Expanded(
                  child: ListView.separated(
                    itemCount: 20,
<<<<<<< HEAD
                    itemBuilder: (_, _) => const BuildFriendsTileWidget(),
=======
                    itemBuilder: (_, index) => const BuildFriendsTileWidget(),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                  ),
                ),
              ],
            ),
          ),

          const FloatingSideButtonWidget(title: 'Invite friends'),
        ],
      ),
    ),
  );
}
