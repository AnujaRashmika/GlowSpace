import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

import 'config/theme.dart';
import 'providers/product_provider.dart';
import 'screens/splash/splash_screen.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(

    MultiProvider(

      providers: [

        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),

      ],


      child: const MyApp(),

    ),

  );

}



class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      home: const SplashScreen(),

    );

  }

}