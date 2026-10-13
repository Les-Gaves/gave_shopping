import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../theme/app_theme.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _loading = false;
  bool _hidePassword = true;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      if (_isLogin) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      }
      if (mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _messageFor(e.code));
    } catch (_) {
      setState(() => _error = 'Une erreur est survenue. Réessayez.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Méthode de connexion avec Google
  Future<void> _signInWithGoogle() async {
    setState(() {
        _loading = true;
        _error = null;
    });

    try {
        if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
        } else {
        final googleUser = await GoogleSignIn.instance.authenticate();

        const scopes = ['email', 'profile'];
        final clientAuth =
            await googleUser.authorizationClient.authorizeScopes(scopes);

        final credential = GoogleAuthProvider.credential(
            accessToken: clientAuth.accessToken,
            idToken: googleUser.authentication.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        }

        if (mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
        setState(() => _error = _messageFor(e.code));
    } catch (e) {
        debugPrint('Erreur Google Sign-In : $e');
        setState(() => _error = 'Erreur lors de la connexion avec Google.');
    } finally {
        if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Saisissez votre e-mail pour réinitialiser.');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail de réinitialisation envoyé.')),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _messageFor(e.code));
    }
  }

  String _messageFor(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Adresse e-mail invalide.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou mot de passe incorrect.';
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cet e-mail.';
      case 'weak-password':
        return 'Mot de passe trop faible (6 caractères minimum).';
      case 'network-request-failed':
        return 'Problème de connexion réseau.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return 'Connexion annulée.';
      case 'popup-blocked':
        return 'La popup a été bloquée. Autorisez-la dans votre navigateur.';
      case 'unauthorized-domain':
        return "Ce domaine n'est pas autorisé dans Firebase.";
      case 'operation-not-al lowed':
        return "Cette méthode de connexion n'est pas activée dans Firebase.";  
      default:
        return 'Erreur : $code';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GAVE',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: AppTheme.riverDark,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.kayaking_rounded,
                          size: 40, color: AppTheme.riverTeal),
                      const SizedBox(height: 12),
                      Text(
                        _isLogin ? 'Connexion' : 'Créer un compte',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.riverDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        decoration: _decoration('E-mail', Icons.mail_outline),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Saisissez votre e-mail';
                          }
                          if (!v.contains('@')) return 'E-mail invalide';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        autofillHints: const [AutofillHints.password],
                        onFieldSubmitted: (_) => _submit(),
                        decoration:
                            _decoration('Mot de passe', Icons.lock_outline)
                                .copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(_hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () =>
                                setState(() => _hidePassword = !_hidePassword),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Saisissez votre mot de passe';
                          }
                          if (!_isLogin && v.length < 6) {
                            return '6 caractères minimum';
                          }
                          return null;
                        },
                      ),
                      if (_isLogin)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _loading ? null : _resetPassword,
                            child: const Text('Mot de passe oublié ?'),
                          ),
                        ),
                      if (_error != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.safetyOrangeLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: Color(0xFF7A2508),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(_isLogin ? 'Se connecter' : "S'inscrire"),
                      ),
                      const SizedBox(height: 12),
                                          
                      SizedBox(
                        height: 48,
                        child: SignInButton(
                            Buttons.google,
                            text: "Continuer avec Google",
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: _loading ? () {} : _signInWithGoogle,
                        ),
                        ),
                                            
                        const SizedBox(height: 8),
                      TextButton(
                        onPressed: _loading
                            ? null
                            : () => setState(() {
                                  _isLogin = !_isLogin;
                                  _error = null;
                                }),
                        child: Text(
                          _isLogin
                              ? 'Pas de compte ? Créer un compte'
                              : 'Déjà un compte ? Se connecter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: AppTheme.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}