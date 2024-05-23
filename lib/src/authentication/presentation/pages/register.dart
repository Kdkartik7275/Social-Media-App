import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/core/utils/navigator/navigators.dart';
import 'package:social_x/core/utils/popups/snackbars.dart';
import 'package:social_x/core/utils/validators/validation.dart';
import 'package:social_x/src/authentication/domain/usecases/register_user.dart';
import 'package:social_x/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:social_x/src/authentication/presentation/pages/profile_pic.dart';
import 'package:social_x/src/authentication/presentation/widgets/password_text_field.dart';
import 'package:social_x/src/authentication/presentation/widgets/text_form_builder.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final username = TextEditingController();
  final email = TextEditingController();
  final country = TextEditingController();
  final password = TextEditingController();
  final confirmPass = TextEditingController();

  final signUpFormKey = GlobalKey<FormState>();
  final usernameFN = FocusNode();
  final emailFN = FocusNode();
  final countryFN = FocusNode();
  final passFN = FocusNode();
  final confirmPassFN = FocusNode();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    username.dispose();
    confirmPass.dispose();
    country.dispose();
    emailFN.dispose();
    passFN.dispose();
    usernameFN.dispose();
    countryFN.dispose();
    confirmPassFN.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          TSnackBar.showErrorSnackBar(context: context, message: state.error);
        }
        if (state is UploadUserProfile) {
          return TNavigators.offALL(context, const ProfilePicture());
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          progressIndicator: circularProgress(context),
          isLoading: state is AuthLoading,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 10),
                Text(
                  'Welcome to WaveConnect\nCreate a new account and connect with friends',
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                const SizedBox(height: 30.0),
                buildForm(context),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account  ',
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Login',
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
      key: signUpFormKey,
      child: Column(
        children: [
          TextFormBuilder(
            controller: username,
            prefix: Ionicons.person_outline,
            hintText: "Username",
            validateFunction: (value) =>
                TValidator.validateEmptyText("Username", value),
            textInputAction: TextInputAction.next,
            //   validateFunction: Validations.validateName,
            onSaved: (String val) {},
            focusNode: usernameFN,
            nextFocusNode: emailFN,
          ),
          const SizedBox(height: 20.0),
          TextFormBuilder(
            controller: email,
            prefix: Ionicons.mail_outline,
            hintText: "Email",
            validateFunction: (value) => TValidator.validateEmail(value),

            textInputAction: TextInputAction.next,
            //  validateFunction: Validations.validateEmail,

            focusNode: emailFN,
            nextFocusNode: countryFN,
          ),
          const SizedBox(height: 20.0),
          TextFormBuilder(
            prefix: Ionicons.pin_outline,
            hintText: "Country",
            validateFunction: (value) =>
                TValidator.validateEmptyText("Country", value),

            textInputAction: TextInputAction.next,
            //  validateFunction: Validations.validateName,
            controller: country,
            focusNode: countryFN,
            nextFocusNode: passFN,
          ),
          const SizedBox(height: 20.0),
          PasswordFormBuilder(
            controller: password,
            prefix: Ionicons.lock_closed_outline,
            suffix: Ionicons.eye_outline,
            hintText: "Password",
            validateFunction: (value) => TValidator.validatePassword(value),

            textInputAction: TextInputAction.next,
            //  validateFunction: Validations.validatePassword,
            obscureText: true,

            focusNode: passFN,
            nextFocusNode: confirmPassFN,
          ),
          const SizedBox(height: 20.0),
          PasswordFormBuilder(
            controller: confirmPass,
            prefix: Ionicons.lock_open_outline,
            hintText: "Confirm Password",
            validateFunction: (value) {
              if (value != password.text) {
                return "Password does not match";
              }
              return null;
            },

            textInputAction: TextInputAction.done,
            // validateFunction: Validations.validatePassword,
            // submitAction: () => viewModel.register(context),
            obscureText: true,

            focusNode: confirmPassFN,
          ),
          const SizedBox(height: 25.0),
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
                    Theme.of(context).colorScheme.secondary),
              ),
              child: Text(
                'sign up'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                if (signUpFormKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(OnRegisterUser(
                      params: RegisterUserParams(
                          email: email.text,
                          username: username.text,
                          password: password.text,
                          country: country.text)));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
