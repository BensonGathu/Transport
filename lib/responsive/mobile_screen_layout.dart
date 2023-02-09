import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:transportapp/utils/colors.dart';
import 'package:transportapp/utils/global_variables.dart';
import 'package:transportapp/widgets/NavDrawer.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavDrawer(),
      // appBar: AppBar(actions: []),
      body: PageView(
        children: homeScreenItems,
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
              icon: _page == 0
                  ? const Icon(
                      Icons.add_circle,
                      color: bottomIconsColor,
                      size: 37,
                    )
                  : const Icon(Icons.add_circle_outline_outlined,
                      color: bottomIconsColor, size: 24),
              label: 'Create Request'),
          BottomNavigationBarItem(
              icon: _page == 1
                  ? const Icon(
                      Icons.format_align_justify_rounded,
                      color: bottomIconsColor,
                      size: 34,
                    )
                  : const Icon(Icons.format_align_center_rounded,
                      color: bottomIconsColor, size: 22),
              label: 'My Requests'),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
