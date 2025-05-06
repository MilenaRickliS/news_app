import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/news.dart';

class NewsProvider with ChangeNotifier {
  List<News> _news = [];
  bool _isLoading = false;
  String _error = '';
  List<News> get news => _news;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchNews() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    try {
      final response = await http
          .get(
            Uri.parse(
                'https://newsapi.org/v2/top-headlines?country=br&apiKey=3b0243be61164a0db0a1373e9761cf47'),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _news = (data['articles'] as List)
            .map((item) => News.fromJson(item))
            .toList();
      } else {
        _error = 'Erro ao carregar notícias: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Erro: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
