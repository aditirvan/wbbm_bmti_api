import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String email;
  final String name;
  final String perusahaan;
  final String provinsi;
  final String kota;
  final String image;
  final String tanggalRegistrasi;

  Account(
      {this.email,
      this.name,
      this.perusahaan,
      this.provinsi,
      this.kota,
      this.image,
      this.tanggalRegistrasi});

  @override
  List<Object> get props => [
        email,
        name,
        perusahaan,
        provinsi,
        kota,
        image,
        tanggalRegistrasi,
      ];
}

class AccountLogin extends Equatable {
  final int status;
  final String message;
  AccountLogin({
    this.status,
    this.message,
  });

  @override
  List<Object> get props => [
        status,
        message,
      ];
}

class AccountInsert extends Equatable {
  final int status;
  final String message;
  AccountInsert({
    this.status,
    this.message,
  });

  @override
  List<Object> get props => [
        status,
        message,
      ];
}

class AccountUpdate extends Equatable {
  final int status;
  final String message;
  AccountUpdate({
    this.status,
    this.message,
  });

  @override
  List<Object> get props => [
        status,
        message,
      ];
}

class PasswordUpdate extends Equatable {
  final int status;
  final String message;
  PasswordUpdate({
    this.status,
    this.message,
  });

  @override
  List<Object> get props => [
        status,
        message,
      ];
}
