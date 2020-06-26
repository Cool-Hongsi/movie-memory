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
                                cursorColor: Colors.black,
                                style: TextStyle(
                                  color: Colors.black,
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
                    Divider(height: 3, color: Colors.black54),
                    isLoading
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[700]),
                            )
                          ],
                        ),
                    )
                    : movieList.length > 0
                      ? Container(
                          width: double.infinity,
                          height: screenSize.height * .708,
                          child: ListView.builder(
                            itemCount: movieList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    child: Image.network(movieList[index].poster)
                                  ),
                                  title: Text(movieList[index].title),
                                  subtitle: Text(movieList[index].year),
                                ),
                              );
                            }
                          ),
                        )
                      : Expanded(
                        child: Center(
                          child: Text(
                            'No Movies',
                            textAlign: TextAlign.center,
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