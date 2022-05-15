import 'package:flutter/material.dart';
import '../screens/comparison_screen.dart';
import '../screens/create_a_product.dart';
import '../screens/homepage_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../screens/search_stars_screen.dart';

const homePageTabs = [
  HomePageScreen(),
  CreateAProduct(),
  SearchScreen(),
  ComparisonScreen(),
  SearchStarScreen(),
  ProfileScreen(),
];

const homePageTabsUser = [
  HomePageScreen(),
  SearchScreen(),
  ComparisonScreen(),
  SearchStarScreen(),
  ProfileScreen(),
];
