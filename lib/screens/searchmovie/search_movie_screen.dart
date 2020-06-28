import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/search/search_model.dart';

class SearchMovieScreenM extends StatefulWidget {
  @override
  _SearchMovieScreenMState createState() => _SearchMovieScreenMState();
}

class _SearchMovieScreenMState extends State<SearchMovieScreenM> {

  bool isLoading = false;
  bool isValidating = false;

  final _searchController = TextEditingController();
  final _searchFormKey = GlobalKey<FormState>();
  final _scaffoldSearchKey = GlobalKey<ScaffoldState>();

  Future<void> onClickDetail(String imdbID) async {
    Navigator.of(context).pushNamed('/detailmovie', arguments: {
      "imdbID" : imdbID,
      // Additional Parameter
    });
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();

    final validation = _searchFormKey.currentState.validate();

    if(!isValidating){
      return ;
    }
    
    setState(() {
      isLoading = true;
    });

    Provider.of<SearchModel>(context, listen: false).searchMovieWithTitle(_searchController.text.trim())
    .then((err) {
      if(err == null) {
        setState(() {
          isLoading = false;
        });
        return;
      } 
      _scaffoldSearchKey.currentState.showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        )
      );
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final movieList = Provider.of<SearchModel>(context).movieList;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldSearchKey,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, deviceSize) {

          return GestureDetector(
            onTap: () { FocusScope.of(context).unfocus(); },
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                      ),
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Form(
                            key: _searchFormKey,
                            child: Container(
                              width: screenSize.width * .7,
                              height: 50,
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                cursorColor: Colors.black87,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                enableSuggestions: false,
                                key: ValueKey('search'),
                                validator: (value) {
                                  if(value.isEmpty) {
                                    _scaffoldSearchKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text('Please enter any movie'),
                                        backgroundColor: Theme.of(context).errorColor,
                                        duration: const Duration(seconds: 2),
                                      )
                                    );
                                    setState(() {
                                      isValidating = false;
                                    });
                                    return null;
                                  }
                                  setState(() {
                                    isValidating = true;
                                  });
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(color: Colors.black87),
                                  border: InputBorder.none,
                                ),
                                controller: _searchController,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _saveForm,
                            child: Icon(
                              Icons.search,
                              color: Colors.black87,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(height: 3, color: Colors.black87),
                    isLoading
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                            )
                          ],
                        ),
                    )
                    : movieList.length > 0
                      ? Container(
                          width: double.infinity,
                          height: screenSize.height * 1 - screenSize.height * .1 - 87, // Bottom Nav & Search Bar
                          child: ListView.builder(
                            itemCount: movieList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () { onClickDetail(movieList[index].imdbID); },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Card(
                                    elevation: 3,
                                    child: ListTile(
                                      leading: Container(
                                        width: screenSize.width * .2,
                                        height: screenSize.height * .2,
                                        child: movieList[index].poster == "N/A"
                                        ? Container()
                                        : Image.network(movieList[index].poster, fit: BoxFit.cover)
                                      ),
                                      title: movieList[index].title == "N/A"
                                      ? Text('')
                                      : Text(
                                        movieList[index].title,
                                        style: TextStyle(
                                          // fontFamily: 'Questrial', 
                                          fontSize: 15,
                                          color: Colors.black87
                                        )
                                      ),
                                      subtitle: movieList[index].year == "N/A"
                                      ? Text('')
                                      : Text(
                                        movieList[index].year,
                                        style: TextStyle(
                                          // fontFamily: 'Questrial',
                                          fontSize: 13,
                                          color: Colors.grey[500]
                                        )
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),
                        )
                      : Expanded(
                        child: Center(
                          child: Text(
                            'Please Search',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87
                            ),
                          )
                        ),
                      )
                  ],
                ),
              ),
            ),
          );
        }
      )
    );
  }
}

class SearchMovieScreenT extends StatefulWidget {
  @override
  _SearchMovieScreenTState createState() => _SearchMovieScreenTState();
}

class _SearchMovieScreenTState extends State<SearchMovieScreenT> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}