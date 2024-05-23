import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/core/utils/navigator/navigators.dart';
import 'package:social_x/core/utils/popups/snackbars.dart';
import 'package:social_x/core/utils/validators/validation.dart';
import 'package:social_x/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:social_x/src/authentication/presentation/pages/register.dart';
import 'package:social_x/src/authentication/presentation/widgets/password_text_field.dart';
import 'package:social_x/src/authentication/presentation/widgets/text_form_builder.dart';
import 'package:social_x/src/user/presentation/bloc/cubit/currentuser_cubit.dart';
import 'package:social_x/tab_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final emailFN = FocusNode();
  final passFN = FocusNode();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    emailFN.dispose();
    passFN.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // LoginViewModel viewModel = Provider.of<LoginViewModel>(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          TSnackBar.showErrorSnackBar(context: context, message: state.error);
        }
        if (state is Authenticated) {
          context.read<CurrentuserCubit>().getCurrentUserData();
          TNavigators.offALL(context, const TabScreen());
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          progressIndicator: circularProgress(context),
          isLoading: state is AuthLoading,
          child: Scaffold(
            backgroundColor: Colors.white,
            //  key: viewModel.scaffoldKey,
            body: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 5),
                SizedBox(
                  height: 170.0,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/images/login.png',
                  ),
                ),
                const SizedBox(height: 10.0),
                const Center(
                  child: Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Log into your account and get started!',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                buildForm(context),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    const SizedBox(width: 5.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => Register(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  buildForm(BuildContext context) {
    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          TextFormBuilder(
            controller: email,
            prefix: Ionicons.mail_outline,
            hintText: "Email",
            textInputAction: TextInputAction.next,
            validateFunction: (value) => TValidator.validateEmail(value),
            focusNode: emailFN,
            nextFocusNode: passFN,
          ),
          const SizedBox(height: 15.0),
          PasswordFormBuilder(
            controller: password,
            prefix: Ionicons.lock_closed_outline,
            suffix: Ionicons.eye_outline,
            hintText: "Password",
            textInputAction: TextInputAction.done,
            validateFunction: (value) => TValidator.validatePassword(value),
            obscureText: true,
            focusNode: passFN,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                //   onTap: () => viewModel.forgotPassword(context),
                child: Container(
                  width: 130,
                  height: 40,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 45.0,
            width: 180.0,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              // highlightElevation: 4.0,
              child: Text(
                'Log in'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                if (loginFormKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(
                      OnLoginUser(email: email.text, password: password.text));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
