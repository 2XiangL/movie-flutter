import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/movie_provider.dart';

class MovieDetailsScreen extends StatelessWidget {
  final String movieTitle;

  const MovieDetailsScreen({super.key, required this.movieTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _loadMovieDetails(context, movieTitle),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('加载电影详情失败'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('返回'),
                  ),
                ],
              ),
            );
          }

          final movie = snapshot.data;
          if (movie == null) {
            return const Center(
              child: Text('电影详情不存在'),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: movie.posterPath != null
                      ? CachedNetworkImage(
                          imageUrl: movie.posterPath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              child: const Center(
                                child: Icon(Icons.movie, size: 64),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: const Center(
                            child: Icon(Icons.movie, size: 64),
                          ),
                        ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题和基本信息
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      movie.formattedRating,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (movie.formattedYear != '未知') ...[
                                      const SizedBox(width: 16),
                                      Text(
                                        '(${movie.formattedYear})',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie.formattedGenres,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                                if (movie.formattedRuntime != '未知') ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    '时长: ${movie.formattedRuntime}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (movie.imdbUrl != null)
                            IconButton(
                              icon: const Icon(Icons.link),
                              onPressed: () async {
                                final uri = Uri.parse(movie.imdbUrl!);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                            ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // 简介
                      if (movie.overview != null && movie.overview!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '剧情简介',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              movie.overview!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 24),

                      // 操作按钮
                      Wrap(
                        spacing: 12,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // TODO: 实现收藏功能
                            },
                            icon: const Icon(Icons.favorite_border),
                            label: const Text('收藏'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ContentRecommendationsScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.recommend),
                            label: const Text('获取推荐'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> _loadMovieDetails(BuildContext context, String movieTitle) async {
    try {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      return await movieProvider.getMovieDetails(movieTitle);
    } catch (e) {
      debugPrint('加载电影详情失败: $e');
      return null;
    }
  }
}

