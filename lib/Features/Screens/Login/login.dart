import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:qbox_app/Provider/login_provider.dart';
import 'package:qbox_app/Widgets/Common/app_button.dart';
import 'package:qbox_app/Widgets/Common/app_colors.dart';
import 'package:qbox_app/Widgets/Common/app_text.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obsecureText = true;

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: FormBuilder(
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
              FormBuilderTextField(
                name: 'userId',
                keyboardType: TextInputType.text,
                onChanged: (value)=>loginProvider.setEmail(value!),
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.email_outlined),
                    filled: true,
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Enter your user id',
                    floatingLabelBehavior: FloatingLabelBehavior.never),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'User id is required'),
                  FormBuilderValidators.email(
                      errorText: 'Enter a valid user id')
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: AppText(text: "Password", fontSize: 18)),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'password',
                keyboardType: TextInputType.text,
                onChanged: (value)=>loginProvider.setPassword(value!),
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(_obsecureText
                          ? Icons.remove_red_eye_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () {
                        setState(() {
                          _obsecureText = !_obsecureText;
                        });
                      },
                    ),
                    filled: true,
                    border:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Enter your password',
                    floatingLabelBehavior: FloatingLabelBehavior.never),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Password is required'),
                  FormBuilderValidators.password(
                      errorText: 'Password should be 8 digits', minLength: 8)
                ]),
                obscureText: _obsecureText,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child:CustomButton(
                      elevation: 0,
                      label: "Login",
                      color: AppColors.buttonBgColor,
                      onPressed: () => loginProvider.login(context)))
            ],
          ),
        ),
      ),
    );
  }
}
