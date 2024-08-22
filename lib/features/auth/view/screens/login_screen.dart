import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/screens/signup_screen.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../../core/widgets/custom_field.dart';
import '../widgets/auth_gradient_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authViewModelProvider.select(
        (val) => val?.isLoading == true,
      ),
    );
    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
           Navigator.pushAndRemoveUntil(
             context,
             MaterialPageRoute(
               builder: (context) => const HomeScreen(),
             ),(_) => false,
           );
        },
        error: (error, st) {
          showSnackBar(
            context: context,
            message: error.toString(),
          );
        },
        loading: () {},
      );
    });
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Column(
                      children: [
                        const Text(
                          'Sign In.',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomField(
                          hintText: 'Email',
                          controller: emailController,
                        ),
                        const SizedBox(height: 15),
                        CustomField(
                          hintText: 'Password',
                          controller: passwordController,
                          isObscureText: true,
                        ),
                        const SizedBox(height: 20),
                        AuthGradientButton(
                          buttonText: 'Sign in',
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              await ref
                                  .read(authViewModelProvider.notifier)
                                  .loginUser(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Don\'t have an account? ',
                              style: Theme.of(context).textTheme.titleMedium,
                              children: const [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: Palette.gradient2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
