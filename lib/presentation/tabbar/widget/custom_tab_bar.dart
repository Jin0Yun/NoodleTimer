import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/tabbar/widget/tab_bar_constants.dart';
import 'package:noodle_timer/presentation/tabbar/widget/tab_item_data.dart';

class CustomTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CustomTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  static const List<TabItemData> _tabItems = [
    TabItemData(icon: Icons.search_outlined, label: '라면찾기'),
    TabItemData(icon: Icons.timer_outlined, label: '타이머', isCenter: true),
    TabItemData(icon: Icons.receipt_long_outlined, label: '조리내역'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TabBarConstants.tabBarHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildTabBarBackground(context),
          _buildCenterButton(context),
        ],
      ),
    );
  }

  Widget _buildTabBarBackground(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: TabBarConstants.containerHeight,
        decoration: BoxDecoration(
          color: NoodleColors.backgroundWhite,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(TabBarConstants.borderRadius),
          ),
          border: Border(
            top: BorderSide(
              color: NoodleColors.secondaryDarkGray.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(
              context: context,
              index: 0,
              icon: _tabItems[0].icon,
              label: _tabItems[0].label,
            ),
            const SizedBox(width: 3),
            _buildTabItem(
              context: context,
              index: 2,
              icon: _tabItems[2].icon,
              label: _tabItems[2].label,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    final centerTab = _tabItems[1];
    return Positioned(
      bottom: 25,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center,
        child: Semantics(
          label: '${centerTab.label} 탭',
          child: GestureDetector(
            onTap: () => onTabSelected(1),
            child: Container(
              width: TabBarConstants.centerButtonSize,
              height: TabBarConstants.centerButtonSize,
              decoration: BoxDecoration(
                color: selectedIndex == 1 ? NoodleColors.primary : NoodleColors.disabled,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: NoodleColors.textDefault.withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      centerTab.icon,
                      color: NoodleColors.backgroundWhite,
                      size: TabBarConstants.centerButtonIconSize,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      centerTab.label,
                      style: NoodleTextStyles.titleXsm.copyWith(
                        color: NoodleColors.backgroundWhite,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? NoodleColors.primary : NoodleColors.textDefault;

    return Semantics(
      label: '$label 탭',
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: TabBarConstants.iconSize, color: color),
            const SizedBox(height: TabBarConstants.spacing),
            Text(
              label,
              style: NoodleTextStyles.titleXsm.copyWith(
                color: color,
                decoration: TextDecoration.none,
              ),
            )
          ],
        ),
      ),
    );
  }
}