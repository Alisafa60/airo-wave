import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        title: const Text(
          "Maps",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.black12,
          ),
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                // pinned: true,
                expandedHeight: 500,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ListTile(
                      title: Text('item ${1 + index}'),
                    );
                  },
                  childCount: 20,
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    icon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/icons/home-filled-gray.svg',
              height: 35,
              width: 35,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/icons/MedCat-orange.svg',
              height: 35,
              width: 35,
            ),
            label: 'MedCat',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/icons/map-location.svg',
              height: 35,
              width: 35,
            ),
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/icons/activity-waves.svg',
              height: 35,
              width: 35,
            ),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/icons/community.svg',
              height: 35,
              width: 35,
            ),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}
