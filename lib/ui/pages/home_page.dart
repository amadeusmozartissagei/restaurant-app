import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/theme.dart';
import '../../provider/page_provider.dart';
import 'favorites_page.dart';
import 'restaurant_list_page.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of pages to display
    final List<Widget> listWidget = [
      const RestaurantListPage(),
      const FavoritesPage(),
      const SettingsPage(),
    ];

    final List<BottomNavigationBarItem> bottomNavBarItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.restaurant_menu),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Favorites',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];

    return Consumer<PageProvider>(
      builder: (context, pageProvider, child) {
        return Scaffold(
          body: listWidget[pageProvider.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: pageProvider.currentIndex,
            items: bottomNavBarItems,
            onTap: (index) {
              pageProvider.setPageIndex(index);
            },
            selectedItemColor: AppTheme.secondaryLight,
            unselectedItemColor: Colors.grey,
          ),
        );
      },
    );
  }
}
