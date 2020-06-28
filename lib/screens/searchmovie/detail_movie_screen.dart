import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/search/search_model.dart';
import '../../services/hex_color.dart';

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
      backgroundColor: Colors.white,
      key: _scaffoldDetailKey,
      resizeToAvoidBottomInset: false,
      body: isLoading
      ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
            )
          ],
        ),
      )
      : Stack(
        children: <Widget>[
          Container(
            width: screenSize.width * 1,
            height: screenSize.height * 1
          ),
          Container(
            width: screenSize.width * 1,
            height: screenSize.height * .6,
            child: (movieDetail['Poster'] == "N/A" || !movieDetail.containsKey('Poster'))
              /************** Poster **************/
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300]
                  ),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: screenSize.height * .2),
                  child: Text(
                    'No Image Data',
                    style: TextStyle(
                      fontFamily: 'Quicksand-Bold',
                      fontSize: 24,
                    )
                  )
                )
              : Image.network(movieDetail['Poster'], fit: BoxFit.cover)
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: screenSize.width * 1,
              height: screenSize.height * .65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 35, right: 35, top: 35, bottom: 55),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /************** Title **************/
                      Text((movieDetail['Title'] == "N/A" || !movieDetail.containsKey('Title'))
                      ? "No Title Data"
                      : movieDetail['Title'],
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Quicksand-Bold',
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 8),
                      Divider(height: 3, color: Colors.black54),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          /************** Run Time **************/
                          Text((movieDetail['Runtime'] == "N/A" || !movieDetail.containsKey('Runtime'))
                          ? "No Runtime Data"
                          : movieDetail['Runtime'],
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('|', style: TextStyle(color: Colors.black87, fontSize: 15)),
                          ),
                          /************** Released **************/
                          Text((movieDetail['Released'] == "N/A" || !movieDetail.containsKey('Released'))
                          ? "No Released Data"
                          : movieDetail['Released'],
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      /************** Genre **************/
                      Text((movieDetail['Genre'] == "N/A" || !movieDetail.containsKey('Genre'))
                        ? "No Genre Data"
                        : movieDetail['Genre'],
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          ),
                      ),
                      /************** Director **************/
                      Text((movieDetail['Director'] == "N/A" || !movieDetail.containsKey('Director'))
                        ? "No Director Data"
                        : movieDetail['Director'],
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          ),
                      ),
                      /************** Actors **************/
                      Text((movieDetail['Actors'] == "N/A" || !movieDetail.containsKey('Actors'))
                        ? "No Actors Data"
                        : movieDetail['Actors'],
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15
                          ),
                      ),
                      SizedBox(height: 25),
                      /************** Plot **************/
                      Text((movieDetail['Plot'] == "N/A" || !movieDetail.containsKey('Plot'))
                        ? "No Plot Data"
                        : movieDetail['Plot'],
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15
                        ),
                      ),
                      SizedBox(height: 25),
                      /************** Rating Source **************/
                      movieDetail['Ratings'] == "N/A" || !movieDetail.containsKey('Ratings')
                      ? Text(
                        "No Rate Data",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15
                        ),
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          for(var item in movieDetail['Ratings']) 
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Container(
                              width: screenSize.width * .65,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    item['Source'],
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    item['Value'],
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              )
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: screenSize.width * 1,
              height: 55,
              decoration: BoxDecoration(
                color: HexColor('#f04c24'),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () { Navigator.pop(context); },
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    GestureDetector(
                      onTap: () { print('ADD TO MY MOVIE LIST'); },
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ],
                )
              ),
            )
          )
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.13),
          //   child: Center(
          //     child: SingleChildScrollView(
          //       child: Container(
          //         padding: EdgeInsets.symmetric(vertical: screenSize.height * .05, horizontal: screenSize.width * .05),
          //         child: Column(
          //           children: <Widget>[
          //             /************** Title **************/
          //             Text((movieDetail['Title'] == "N/A" || !movieDetail.containsKey('Title'))
          //             ? "No Title Data"
          //             : movieDetail['Title'],
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //               color: Colors.white,
          //               // fontFamily: 'Questrial',
          //               fontSize: 24,
          //               letterSpacing: 1.8,
          //               fontWeight: FontWeight.bold
          //             ),
          //             ),
          //             SizedBox(height: 35),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: <Widget>[
          //                 /************** Released **************/
          //                 Text((movieDetail['Released'] == "N/A" || !movieDetail.containsKey('Released'))
          //                 ? "No Released Data"
          //                 : movieDetail['Released'],
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   // fontFamily: 'Questrial',
          //                   fontSize: 15
          //                 ),
          //                 ),
          //                 /************** Run Time **************/
          //                 Text((movieDetail['Runtime'] == "N/A" || !movieDetail.containsKey('Runtime'))
          //                 ? "No Runtime Data"
          //                 : movieDetail['Runtime'],
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   // fontFamily: 'Questrial',
          //                   fontSize: 15
          //                 ),
          //                 ),
          //               ],
          //             ),
          //             SizedBox(height: 35),
          //             /************** Genre **************/
          //             Align(
          //               alignment: Alignment.centerLeft,
          //               child: Text((movieDetail['Genre'] == "N/A" || !movieDetail.containsKey('Genre'))
          //               ? "No Genre Data"
          //               : movieDetail['Genre'],
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 // fontFamily: 'Questrial',
          //                 fontSize: 15
          //               ),
          //               ),
          //             ), 
          //             SizedBox(height: 12),
          //             /************** Director **************/
          //             Align(
          //               alignment: Alignment.centerLeft,
          //               child: Text((movieDetail['Director'] == "N/A" || !movieDetail.containsKey('Director'))
          //               ? "No Director Data"
          //               : movieDetail['Director'],
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 // fontFamily: 'Questrial',
          //                 fontSize: 15
          //               ),
          //               ),
          //             ),
          //             SizedBox(height: 12),
          //             /************** Actors **************/
          //             Align(
          //               alignment: Alignment.centerLeft,
          //               child: Text((movieDetail['Actors'] == "N/A" || !movieDetail.containsKey('Actors'))
          //               ? "No Actors Data"
          //               : movieDetail['Actors'],
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 // fontFamily: 'Questrial',
          //                 fontSize: 15
          //               ),
          //               ),
          //             ),
          //             SizedBox(height: 35),
          //             /************** Plot **************/
          //             Align(
          //               alignment: Alignment.centerLeft,
          //               child: Text((movieDetail['Plot'] == "N/A" || !movieDetail.containsKey('Plot'))
          //               ? "No Plot Data"
          //               : movieDetail['Plot'],
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 // fontFamily: 'Questrial',
          //                 fontSize: 15
          //               ),
          //               ),
          //             ),
          //             SizedBox(height: 35),
          //             /************** Rating Source **************/
          //             movieDetail['Ratings'] == "N/A" || !movieDetail.containsKey('Ratings')
          //             ? Align(
          //               alignment: Alignment.centerLeft,
          //               child: Text(
          //                 "No Rate Data",
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   // fontFamily: 'Questrial',
          //                   fontSize: 15
          //                 ),
          //               ),
          //             )
          //             : Column(
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: <Widget>[
          //                 for(var item in movieDetail['Ratings']) 
          //                 Padding(
          //                   padding: const EdgeInsets.only(bottom: 18),
          //                   child: Column(
          //                     children: <Widget>[
          //                       Text(
          //                         item['Source'],
          //                         style: TextStyle(
          //                           color: Colors.amber,
          //                           // fontFamily: 'Questrial',
          //                           fontSize: 14
          //                         ),
          //                       ),
          //                       SizedBox(height: 5),
          //                       Text(
          //                         item['Value'],
          //                         style: TextStyle(
          //                           color: Colors.amber,
          //                           // fontFamily: 'Questrial',
          //                           fontSize: 14
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 )
          //               ]
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: screenSize.height * 0.055,
          //   left: screenSize.width * 0.07,
          //   child: GestureDetector(
          //     onTap: () { Navigator.pop(context); },
          //     child: Icon(
          //       Icons.arrow_back,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          // Positioned(
          //   bottom: screenSize.height * 0.04,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     alignment: Alignment.center,
          //     child: FlatButton.icon(
          //       onPressed: () { print('ADD TO MY MOVIE LIST'); },
          //       icon: Icon(Icons.add, color: Colors.white),
          //       label: Text(
          //         'My Movie List',
          //         style: TextStyle(
          //           color: Colors.white,
          //           // fontFamily: 'Questrial',
          //           fontSize: 17
          //         ),
          //       ),
          //     )
          //   )
          // )
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
