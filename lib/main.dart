import 'package:flutter/material.dart';
import 'app/core/di/service_locator.dart' as di;
import 'app/features/posts/presentation/screens/create_post_page.dart';
import 'app/features/posts/presentation/screens/post_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  di.setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forms App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: '/',
      routes: {
        '/': (context) => const PostListPage(),
        '/create-post': (context) => const CreatePostPage(),
      },
    );
  }
}
