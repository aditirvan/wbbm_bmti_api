import 'dart:convert';
import 'dart:io';
import 'package:compressimage/compressimage.dart';
import 'package:http/http.dart' as http;

import 'package:wbbm_bmti/Model/Account.dart';

abstract class AccountRepository {
  Future<AccountLogin> login(String email, String password);
  Future<Account> getAccount(String email, String password);
  Future<AccountInsert> insertAccount(String email, String password,
      String name, String perusahaan, String provinsi, String kota, File image);
  Future<AccountUpdate> updateAccount(
      String email,
      String name,
      String perusahaan,
      String provinsi,
      String kota,
      File image,
      bool imageUpdate);
  Future<PasswordUpdate> updatePassword(String email, String password);
}

class FakeAccountRepository implements AccountRepository {
  @override
  Future<AccountLogin> login(String email, String password) {
    return Future.delayed(
      Duration(milliseconds: 1000),
      () async {
        String _url = "http://119.235.16.190/wbbmapi/index.php/account/login";

        print(_url);

        Map<String, dynamic> jsonData;
        try {
          var apiResult = await http.post(
            _url,
            body: {"email": email.toString(), "password": password},
          );
          print("statusCode: " + apiResult.statusCode.toString());
          print("result: " + apiResult.body);

          var jsonObject = json.decode(apiResult.body);
          jsonData = (jsonObject as Map<String, dynamic>);
        } catch (_) {
          print("Error redeemPoint: " + _.toString());
        }

        return AccountLogin(
          status: int.parse(jsonData["status"].toString()),
          message: jsonData["message"],
        );
      },
    );
  }

  @override
  Future<Account> getAccount(String email, String password) {
    return Future.delayed(
      Duration(milliseconds: 1000),
      () async {
        String _url = "http://119.235.16.190/wbbmapi/index.php/account";

        print(_url);

        Map<String, dynamic> jsonData;
        try {
          var apiResult = await http.post(
            _url,
            body: {"email": email.toString(), "password": password},
          );
          print("statusCode: " + apiResult.statusCode.toString());
          print("result: " + apiResult.body);

          var jsonObject = json.decode(apiResult.body);
          jsonData = (jsonObject as Map<String, dynamic>);
        } catch (_) {
          print("Error redeemPoint: " + _.toString());
        }

        return Account(
          email: jsonData["email"],
          name: jsonData["name"],
          perusahaan: jsonData["perusahaan"],
          provinsi: jsonData["provinsi"],
          kota: jsonData["kota"],
          image: jsonData["image"],
          tanggalRegistrasi: jsonData["tanggal_registrasi"],
        );
      },
    );
  }

  @override
  Future<AccountInsert> insertAccount(
      String email,
      String password,
      String name,
      String perusahaan,
      String provinsi,
      String kota,
      File image) async {
    return Future.delayed(
      Duration(milliseconds: 1000),
      () async {
        Uri _url = Uri.parse(
            "http://119.235.16.190/wbbmapi/index.php/account/register");

        await CompressImage.compress(imageSrc: image.path, desiredQuality: 30);

        var apiResult = http.MultipartRequest('POST', _url);
        apiResult.files
            .add(await http.MultipartFile.fromPath('image', image.path));
        apiResult.fields["email"] = email;
        apiResult.fields["password"] = password;
        apiResult.fields["name"] = name;
        apiResult.fields["provinsi"] = provinsi;
        apiResult.fields["kota"] = kota;
        apiResult.fields["perusahaan"] = perusahaan;
        http.StreamedResponse response = await apiResult.send();
        final res = await http.Response.fromStream(response);
        var jsonObject;
        print("result: " + res.body);
        try {
          jsonObject = json.decode(res.body);
        } catch (_) {
          jsonObject = json.decode('{"status":0,"message":"Update gagal"}');
        }

        var userData = (jsonObject as Map<String, dynamic>);

        return AccountInsert(
          status: int.parse(userData["status"].toString()),
          message: userData["message"],
        );
      },
    );
  }

  @override
  Future<AccountUpdate> updateAccount(
      String email,
      String name,
      String perusahaan,
      String provinsi,
      String kota,
      File image,
      bool imageUpdate) {
    return Future.delayed(
      Duration(milliseconds: 1000),
      () async {
        Uri _url =
            Uri.parse("http://119.235.16.190/wbbmapi/index.php/account/update");

        print("result: " + _url.toString());
        if (imageUpdate)
          await CompressImage.compress(
            imageSrc: image.path,
            desiredQuality: 30,
          );

        var apiResult = http.MultipartRequest('POST', _url);
        apiResult.files
            .add(await http.MultipartFile.fromPath('image', image.path));
        print("object: " + name);
        apiResult.fields["email"] = email;
        apiResult.fields["name"] = name;
        apiResult.fields["provinsi"] = provinsi;
        apiResult.fields["kota"] = kota;
        apiResult.fields["perusahaan"] = perusahaan;
        http.StreamedResponse response = await apiResult.send();
        final res = await http.Response.fromStream(response);

        print("result: " + res.body);
        var jsonObject = json.decode(res.body);
        var userData = (jsonObject as Map<String, dynamic>);

        return AccountUpdate(
          status: int.parse(userData["status"].toString()),
          message: userData["message"],
        );
      },
    );
  }

  @override
  Future<PasswordUpdate> updatePassword(String email, String password) {
    return Future.delayed(
      Duration(milliseconds: 1000),
      () async {
        String _url =
            "http://119.235.16.190/wbbmapi/index.php/account/password";

        print(_url);

        Map<String, dynamic> jsonData;
        try {
          var apiResult = await http.post(
            _url,
            body: {"email": email.toString(), "password": password},
          );
          print("statusCode: " + apiResult.statusCode.toString());
          print("result: " + apiResult.body);

          var jsonObject = json.decode(apiResult.body);
          jsonData = (jsonObject as Map<String, dynamic>);
        } catch (_) {
          print("Error redeemPoint: " + _.toString());
        }

        return PasswordUpdate(
          status: int.parse(jsonData["status"].toString()),
          message: jsonData["message"],
        );
      },
    );
  }
}
