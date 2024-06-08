import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:shivam_proj/features/home/home_page.dart';
import 'package:shivam_proj/utils/prefrence_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesUtil().init();
  await dotenv.load(fileName: '.env.dev');
  final apiBaseUrl = dotenv.get('GEMINI_API_KEY', fallback: '');
  Gemini.init(apiKey: apiBaseUrl);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gemini',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
      builder: EasyLoading.init(),
    );
  }
}
