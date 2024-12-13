import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbox_app/Provider/login_provider.dart';
import 'package:qbox_app/Utils/validator.dart';
import 'package:qbox_app/Widgets/Common/app_button.dart';
import 'package:qbox_app/Widgets/Common/app_colors.dart';
import 'package:qbox_app/Widgets/Common/app_text.dart';
import 'package:qbox_app/Widgets/Custom/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    final formProvider = Provider.of<LoginProvider>(context, listen: false);
    _emailController = TextEditingController(text: formProvider.email);
    _passwordController = TextEditingController(text:formProvider.password);
    super.initState();
    _emailController.addListener((){
      formProvider.setEmail(_emailController.text);
    });
    _passwordController.addListener((){
      formProvider.setPassword(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    var obsecureText = loginProvider.obsecureText;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppText(
                  text: "QBox", fontSize: 36, fontWeight: FontWeight.w700),
              const SizedBox(height: 25),
              const Align(
                  alignment: Alignment.topLeft,
                  child: AppText(text: "User Id", fontSize: 18)),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: _emailController,
                hintText: "Enter user id",
                validationRules: [Validator.required(message: "Email is required"), Validator.email()],
                suffixIcon: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.email_outlined)),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: AppText(text: "Password", fontSize: 18)),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: _passwordController,
                hintText: "Enter password",
                validationRules: [Validator.required(message: "Password is required"), Validator.password()],
                suffixIcon: IconButton(
                  onPressed: () =>
                      context.read<LoginProvider>().toggleObsecureText(),
                  icon: Icon(obsecureText
                      ? Icons.remove_red_eye_outlined
                      : Icons.visibility_off_outlined),
                ),
                obscureText: obsecureText,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: CustomButton(
                    elevation: 0,
                    label: "Login",
                    color: AppColors.buttonBgColor,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(loginProvider.email);
                        loginProvider.login(context);
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
