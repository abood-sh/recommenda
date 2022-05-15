import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recommenda/providers/user_provider.dart';
import 'package:recommenda/models/user.dart' as model;
import 'package:recommenda/utils/colors.dart';
import 'package:recommenda/utils/common.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    addData();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  int _page = 0;
  late PageController pageController;

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return user.isAdmin
        ? Scaffold(
            body: PageView(
              children: homePageTabs,
              controller: pageController,
              onPageChanged: onPageChanged,
            ),
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: androidBackGroundColor,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: _page == 0 ? primaryColor : secondaryColor,
                    ),
                    label: '',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_box_sharp,
                        color: _page == 1 ? primaryColor : secondaryColor),
                    label: '',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(Icons.production_quantity_limits_rounded,
                        color: _page == 2 ? primaryColor : secondaryColor),
                    label: '',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                  icon: Icon(Icons.compare,
                      color: _page == 3 ? primaryColor : secondaryColor),
                  label: '',
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.star,
                      color: _page == 4 ? primaryColor : secondaryColor),
                  label: '',
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                    icon: Image(
                  image: NetworkImage(
                    user.imgUrl,
                  ),
                )),
              ],
              onTap: navigateTo,
            ),
          )
        : Scaffold(
            body: PageView(
              children: homePageTabsUser,
              controller: pageController,
              onPageChanged: onPageChanged,
            ),
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: androidBackGroundColor,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: _page == 0 ? primaryColor : secondaryColor,
                    ),
                    label: '',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(Icons.production_quantity_limits_rounded,
                        color: _page == 1 ? primaryColor : secondaryColor),
                    label: '',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                  icon: Icon(Icons.compare,
                      color: _page == 2 ? primaryColor : secondaryColor),
                  label: '',
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.star,
                      color: _page == 3 ? primaryColor : secondaryColor),
                  label: '',
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                    icon: Image(
                  image: NetworkImage(
                    user.imgUrl,
                  ),
                )),
              ],
              onTap: navigateTo,
            ),
          );
  }

  void navigateTo(int value) {
    pageController.jumpToPage(value);
  }

  void onPageChanged(int value) {
    setState(() {
      _page = value;
    });
  }
}
