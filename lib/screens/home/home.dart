import 'package:booksexchange/screens/home/donte_feed.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/textfield.dart';
import 'exchange_feed.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final TextEditingController searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tab layout
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppThemeClass.whiteText,
          /*appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
           // title:CustomTextField(controller: searchController,isBorder: true,leadingIcon: Icons.search,hintText: 'Search',trailingIcon: Icons.clear,)

            bottom: TabBar(
              indicatorColor: AppThemeClass.primary,
              labelColor: AppThemeClass.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: 'Exchange'),
                Tab( text: 'Donate'),
              ],
            ),
          ),*/
          body: ExchangeFeed(),
        ),
      ),
    );
  }
}