import 'package:flutter/material.dart';
import 'package:insta_metrics/Observer.dart';
import 'package:insta_metrics/models/InstagramViewModel.dart';
import 'package:insta_metrics/repositories/InstagramRepository.dart';
import 'package:insta_metrics/screens/home/filters_screen.dart';
import 'package:insta_metrics/screens/home/post_details_screen.dart';
import 'package:insta_metrics/screens/wellcome_screen.dart';
import 'package:insta_metrics/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  final instagramViewModel = new InstagramViewModel(repo : InstagramRepository());
  runApp(
      MultiProvider(
        providers : [
          ChangeNotifierProvider<InstagramViewModel>.value(value: instagramViewModel),
        ],
        child : InstaMetrics()
      )
  );
}

class InstaMetrics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home : WelcomeScreen(),
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        PostDetails.id : (context) => PostDetails(),
        FilterScreen.id : (context) => FilterScreen()
      },
    );
  }
}