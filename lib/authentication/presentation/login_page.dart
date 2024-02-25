import 'package:expatrio_login_app/authentication/provider/auth_notifier.dart';
import 'package:expatrio_login_app/tax_data/presentation/tax_data_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

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
    FocusManager.instance.primaryFocus?.unfocus();

    final email = emailController.text;
    final password = passwordController.text;

    Provider.of<AuthNotifier>(context, listen: false)
        .signIn(data: {
          "email": email,
          "password": password,
        })
        .then((_) => showModalBottomSheet(
              context: context,
              builder: (context) {
                return const SuccessModalBottomSheet();
              },
            ))
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(),
          body: Column(
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
                      SizedBox(
                          width: double.infinity, child: _builldSaveButton()),
                    ],
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              Opacity(
                opacity: 0.5,
                child: Lottie.asset('assets/login-background.json'),
              )
            ],
          )),
    );
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
            : const Text("LOGIN"),
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

class SuccessModalBottomSheet extends StatelessWidget {
  const SuccessModalBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.check_circle_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 20),
          Text("Successful Login",
              style: Theme.of(context).textTheme.titleLarge),
          //subtitle
          const SizedBox(height: 10),
          Text(
            "You will be redirected to your dashboard",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context); // close the bottom sheet
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TaxDataPage(),
                  ),
                );
              },
              child: const Text("GOT IT"),
            ),
          ),
        ],
      ),
    );
  }
}
