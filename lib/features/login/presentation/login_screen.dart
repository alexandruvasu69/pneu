import 'package:flutter/material.dart';
import 'package:pneu/features/login/presentation/notifiers/user_notifier.dart';
import 'package:pneu/features/login/presentation/signup_screen.dart';
import 'package:pneu/features/map/presentation/map_screen.dart';
import 'package:pneu/shared/stores/user_store.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoadingLocal = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserNotifier>(context);

    if (userProv.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 48),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: const ValueKey('login_email'),
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (val) {
                        _email = val!.trim();
                      },
                      validator: (val) {
                        if (val == null || !val.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('login_password'),
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (val) {
                        _password = val!.trim();
                      },
                      validator: (val) {
                        if (val == null || val.length < 6) {
                          return 'Password should have a minimum of 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 16),
                    _isLoadingLocal
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => _submitLogin(context),
                            child: const Text('Login'),
                          ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(SignupScreen.routeName);
                      },
                      child: const Text('Don\'t have an account? Sign up'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitLogin(BuildContext context) async {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();

    setState(() {
      _errorMessage = null;
      _isLoadingLocal = true;
    });

    try {
      await Provider.of<UserNotifier>(context, listen: false).signIn(
        email: _email,
        password: _password,
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocal = false;
        });
      }
    }
  }
}
