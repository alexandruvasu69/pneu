import 'package:flutter/material.dart';
import 'package:pneu/features/login/presentation/notifiers/user_notifier.dart';
import 'package:pneu/features/login/presentation/signup_screen.dart';
import 'package:pneu/features/map/presentation/screens/map_screen.dart';
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

    // Dacă provider spune că e loading global, putem arăta un loader peste tot
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
                    // EMAIL
                    TextFormField(
                      key: const ValueKey('login_email'),
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (val) {
                        _email = val!.trim();
                      },
                      validator: (val) {
                        if (val == null || !val.contains('@')) {
                          return 'Te rog introdu un email valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // PAROLA
                    TextFormField(
                      key: const ValueKey('login_password'),
                      decoration: const InputDecoration(labelText: 'Parolă'),
                      obscureText: true,
                      onSaved: (val) {
                        _password = val!.trim();
                      },
                      validator: (val) {
                        if (val == null || val.length < 6) {
                          return 'Parola trebuie să aibă minim 6 caractere';
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
                            child: const Text('Loghează-te'),
                          ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(SignupScreen.routeName);
                      },
                      child: const Text('Nu ai cont? Înregistrează-te'),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),
                    // Buton de Guest (opțional, dacă vrei să îi lași să meargă direct)
                    ElevatedButton(
                      onPressed: () {
                        // Dacă deja există guest (provider deja a apelat RPC la pornire), îi dăm direct Home:
                        Navigator.of(context).pop();
                      },
                      child: const Text('Continuă ca Guest'),
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
      // Dacă a reușit, navighează la Home
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
