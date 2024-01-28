import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/utils/handle_bar_tabbed.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    List<String> iconPaths = [
      'lib/assets/icons/home-filled.svg',
      'lib/assets/icons/MedCat.svg',
      'lib/assets/icons/map-location.svg',
      'lib/assets/icons/activity-waves.svg',
      'lib/assets/icons/profile-round.svg',
    ];

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildNavigationBarItem(iconPaths[0], 'Home', 0),
        _buildNavigationBarItem(iconPaths[1], 'MedCat', 1),
        _buildNavigationBarItem(iconPaths[2], 'Maps', 2),
        _buildNavigationBarItem(iconPaths[3], 'Activities', 3),
        _buildNavigationBarItem(iconPaths[4], 'Profile', 4),
      ],
      currentIndex: selectedIndex,
      onTap: (index) => handleBarTapped(context, index),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(String iconPath, String label, int index) {
    String modifiedIconPath = index == selectedIndex ? iconPath.replaceFirst('.svg', '-orange.svg') : iconPath;

    double iconSize = index == 4 ? 30 : 35.0;

    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        modifiedIconPath,
        height: iconSize,
        width: iconSize,
      ),
      label: label,
    );
  }
}