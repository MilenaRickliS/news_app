import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/news.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

    final prefs = await SharedPreferences.getInstance();

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      final cachedData = prefs.getString('cached_news');
      if (cachedData != null) {
        final List decoded = json.decode(cachedData);
        _news = decoded.map((item) => News.fromJson(item)).toList();
        _error = 'Sem conexão com a internet. Mostrando notícias em cache.';
      } else {
        _error = 'Sem conexão e sem cache disponível.';
      }
      _isLoading = false;
      notifyListeners();
      return;
    }


    try {
      final response = await http
          .get(
            Uri.parse(
                'https://newsapi.org/v2/top-headlines?country=us&apiKey=3b0243be61164a0db0a1373e9761cf47'),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _news = (data['articles'] as List)
            .map((item) => News.fromJson(item))
            .toList();
            prefs.setString('cached_news', json.encode(data['articles']));
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
