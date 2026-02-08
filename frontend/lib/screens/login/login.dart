import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  String? _error;

  SupabaseClient get _sb => Supabase.instance.client;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String _prettyError(Object e) {
    if (e is AuthException) return e.message;
    return e.toString();
  }

  Future<bool> _isOnboardingDone(String userId) async {
    // Prefer a dedicated flag if you created it.
    // Falls back to "age_group exists" so it works even without schema changes.
    final profile = await _sb
        .from('profiles')
        .select('onboarding_done, age_group')
        .eq('id', userId)
        .maybeSingle();

    if (profile == null) return false;

    final doneFlag = profile['onboarding_done'];
    if (doneFlag == true) return true;

    final ageGroup = profile['age_group'];
    return ageGroup != null && (ageGroup as String).trim().isNotEmpty;
  }

  Future<void> _onLogin() async {
    final email = _email.text.trim();
    final password = _password.text;

    if (!email.contains('@')) {
      setState(() => _error = 'Please enter a valid email.');
      return;
    }
    if (password.isEmpty) {
      setState(() => _error = 'Please enter your password.');
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    try {
      final res = await _sb.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // If confirmations are enabled and something went wrong, be explicit.
      final user = _sb.auth.currentUser;
      if (res.session == null || user == null) {
        setState(() {
          _error =
              'Login returned no session. If you just signed up, confirm your email first, then log in again.';
        });
        return;
      }

      // ✅ Decide where to go: skip onboarding if already completed
      final done = await _isOnboardingDone(user.id);
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/home_screen');
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _prettyError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onForgotPassword() async {
    final email = _email.text.trim();

    if (!email.contains('@')) {
      setState(() => _error = 'Enter your email first to reset password.');
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    try {
      await _sb.auth.resetPasswordForEmail(email);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _prettyError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ===== Figma specs =====
  static const double _frameWidth = 393;

  static const Color _titleColor = Color(0xFF363E44);
  static const Color _fieldBg = Color(0xFFEDFFFC);
  static const Color _buttonBg = Color(0xFFF05B55);
  static const Color _word = Color(0xFF9EE3D8);

  static const TextStyle _titleStyle = TextStyle(
    color: _titleColor,
    fontFamily: 'Tilt Warp',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.28125,
  );

  static const TextStyle _body16Comfortaa = TextStyle(
    color: _titleColor,
    fontFamily: 'Comfortaa',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  static const TextStyle _hintComfortaa = TextStyle(
    color: Color(0xFFB9B9B9),
    fontFamily: 'Comfortaa',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  static const TextStyle _dividerComfortaa = TextStyle(
    color: _titleColor,
    fontFamily: 'Comfortaa',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  static const TextStyle _buttonTextComfortaa = TextStyle(
    color: Colors.white,
    fontFamily: 'Comfortaa',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  static const TextStyle _createAccountComfortaa = TextStyle(
    color: _buttonBg,
    fontFamily: 'Comfortaa',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  Widget _authTextField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
  }) {
    return SizedBox(
      width: 346,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          color: _fieldBg,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: _body16Comfortaa.copyWith(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: _hintComfortaa,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _primaryButton() {
    return SizedBox(
      width: 346,
      height: 48,
      child: ElevatedButton(
        onPressed: _loading ? null : _onLogin,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _buttonBg,
          disabledBackgroundColor: _buttonBg.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text('Log in', style: _buttonTextComfortaa),
      ),
    );
  }

  Widget _dividerRow() {
    return Row(
      children: const [
        Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('Or Sign in with', style: _dividerComfortaa),
        ),
        Expanded(child: Divider(thickness: 1)),
      ],
    );
  }

  static Widget _socialBox({required Widget child}) {
    return SizedBox(
      width: 88,
      height: 56,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: _titleColor, width: 1),
        ),
        child: Center(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _frameWidth),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 54),
                            const SizedBox(
                              width: 344,
                              child: Text(
                                "Welcome back!\nGlad to see you, again",
                                style: _titleStyle,
                              ),
                            ),
                            const SizedBox(height: 28),
                            _authTextField(
                              controller: _email,
                              hint: "Enter your email",
                            ),
                            const SizedBox(height: 16),
                            _authTextField(
                              controller: _password,
                              hint: "Enter your password",
                              obscure: true,
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _loading ? null : _onForgotPassword,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Forgot Password?',
                                  style: _body16Comfortaa,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_error != null) ...[
                              const SizedBox(height: 0),
                              Text(
                                _error!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Comfortaa',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.33,
                                ),
                              ),
                            ],
                            _primaryButton(),
                            const SizedBox(height: 64),
                            _dividerRow(),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _socialBox(
                                  child: const Text(
                                    'f',
                                    style: TextStyle(
                                      color: _titleColor,
                                      fontFamily: 'Comfortaa',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                _socialBox(
                                  child: const Text(
                                    'G',
                                    style: TextStyle(
                                      color: _titleColor,
                                      fontFamily: 'Comfortaa',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                _socialBox(
                                  child: const Icon(Icons.apple,
                                      size: 26, color: _titleColor),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Center(
                              child: TextButton(
                                onPressed: _loading
                                    ? null
                                    : () => Navigator.pushNamed(context, '/signup'),
                                child: const Text(
                                  'Create an account',
                                  style: _createAccountComfortaa,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
