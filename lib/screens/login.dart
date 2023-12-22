import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final idController = TextEditingController();

  final passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AutofillGroup(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '愛工大へログイン',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextField(
                      autofillHints: const [AutofillHints.email],
                      controller: idController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: '愛工大ID',
                        isDense: true,
                        prefixIcon: const Icon(Icons.account_circle),
                        fillColor: Theme.of(context).hoverColor,
                        filled: true,
                        // border: InputBorder.none,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextField(
                      autofillHints: const [AutofillHints.password],
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        hintText: 'パスワード',
                        isDense: true,
                        prefixIcon: const Icon(Icons.lock),
                        fillColor: Theme.of(context).hoverColor,
                        filled: true,
                        // border: InputBorder.none,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final cookies = await getCookie();
                        final loginBool = await loginLcam(
                          idController.text,
                          passwordController.text,
                          cookies[0],
                          cookies[1],
                        );
                        if (loginBool) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('id', idController.text);
                          await prefs.setString(
                            'password',
                            passwordController.text,
                          );
                          ref.read(idPasswordProvider.notifier).setIdPassword(
                                idController.text,
                                passwordController.text,
                              );
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (ctx) => const TabScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text('ログイン'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
