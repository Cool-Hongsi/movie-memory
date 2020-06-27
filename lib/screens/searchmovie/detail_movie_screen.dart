import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/search/search_model.dart';

class DetailMovieScreenM extends StatefulWidget {

  final Map argMap;
  DetailMovieScreenM({ this.argMap });

  @override
  _DetailMovieScreenMState createState() => _DetailMovieScreenMState();
}

class _DetailMovieScreenMState extends State<DetailMovieScreenM> {

  bool isLoading = false;
  Map detailMovie = {};

  final _scaffoldDetailKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    Provider.of<SearchModel>(context, listen: false).searchMovieDetailWithID(widget.argMap['imdbID'])
    .then((value) {
      // Check whether the return value is string (error) or null (success)
      if(value.runtimeType == String){
        _scaffoldDetailKey.currentState.showSnackBar(
          SnackBar(
            content: Text(value),
            backgroundColor: Theme.of(context).errorColor,
            duration: const Duration(seconds: 2),
          )
        );
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final movieDetail = Provider.of<SearchModel>(context).movieDetail;

    return Scaffold(
      key: _scaffoldDetailKey,
      resizeToAvoidBottomInset: false,
      body: isLoading
      ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[700]),
            )
          ],
        ),
      )
      : Stack(
        children: <Widget>[
          Container(
            width: screenSize.width * 1,
            height: screenSize.height * 1,
            child: (movieDetail['Poster'] == "N/A" || !movieDetail.containsKey('Poster'))
              /************** Poster **************/
              ? Image.asset('assets/images/default_detail_image.png', fit: BoxFit.fitHeight)
              : Image.network(movieDetail['Poster'], fit: BoxFit.cover)
          ),
          Container(
            width: screenSize.width * 1,
            height: screenSize.height * 1,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.8)
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.13),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: screenSize.height * .05, horizontal: screenSize.width * .05),
                  child: Column(
                    children: <Widget>[
                      /************** Title **************/
                      Text((movieDetail['Title'] == "N/A" || !movieDetail.containsKey('Title'))
                      ? "No Title Data"
                      : movieDetail['Title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Questrial',
                        fontSize: 24,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          /************** Released **************/
                          Text((movieDetail['Released'] == "N/A" || !movieDetail.containsKey('Released'))
                          ? "No Released Data"
                          : movieDetail['Released'],
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Questrial',
                            fontSize: 15
                          ),
                          ),
                          /************** Run Time **************/
                          Text((movieDetail['Runtime'] == "N/A" || !movieDetail.containsKey('Runtime'))
                          ? "No Runtime Data"
                          : movieDetail['Runtime'],
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Questrial',
                            fontSize: 15
                          ),
                          ),
                        ],
                      ),
                      SizedBox(height: 35),
                      /************** Genre **************/
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text((movieDetail['Genre'] == "N/A" || !movieDetail.containsKey('Genre'))
                        ? "No Genre Data"
                        : movieDetail['Genre'],
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Questrial',
                          fontSize: 15
                        ),
                        ),
                      ), 
                      SizedBox(height: 12),
                      /************** Director **************/
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text((movieDetail['Director'] == "N/A" || !movieDetail.containsKey('Director'))
                        ? "No Director Data"
                        : movieDetail['Director'],
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Questrial',
                          fontSize: 15
                        ),
                        ),
                      ),
                      SizedBox(height: 12),
                      /************** Actors **************/
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text((movieDetail['Actors'] == "N/A" || !movieDetail.containsKey('Actors'))
                        ? "No Actors Data"
                        : movieDetail['Actors'],
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Questrial',
                          fontSize: 15
                        ),
                        ),
                      ),
                      SizedBox(height: 35),
                      /************** Plot **************/
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text((movieDetail['Plot'] == "N/A" || !movieDetail.containsKey('Plot'))
                        ? "No Plot Data"
                        : movieDetail['Plot'],
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Questrial',
                          fontSize: 15
                        ),
                        ),
                      ),
                      SizedBox(height: 35),
                      /************** Rating Source **************/
                      movieDetail['Ratings'] == "N/A" || !movieDetail.containsKey('Ratings')
                      ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "No Rate Data",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Questrial',
                            fontSize: 15
                          ),
                        ),
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          for(var item in movieDetail['Ratings']) 
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  item['Source'],
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontFamily: 'Questrial',
                                    fontSize: 14
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  item['Value'],
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontFamily: 'Questrial',
                                    fontSize: 14
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenSize.height * 0.055,
            left: screenSize.width * 0.07,
            child: GestureDetector(
              onTap: () { Navigator.pop(context); },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.04,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: FlatButton.icon(
                onPressed: () { print('ADD TO MY MOVIE LIST'); },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  'My Movie List',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Questrial',
                    fontSize: 17
                  ),
                ),
              )
            )
          )
        ],
      ),
    );
  }
}

class DetailMovieScreenT extends StatefulWidget {

  final Map argMap;
  DetailMovieScreenT({ this.argMap });

  @override
  _DetailMovieScreenTState createState() => _DetailMovieScreenTState();
}

class _DetailMovieScreenTState extends State<DetailMovieScreenT> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
