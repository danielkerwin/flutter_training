import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/auth.model.dart';
import '../models/http_exception.model.dart';
import '../providers/auth.provider.dart';

class AuthForm extends StatefulWidget {
  final AuthMode authMode;
  final VoidCallback switchAuthMode;
  final Animation<double> opacityAnimation;
  final Animation<Offset> slideAnimation;

  const AuthForm({
    Key? key,
    required this.authMode,
    required this.switchAuthMode,
    required this.opacityAnimation,
    required this.slideAnimation,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final AuthData _authData = AuthData(email: '', password: '');
  final _passwordController = TextEditingController();

  var _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();
    try {
      await Provider.of<Auth>(context, listen: false).authenticate(
        _authData.email,
        _authData.password,
        widget.authMode,
      );
    } on HttpException catch (err) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text(err.toString()),
        ),
      );
    } catch (err) {
      scaffold.showSnackBar(
        const SnackBar(
          content:
              Text('Unknown error while logging in - please try again later'),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'E-Mail'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null) {
                  return 'Email required';
                }
                if (value.isEmpty || !value.contains('@')) {
                  return 'Invalid email!';
                }
                return null;
              },
              onSaved: (value) {
                _authData.email = value ?? '';
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value == null) {
                  return 'Password required';
                }
                if (value.isEmpty || value.length < 5) {
                  return 'Password is too short!';
                }
                return null;
              },
              onSaved: (value) {
                _authData.password = value ?? '';
              },
            ),
            AnimatedContainer(
              constraints: BoxConstraints(
                minHeight: widget.authMode == AuthMode.signup ? 60 : 0,
                maxHeight: widget.authMode == AuthMode.signup ? 120 : 0,
              ),
              curve: Curves.linear,
              duration: const Duration(milliseconds: 250),
              child: FadeTransition(
                opacity: widget.opacityAnimation,
                child: SlideTransition(
                  position: widget.slideAnimation,
                  child: TextFormField(
                    enabled: widget.authMode == AuthMode.signup,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: widget.authMode == AuthMode.signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                child: Text(
                  widget.authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP',
                ),
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Theme.of(context).primaryTextTheme.button?.color,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 8.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            TextButton(
              child: Text(
                '${widget.authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: widget.switchAuthMode,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 4,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
