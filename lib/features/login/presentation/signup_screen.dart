import 'package:flutter/material.dart';
import 'package:pneu/features/map/presentation/screens/map_screen.dart';
import 'package:pneu/shared/stores/user_store.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoadingLocal = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserStore>(context);
    if (userProv.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Înregistrare')),
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
                      key: const ValueKey('signup_email'),
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
                      key: const ValueKey('signup_password'),
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
                            onPressed: () => _submitSignup(context),
                            child: const Text('Creează cont'),
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

  Future<void> _submitSignup(BuildContext context) async {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();

    setState(() {
      _errorMessage = null;
      _isLoadingLocal = true;
    });

    try {
      await Provider.of<UserStore>(context, listen: false).signUp(
        email: _email,
        password: _password,
      );
      // Dacă a reușit, du‐te la Home
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
