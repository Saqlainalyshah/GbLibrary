import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/ads/banner_ad.dart';
import 'package:booksexchange/screens/home/feed_portion.dart';
import 'package:booksexchange/screens/home/uniform_feed.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../account/acount_page.dart';
import '../../controller/providers/global_providers.dart';
import '../../utils/app_theme/theme.dart';
import '../chat/chat.dart';
import '../home/post_item.dart';

final _bottomNavigationIndex = StateProvider.autoDispose<int>((ref) => 0);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(myBooksPosts);
    ref.read(userProfileProvider.notifier).fetchUser(widget.id);
    ref.read(myClothesPosts);
    ref.read(uniformFeedProvider);
    ref.read(myBooksPosts);
    ref.read(myClothesPosts);
  }

  final List<Widget> screens = [
    const FeedPortion(),
    const UniformFeed(),
    const PostItem(),
    const ChatScreen(),
    const AccountSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: BannerAdWidget()),
        body: Consumer(
          builder: (context, ref, child) => IndexedStack(
            index: ref.watch(_bottomNavigationIndex),
            children: screens,
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppThemeClass.primary.withOpacity(
                  0.5,
                ), // or any subtle shadow color
                blurRadius: 5,
                offset: const Offset(0, -1), // Shadow appears above the bar
              ),
            ],
          ),
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 6.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(Icons.home, 'Books', 0),
                  SizedBox(width: 5),
                  _buildNavItem(Icons.card_giftcard, 'Clothes', 1),
                  _buildNavItem(Icons.add_circle, 'Posts', 2),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      _buildNavItem(Icons.message, 'Messages', 3),
                      Consumer(
                        builder: (context, ref, child) {
                          final messages = ref.watch(
                            filterChatProvider.select(
                              (state) => state.unreadMessageCount,
                            ),
                          );
                          if (messages > 0) {
                            return Positioned(
                              bottom: ResponsiveBox.getSize(context, 20),
                              right: ResponsiveBox.getSize(context, 15),
                              child: Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: CustomText(
                                  text: messages.toString(),
                                  color: AppThemeClass.whiteText,
                                  fontSize: 13,
                                  isBold: true,
                                ),
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                  _buildNavItem(Icons.person_outline, 'Account', 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData? icon, String label, int index) {
    return Consumer(
      builder: (context, ref, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final isSelected =
            ref.watch(_bottomNavigationIndex.select((state) => state)) == index;
        if (index == 2) {
          return GestureDetector(
            onTap: () =>
                ref.read(_bottomNavigationIndex.notifier).state = index,
            child: Container(
              height: ResponsiveBox.getSize(context, 60),
              width: ResponsiveBox.getSize(context, 60),

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppThemeClass.primary,
              ),
              child: Icon(
                Icons.add,
                size: ResponsiveBox.getSize(context, 50),
                color: AppThemeClass.whiteText,
              ),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () =>
                ref.read(_bottomNavigationIndex.notifier).state = index,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppThemeClass.primary
                      : isDark
                      ? AppThemeClass.whiteText
                      : AppThemeClass.darkTextOptional,
                  size: ResponsiveBox.getSize(context, 30),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? AppThemeClass.primary
                        : isDark
                        ? AppThemeClass.whiteText
                        : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
