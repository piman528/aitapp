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
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('愛工大へログイン'),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: idController,
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: passwordController,
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('id', idController.text);
                  await prefs.setString('password', passwordController.text);
                  ref.read(idPasswordProvider.notifier).setIdPassword(
                        idController.text,
                        passwordController.text,
                      );
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (ctx) => const TabScreen(),
                    ),
                  );
                },
                child: const Text('ログイン'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
