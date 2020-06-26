import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './search.dart';

class SearchModel with ChangeNotifier {

  List<Search> movieList = [];

  static final String rapidMovieAPIUrl = DotEnv().env['RAPID_MOVIE_API_URL'];
  static final String rapidMovieHost = DotEnv().env['RAPID_MOVIE_HOST'];
  static final String rapidMovieKey = DotEnv().env['RAPID_MOVIE_KEY'];

  Map<String, String> headers = {
    "x-rapidapi-host": rapidMovieHost,
    "x-rapidapi-key": rapidMovieKey
  };

  Future<String> searchMovieWithTitle(String movieTitle) async {

    // Need to initialize to when user search again
    List<Search> movieListSample = [];

    final response = await http.get(rapidMovieAPIUrl + '?r=json&s=$movieTitle', headers: headers);
    Map responseData = json.decode(response.body);

    print(responseData['Search']);

    if(responseData['Search'] == null) {
      return 'There is no result\nPlease type correct movie name';
    }

    responseData['Search'].map((el) {
      Search search = new Search(
        title: el['Title'],
        year: el['Year'],
        imdbID: el['imdbID'],
        poster: el['Poster']
      );
      movieListSample.add(search);
    }).toList();

    movieList = [...movieListSample];

    notifyListeners();
    return null;
  } 

}