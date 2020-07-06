import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/auth/auth_model.dart';
import '../reusuable/loading/loading_screen.dart';
import '../../services/hex_color.dart';
import '../../model/appconfig/app_locale.dart';

class ForgotPasswordScreenM extends StatefulWidget {
  @override
  _ForgotPasswordScreenMState createState() => _ForgotPasswordScreenMState();
}

class _ForgotPasswordScreenMState extends State<ForgotPasswordScreenM> {

  bool isLoading = false;
  bool isValidating = false;

  final _emailForgotPasswordController = TextEditingController();
  final _authForgotPasswordFormKey = GlobalKey<FormState>();
  final _scaffoldForgotPasswordKey = GlobalKey<ScaffoldState>();

  Future<void> _saveForm() async {
    final validation = _authForgotPasswordFormKey.currentState.validate();

    if(!isValidating){
      return ;
    }
    
    setState(() {
      isLoading = true;
    });

    Provider.of<AuthModel>(context, listen: false).authForgotPassword(_emailForgotPasswordController.text.trim())
    .then((err) {
      if(err == null) {
        Navigator.pop(context);
        return;
      } 
      _scaffoldForgotPasswordKey.currentState.showSnackBar(
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
    _emailForgotPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldForgotPasswordKey,
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: isLoading
      ? LoadingScreen()
      : GestureDetector(
        onTap: () { FocusScope.of(context).unfocus(); },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: screenSize.height * 0.12),
              padding: EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/forgotpassword_image.png',
                      fit: BoxFit.fitWidth
                    ),
                    SizedBox(height: screenSize.height * 0.06),
                    Form(
                      key: _authForgotPasswordFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                              border: Border.all(width: 1, color: Colors.black87)
                              // gradient: LinearGradient(
                              //   begin: Alignment.topRight,
                              //   end: Alignment.bottomLeft,
                              //   colors: [Colors.grey[400], Colors.grey[200]]
                              // ),
                            ),
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              cursorColor: Colors.black,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              enableSuggestions: false,
                              key: ValueKey('forgotPasswordEmail'),
                              validator: (value) {
                                if(value.isEmpty || !value.contains('@')) {
                                  _scaffoldForgotPasswordKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text(AppLocalizations.of(context).translate('emailErrorMsg')),
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
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context).translate('emailHintText'),
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.alternate_email,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                              controller: _emailForgotPasswordController,
                            ),
                          ),
                          SizedBox(height: 25),
                          GestureDetector(
                            onTap: _saveForm,
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: HexColor('#d90429'),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey.withOpacity(0.5),
                                //     spreadRadius: 2,
                                //     blurRadius: 2,
                                //     offset: Offset(0, 2),
                                //   ),
                                // ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context).translate('sendButtonText'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ),
                          ),
                          SizedBox(height: 25),
                          Text(
                            AppLocalizations.of(context).translate('forgotPasswordNotification'),
                            style: TextStyle(
                              fontSize: 15,
                              // fontFamily: 'Questrial'
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),
              ) 
            ),
            Positioned(
              top: screenSize.height * 0.08,
              left: screenSize.width * 0.08,
              child: GestureDetector(
                onTap: () { Navigator.pop(context); },
                child: Icon(
                  Icons.arrow_back
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordScreenT extends StatefulWidget {
  @override
  _ForgotPasswordScreenTState createState() => _ForgotPasswordScreenTState();
}

class _ForgotPasswordScreenTState extends State<ForgotPasswordScreenT> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}