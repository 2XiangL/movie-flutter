import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/movie_provider.dart';
import 'services/api_service.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/content_recommendations_screen.dart';
import 'screens/knowledge_graph_screen.dart';
import 'screens/collaborative_recommendations_screen.dart';
import 'screens/movie_details_screen.dart';
import 'widgets/nav_bar.dart';

void main() {
  runApp(const MovieRecApp());
}

class MovieRecApp extends StatelessWidget {
  const MovieRecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MovieProvider(ApiService()),
        ),
      ],
      child: MaterialApp(
        title: 'MovieRec - 智能推荐',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black87,
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
        routes: {
          '/search': (context) => const SearchScreen(),
          '/content-recommendations': (context) => const ContentRecommendationsScreen(),
          '/knowledge-graph': (context) => const KnowledgeGraphScreen(),
          '/collaborative-recommendations': (context) => const CollaborativeRecommendationsScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name?.startsWith('/movie-details/') == true) {
            final movieTitle = settings.name!.split('/')[2];
            return MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movieTitle: movieTitle),
            );
          }
          return null;
        },
      ),
    );
  }
}

