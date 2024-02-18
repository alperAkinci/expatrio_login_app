import 'package:expatrio_login_app/auth_notifier.dart';
import 'package:expatrio_login_app/tax_data/tax_data_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _onSubmit() {
    // close keyboard if it's open
    FocusScope.of(context).unfocus();

    final email = emailController.text;
    final password = passwordController.text;

    Future.wait([
      Provider.of<AuthNotifier>(context, listen: false).signIn(
        data: {
          "email": email,
          "password": password,
        },
        onSuccess: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TaxDataPage(),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You have successfully signed in!')),
          );
        },
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/2019_XP_logo_white.png',
                width: 200,
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildEmailAddress(),
                      const SizedBox(height: 20),
                      _buiildPassword(),
                      const SizedBox(height: 20),
                      Container(
                          width: double.infinity, child: _builldSaveButton()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _builldSaveButton() {
    return Consumer<AuthNotifier>(builder: (context, authProvider, child) {
      final isLoading = authProvider.isLoading;
      return FilledButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _onSubmit();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid Data')),
            );
          }
        },
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  // size of the spinner
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text('Sign In'),
      );
    });
  }

  Widget _buiildPassword() {
    return Column(
      children: [
        const Row(
          children: [
            Icon(Icons.lock_outline, size: 20),
            SizedBox(width: 4),
            Text('PASSWORD'),
          ],
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: passwordController..text = "nemampojma",
          style: const TextStyle(height: 0.7),
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'password',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailAddress() {
    return Column(
      children: [
        const Row(
          children: [
            Icon(Icons.email_outlined, size: 20),
            SizedBox(width: 4),
            Text('EMAIL ADDRESS'),
          ],
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: emailController..text = "tito+bs792@expatrio.com",
          style: const TextStyle(height: 0.7),
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'email',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email address';
            }
            return null;
          },
        ),
      ],
    );
  }
}
