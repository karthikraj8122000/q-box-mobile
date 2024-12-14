import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbox/Provider/login_provider.dart';
import 'package:qbox/Utils/validator.dart';
import 'package:qbox/Widgets/Common/app_button.dart';
import 'package:qbox/Widgets/Common/app_colors.dart';
import 'package:qbox/Widgets/Common/app_text.dart';
import 'package:qbox/Widgets/Custom/custom_text_field.dart';

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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: AppText(
                      text: "QBox",
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const AppText(text: "SavorEase – Your Food, Your Way!", fontSize: 14,color: Colors.grey,),
                const SizedBox(height: 20),
                const AppText(
                  text: "Sign In",
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  // color: Colors.pinkAccent[100],
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
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
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Switch(
                                  onChanged: (value) {
                                    loginProvider.toggleRememberMe(value);
                                  },
                                  value: loginProvider.rememberMe,
                                  activeColor: Colors.white,
                                  activeTrackColor: Colors.grey[900],
                                  inactiveThumbColor: Colors.grey[800],
                                  inactiveTrackColor: Colors.grey[900],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    loginProvider.toggleRememberMe(!loginProvider.rememberMe);
                                  },
                                  child: const AppText(
                                    text: "Remember me",
                                    fontSize: 14,
                                    color:Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {

                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: AppText(
                                  text: "Forgot password?",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  // color: Colors.black,
                                ),
                              ),
                            ),
                          ],
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
                                  loginProvider.login(context);
                                }
                              },
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: AppText(
                                  text: "Don\'t have an account?",
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                              InkWell(
                                child: const AppText(
                                    text: "Sign up",
                                    fontSize: 14,
                                    color: Colors.pink,
                                    fontWeight: FontWeight.w500),
                                onTap: () {

                                },
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
