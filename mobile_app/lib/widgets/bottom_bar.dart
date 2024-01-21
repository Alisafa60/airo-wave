import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/utils/handle_bar_tabbed.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('lib/assets/icons/home-filled.svg', height: 35, width: 35),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('lib/assets/icons/MedCat.svg', height: 35, width: 35),
          label: 'MedCat',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('lib/assets/icons/map-location.svg', height: 35, width: 35),
          label: 'Maps',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('lib/assets/icons/activity-waves.svg', height: 35, width: 35),
          label: 'Activities',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('lib/assets/icons/community.svg', height: 35, width: 35),
          label: 'Community',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) => handleBarTapped(context, index),
    );
  }
}