import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  final ApiService _apiService;

  // 通用状态
  bool _isLoading = false;
  String? _error;

  // 搜索状态
  List<Movie> _searchResults = [];
  String _searchQuery = '';

  // 内容推荐状态
  List<Movie> _contentRecommendations = [];
  Movie? _selectedMovie;
  Map<String, dynamic>? _movieDetails;
  List<Movie> _similarMovies = [];
  List<Movie> _randomMovies = [];

  // 协同过滤推荐状态
  List<Movie> _collaborativeRecommendations = [];

  // 知识图谱推荐状态
  List<Movie> _knowledgeGraphRecommendations = [];
  List<Movie> _knowledgeGraphSearchResults = [];

  // UI状态
  String _currentView = 'home';

  MovieProvider(this._apiService);

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Movie> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;
  List<Movie> get contentRecommendations => _contentRecommendations;
  Movie? get selectedMovie => _selectedMovie;
  Map<String, dynamic>? get movieDetails => _movieDetails;
  List<Movie> get similarMovies => _similarMovies;
  List<Movie> get randomMovies => _randomMovies;
  List<Movie> get collaborativeRecommendations => _collaborativeRecommendations;
  List<Movie> get knowledgeGraphRecommendations => _knowledgeGraphRecommendations;
  List<Movie> get knowledgeGraphSearchResults => _knowledgeGraphSearchResults;
  String get currentView => _currentView;

  bool get hasSearchResults => _searchResults.isNotEmpty;
  bool get hasContentRecommendations => _contentRecommendations.isNotEmpty;
  bool get hasCollaborativeRecommendations => _collaborativeRecommendations.isNotEmpty;
  bool get hasKnowledgeGraphRecommendations => _knowledgeGraphRecommendations.isNotEmpty;
  bool get hasRandomMovies => _randomMovies.isNotEmpty;

  // 设置加载状态
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // 设置错误信息
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // 清除错误信息
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // 设置当前视图
  void setCurrentView(String view) {
    _currentView = view;
    notifyListeners();
  }

  // 清除电影数据
  void clearMovieData() {
    _contentRecommendations.clear();
    _movieDetails = null;
    _similarMovies.clear();
    _selectedMovie = null;
    _collaborativeRecommendations.clear();
    _knowledgeGraphRecommendations.clear();
    _knowledgeGraphSearchResults.clear();
    _randomMovies.clear();
    notifyListeners();
  }

  // 重置所有状态
  void resetState() {
    _searchResults.clear();
    _searchQuery = '';
    clearMovieData();
    _currentView = 'home';
    _error = null;
    notifyListeners();
  }

  // 搜索电影
  Future<List<Movie>> searchMovies(String query, {int limit = 10}) async {
    try {
      _setLoading(true);
      _setError(null);

      _searchQuery = query;
      final response = await _apiService.searchMovies(query, limit: limit);
      _searchResults = response.map((item) => Movie.fromJson(item)).toList();

      notifyListeners();
      return _searchResults;
    } catch (e) {
      _setError('搜索电影失败: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // 获取内容推荐
  Future<List<Movie>> getContentRecommendations(String movie, {int limit = 10}) async {
    try {
      _setLoading(true);
      _setError(null);

      // 先搜索电影找到匹配的
      final searchResults = await _apiService.searchMovies(movie, limit: 1);
      if (searchResults.isNotEmpty) {
        _selectedMovie = Movie.fromJson(searchResults[0]);
      } else {
        _selectedMovie = Movie(title: movie);
      }

      final response = await _apiService.getContentRecommendations(movie, limit: limit);

      _contentRecommendations = response.map((item) => Movie.fromJson(item)).toList();

      notifyListeners();
      return _contentRecommendations;
    } catch (e) {
      _setError('获取内容推荐失败: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // 获取电影详情
  Future<Map<String, dynamic>> getMovieDetails(String movie) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _apiService.getMovieDetails(movie);
      _movieDetails = response;

      notifyListeners();
      return _movieDetails!;
    } catch (e) {
      _setError('获取电影详情失败: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // 获取相似电影
  Future<List<Movie>> getSimilarMovies(String movie, {int limit = 10}) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _apiService.getKnowledgeGraphRecommendations(movie, limit: limit);
      _similarMovies = response.map((item) => Movie.fromJson(item)).toList();

      notifyListeners();
      return _similarMovies;
    } catch (e) {
      _setError('获取相似电影失败: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // 获取随机电影
  Future<List<Movie>> getRandomMovies({int limit = 10}) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _apiService.searchKnowledgeGraph('movie');
      List<dynamic> randomMovies = response;
      randomMovies.shuffle();
      randomMovies = randomMovies.take(limit).toList();

      _randomMovies = randomMovies.map((item) => Movie.fromJson(item)).toList();

      notifyListeners();
      return _randomMovies;
    } catch (e) {
      _setError('获取随机电影失败: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // 获取协同过滤推荐
  Future<List<Movie>> getCollaborativeRecommendations(String userId, {int limit = 10}) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _apiService.getCollaborativeRecommendations(userId, limit: limit);
      _collaborativeRecommendations = response.map((item) => Movie.fromJson(item)).toList();

      notifyListeners();
      return _collaborativeRecommendations;
    } catch (e) {
      _setError('获取协同过滤推荐失败: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // 获取知识图谱推荐
  Future<List<Movie>> getKnowledgeGraphRecommendations(String movie, {int limit = 10}) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _apiService.getKnowledgeGraphRecommendations(movie, limit: limit);
      _knowledgeGraphRecommendations = response.map((item) => Movie.fromJson(item)).toList();

      notifyListeners();
      return _knowledgeGraphRecommendations;
    } catch (e) {
      _setError('获取知识图谱推荐失败: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // 知识图谱搜索
  Future<List<Movie>> searchKnowledgeGraph(String query) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _apiService.searchKnowledgeGraph(query);
      _knowledgeGraphSearchResults = response.map((item) => Movie.fromJson(item)).toList();

      notifyListeners();
      return _knowledgeGraphSearchResults;
    } catch (e) {
      _setError('知识图谱搜索失败: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}

