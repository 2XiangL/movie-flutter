import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/movie_provider.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MovieRecApp());
}

class MovieRecApp extends StatelessWidget {
  const MovieRecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieProvider(ApiService()),
      child: MaterialApp(
        title: 'MovieRec - 智能推荐',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMovies() async {
    if (_searchController.text.trim().isEmpty) return;

    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    try {
      await movieProvider.searchMovies(_searchController.text.trim());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('搜索失败: $e')),
      );
    }
  }

  Future<void> _getContentRecommendations() async {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    try {
      await movieProvider.getContentRecommendations('Avatar');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('获取推荐失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MovieRec'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 搜索栏
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索电影...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchMovies,
                ),
              ),
              onSubmitted: (_) => _searchMovies(),
            ),
            const SizedBox(height: 20),

            // 功能按钮
            const Text(
              '推荐功能',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 功能卡片
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  Icons.recommend,
                  '内容推荐',
                  '基于电影内容推荐相似电影',
                  Colors.orange,
                  () => _getContentRecommendations(),
                ),
                _buildFeatureCard(
                  Icons.people,
                  '协同过滤',
                  '基于用户行为推荐',
                  Colors.green,
                  () {},
                ),
                _buildFeatureCard(
                  Icons.account_tree,
                  '知识图谱',
                  '基于关联关系推荐',
                  Colors.purple,
                  () {},
                ),
                _buildFeatureCard(
                  Icons.search,
                  '高级搜索',
                  '搜索特定类型电影',
                  Colors.red,
                  () => _searchMovies(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 搜索结果
            const Text(
              '搜索结果',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: Consumer<MovieProvider>(
                builder: (context, movieProvider, child) {
                  if (movieProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (movieProvider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            '错误: ${movieProvider.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }

                  if (movieProvider.searchResults.isEmpty &&
                      movieProvider.contentRecommendations.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.movie, color: Colors.grey.shade400, size: 64),
                          const SizedBox(height: 16),
                          Text(
                            '输入电影名称开始搜索',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  // 显示搜索结果或推荐结果
                  final movies = movieProvider.searchResults.isNotEmpty
                      ? movieProvider.searchResults
                      : movieProvider.contentRecommendations;

                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 75,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: movie.posterPath != null
                                ? Image.network(
                                    movie.posterPath!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.movie);
                                    },
                                  )
                                : const Icon(Icons.movie),
                          ),
                          title: Text(movie.title),
                          subtitle: movie.formattedYear != '未知'
                              ? Text('上映年份: ${movie.formattedYear}')
                              : null,
                          trailing: movie.formattedRating != '0.0'
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    Text(movie.formattedRating),
                                  ],
                                )
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

