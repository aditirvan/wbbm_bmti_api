import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wbbm_bmti/Bloc/Account.dart';
import 'package:wbbm_bmti/ChangePassword.dart';
import 'package:wbbm_bmti/Event/Account.dart';
import 'package:wbbm_bmti/Repository/Account.dart';
import 'package:wbbm_bmti/State/Account.dart';
import 'package:http/http.dart' as http;

class UpdateProfile extends StatefulWidget {
  final String email;
  final String password;

  const UpdateProfile({Key key, @required this.email, @required this.password})
      : super(key: key);
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Update Profile"),
        actions: [
          // FlatButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ChangePassword(
          //           email: widget.email,
          //           password: widget.password,
          //         ),
          //       ),
          //     );
          //   },
          //   child: Text(
          //     "Ganti Password",
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 16,
          //     ),
          //   ),
          // ),
        ],
      ),
      body: BlocProvider(
        create: (context) => AccountBloc(
          FakeAccountRepository(),
        ),
        child: UpdateProfilePage(
          email: widget.email,
          password: widget.password,
        ),
      ),
    );
  }
}

class UpdateProfilePage extends StatefulWidget {
  final String email;
  final String password;

  const UpdateProfilePage(
      {Key key, @required this.email, @required this.password})
      : super(key: key);
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final textFullNameController = TextEditingController();
  final textCompanyController = TextEditingController();
  final textProvinsiController = TextEditingController();
  final textKotaController = TextEditingController();

  AccountBloc bloc;
  final _formKey = GlobalKey<FormState>();

  Future<File> imageFile;
  File image;
  bool firstLoad = false;
  bool imageUpdate = false;

  Future<File> _downloadFile(String url, String filename) async {
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  pickImageFromGallery(ImageSource source) {
    setState(() {
      // ignore: deprecated_member_use
      imageFile = ImagePicker.pickImage(source: source);
      imageUpdate = true;
    });
  }

  getFile() {}

  showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          image = snapshot.data;
          return Container(
            height: 250,
            child: GestureDetector(
              onTap: () => pickImageFromGallery(ImageSource.gallery),
              child: Image.file(
                snapshot.data,
              ),
            ),
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 0.7,
                color: Colors.grey,
              ),
            ),
            width: 100,
            height: 100,
            child: IconButton(
              icon: Icon(
                Icons.add_photo_alternate,
                size: 64,
                color: Colors.grey,
              ),
              onPressed: () {
                pickImageFromGallery(ImageSource.gallery);
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<AccountBloc>(context);
    if (!firstLoad) {
      bloc.add(GetAccount(email: widget.email, password: widget.password));
      firstLoad = true;
    }
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is InsertLoaded) {
          if (state.accountInsert.status == 1) {
            Navigator.pop(context);
          }
          Flushbar(
            message: state.accountInsert.message,
            duration: Duration(seconds: 5),
            margin: EdgeInsets.all(8),
            borderRadius: 8,
          )..show(context);
        } else if (state is AccountLoaded) {
          textFullNameController.text = state.account.name;
          textCompanyController.text = state.account.perusahaan;
          textProvinsiController.text = state.account.provinsi;
          textKotaController.text = state.account.kota;

          imageFile = _downloadFile(
            "http://119.235.16.190/wbbmapi/uploads/${state.account.image}",
            state.account.image +
                DateTime.now().millisecondsSinceEpoch.toString() +
                ".png",
          );
        } else if (state is UpdateLoaded) {
          if (state.accountUpdate.status == 1) {
            Navigator.pop(context);
          }
          Flushbar(
            message: state.accountUpdate.message,
            duration: Duration(seconds: 5),
            margin: EdgeInsets.all(8),
            borderRadius: 8,
          )..show(context);
        }
      },
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return Center(
              child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _textFieldWidget(
                    context, textFullNameController, "Nama Anda", false),
                _textFieldWidget(context, textCompanyController,
                    "Instansi / Perusahaan", false),
                _textFieldWidget(
                    context, textProvinsiController, "Provinsi", false),
                _textFieldWidget(
                    context, textKotaController, "Kota/Kabupaten", false),
                Container(
                  margin: EdgeInsets.only(top: 24),
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Foto"),
                      showImage(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 24,
                    left: 24,
                    right: 24,
                  ),
                  child: SizedBox(
                    width: 280,
                    child: FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          bloc.add(
                            UpdateAccount(
                              email: widget.email,
                              name: textFullNameController.text,
                              perusahaan: textCompanyController.text,
                              provinsi: textProvinsiController.text,
                              kota: textKotaController.text,
                              image: image,
                              imageUpdate: imageUpdate,
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Update Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _textFieldWidget(BuildContext context, TextEditingController controller,
      String hint, bool obsecure) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
      child: TextFormField(
        obscureText: obsecure,
        controller: controller,
        decoration: InputDecoration(hintText: hint),
        validator: (value) {
          if (value.isEmpty) {
            return '$hint wajib diisi';
          }
          return null;
        },
      ),
    );
  }
}
