import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {

  String _apiKey = '0c76aa3f958a9eb86f5dc5f7220a1c5c';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';

  List <Movie> onDisplayMovies = [];
  List <Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey, 
      'language': _language,
      'page': '$page'
    });

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(json.decode(jsonData));
    
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
    
  } 

  getPopularMovies() async {

    _popularPage++;

    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(json.decode(jsonData));
    notifyListeners();

    popularMovies = [...popularResponse.results, ...popularMovies];
    
    onDisplayMovies = popularResponse.results;
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {

    if(moviesCast.containsKey(movieId)) {
      // ignore: avoid_print
      print('✅ Cast en caché para película $movieId');
      return moviesCast[movieId]!;
    }

    try {
      
      final jsonData = await _getJsonData('3/movie/$movieId/credits');
      
      final creditsResponse = CreditsResponse.fromJson(jsonData);
      // ignore: avoid_print
      print('✅ Cast parseado correctamente: ${creditsResponse.cast.length} actores');
      moviesCast[movieId] = creditsResponse.cast;
      return creditsResponse.cast;
    } catch (e) {
      print('❌ Error obteniendo cast: $e');
      return [];
    }
  }

  Future<List<Movie>> searchMovies( String query ) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    
    return searchResponse.results;
  }
  

  void getSuggestionsByQuery( String searchTerm ) {

    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      final results = await this.searchMovies(value);
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }

}