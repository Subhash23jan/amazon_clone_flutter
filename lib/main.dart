
import 'package:amazon_clone_flutter/pages/Profile/screens/profile.dart';
import 'package:amazon_clone_flutter/pages/Cart/screens/cart_page.dart';
import 'package:amazon_clone_flutter/pages/more_bottom_sheet.dart';
import 'package:amazon_clone_flutter/pages/homeScreen/screens/home_screen_page.dart';
import 'package:amazon_clone_flutter/pages/Profile/screens/sample.dart';
import 'package:amazon_clone_flutter/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (BuildContext context) {
        return UserProvider();
      },
      child: MaterialApp(
        theme: ThemeData(
          backgroundColor: Colors.cyan,
          primaryColor: Colors.white,
          platform: TargetPlatform.android,
          hintColor: Colors.white70,
        ),
        home:const Sample(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController _pagecontroller;
  int _pageIndex=0;
  @override
  Widget build(BuildContext context) {
    _pagecontroller=PageController();
    return Scaffold(
      body: PageView(
        controller: _pagecontroller,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomepageScreen(),
          OptionalBottomSheet(),
          UserProfile(),
          CartPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: false,
        backgroundColor:const Color(0xFF09073B),
        currentIndex:_pageIndex,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        elevation: 12,
        enableFeedback: true,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        unselectedIconTheme: const IconThemeData(color: Colors.white,size: 21),
        selectedIconTheme: const IconThemeData(size: 25,color: Colors.blue),
        unselectedLabelStyle: const TextStyle(color: Colors.white70,fontSize: 13),
        selectedLabelStyle: const TextStyle(color: Colors.white70,fontSize: 14.5,fontWeight: FontWeight.bold),
        onTap: (value) {
          setState(() {
            _pageIndex=value;
            _pagecontroller.jumpToPage(value);
          });
        },
          iconSize: 21,
          items: const [
            BottomNavigationBarItem(icon:Icon(CupertinoIcons.home,),label:'Home',),
            BottomNavigationBarItem(icon:Icon(Icons.ads_click,),label: 'More'),
            BottomNavigationBarItem(icon:Icon(CupertinoIcons.person),label: 'You'),
            BottomNavigationBarItem(icon:Icon(CupertinoIcons.cart),label: 'Cart',)
          ]),
    );
  }
}


