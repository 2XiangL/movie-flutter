import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

class ContentRecommendationsScreen extends StatefulWidget {
  const ContentRecommendationsScreen({super.key});

  @override
  State<ContentRecommendationsScreen> createState() => _ContentRecommendationsScreenState();
}

class _ContentRecommendationsScreenState extends State<ContentRecommendationsScreen> {
  final TextEditingController _movieController = TextEditingController();
  bool _isRecommending = false;

  @override
  void dispose() {
    _movieController.dispose();
    super.dispose();
  }

  Future<void> _getRecommendations(String movieName) async {
    if (movieName.trim().isEmpty) return;

    setState(() {
      _isRecommending = true;
    });

    try {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      await movieProvider.getContentRecommendations(movieName.trim());
    } catch (e) {
      debugPrint('获取推荐失败: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isRecommending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 顶部标题栏
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('内容推荐'),
              titlePadding: const EdgeInsets.only(bottom: 16, left: 20),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _movieController,
                        decoration: InputDecoration(
                          hintText: '输入电影名称获取推荐...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          _getRecommendations(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _isRecommending
                          ? null
                          : () => _getRecommendations(_movieController.text),
                      icon: const Icon(Icons.recommend),
                      label: const Text('推荐'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 推荐结果
          Consumer<MovieProvider>(
            builder: (context, movieProvider, child) {
              if (_isRecommending) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('正在分析电影内容...'),
                        SizedBox(height: 8),
                        Text('这可能需要几秒钟时间'),
                      ],
                    ),
                  ),
                );
              }

              if (movieProvider.error != null) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '推荐失败',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movieProvider.error!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            movieProvider.clearError();
                          },
                          child: const Text('重试'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (movieProvider.contentRecommendations.isEmpty &&
                  movieProvider.selectedMovie == null) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.recommend_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          '输入电影名称获取推荐',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '我们会根据电影内容为你推荐相似的电影',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (movieProvider.selectedMovie != null) {
                return SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '基于 "${movieProvider.selectedMovie!.title}" 的推荐',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '相似度排序',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              }

              if (movieProvider.contentRecommendations.isNotEmpty) {
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final movie = movieProvider.contentRecommendations[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsScreen(movieTitle: movie.title),
                              ),
                            );
                          },
                          child: MovieCard(movie: movie),
                        );
                      },
                      childCount: movieProvider.contentRecommendations.length,
                    ),
                  ),
                );
              }

              return const SliverFillRemaining(
                child: Center(
                  child: Text('没有找到相关推荐'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

