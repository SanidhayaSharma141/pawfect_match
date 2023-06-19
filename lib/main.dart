import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_match/providers/themeMode.dart';
import 'package:pawfect_match/screens/MainScreen.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: Color.fromARGB(255, 89, 2, 100),
  // seedColor: Color.fromARGB(255, 41, 12, 109),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 51, 51, 51),
  // seedColor: Color.fromARGB(255, 49, 176, 211),
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool timeDone = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        timeDone = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ref.watch(themeMode),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.quicksandTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.black,
        ),
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: kColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
          ),
          cardTheme: const CardTheme().copyWith(
            color: kColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer,
            ),
          ),
          textTheme: GoogleFonts.quicksandTextTheme().apply(
            bodyColor: Colors.black,
            displayColor: Colors.white,
          )
          // textTheme: ThemeData().textTheme.copyWith(
          //       titleLarge: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: kColorScheme.onSecondaryContainer,
          //         fontSize: 16,
          //       ),
          //     ),
          ),
      title: 'Pawfect Match',
      home: timeDone
          ? MainScreen()
          : Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
    );
  }
}
