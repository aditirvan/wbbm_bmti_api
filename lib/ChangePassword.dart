import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbbm_bmti/Bloc/Account.dart';
import 'package:wbbm_bmti/Event/Account.dart';
import 'package:wbbm_bmti/Repository/Account.dart';

class ChangePassword extends StatefulWidget {
  final String email;
  final String password;

  const ChangePassword({Key key, this.email, this.password}) : super(key: key);
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountBloc(
        FakeAccountRepository(),
      ),
      child: ChangePasswordPage(
        email: widget.email,
        password: widget.password,
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  final String email;
  final String password;

  const ChangePasswordPage({Key key, this.email, this.password})
      : super(key: key);
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final retypePassword = TextEditingController();

  final currentPasswordNode = FocusNode();
  final newPasswordNode = FocusNode();
  final retypePasswordNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  AccountBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<AccountBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Ganti Password"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextFormField(
                      context, "Password saat ini", currentPassword),
                  _buildTextFormField(context, "Password baru", newPassword),
                  _buildTextFormField(
                      context, "Konfirmasi password", retypePassword),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ButtonTheme(
              minWidth: double.infinity,
              height: 45,
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (currentPassword.text == newPassword.text) {
                      if (newPassword.text == retypePassword.text) {
                        bloc.add(
                          UpdatePassword(
                            email: widget.email,
                            password: widget.password,
                          ),
                        );
                      } else {
                        Flushbar(
                          message: "Konfirmasi password tidak sama",
                          duration: Duration(seconds: 3),
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                        )..show(context);
                      }
                    } else {
                      Flushbar(
                        message: "Password saat ini salah",
                        duration: Duration(seconds: 3),
                        margin: EdgeInsets.all(8),
                        borderRadius: 8,
                      )..show(context);
                    }
                  }
                },
                child: Text(
                  "Ganti Password",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildTextFormField(
      BuildContext context, String name, TextEditingController controller) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 24.0, right: 24, top: 16, bottom: 16),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(hintText: name),
        validator: (value) {
          if (value.isEmpty) {
            return '$name wajib diisi';
          }
          return null;
        },
      ),
    );
  }
}
