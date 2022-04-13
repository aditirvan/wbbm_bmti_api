import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();
}

class Login extends AccountEvent {
  final String email;
  final String password;
  const Login({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class GetAccount extends AccountEvent {
  final String email;
  final String password;
  const GetAccount({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class InsertAccount extends AccountEvent {
  final String email;
  final String password;
  final String name;
  final String perusahaan;
  final String provinsi;
  final String kota;
  final File image;

  InsertAccount(
      {this.email,
      this.password,
      this.name,
      this.perusahaan,
      this.provinsi,
      this.kota,
      this.image});

  @override
  List<Object> get props =>
      [email, password, name, perusahaan, provinsi, kota, image];
}

class UpdateAccount extends AccountEvent {
  final String email;
  final String name;
  final String perusahaan;
  final String provinsi;
  final String kota;
  final File image;
  final bool imageUpdate;

  UpdateAccount({
    @required this.email,
    @required this.name,
    @required this.perusahaan,
    @required this.provinsi,
    @required this.kota,
    @required this.image,
    @required this.imageUpdate,
  });

  @override
  List<Object> get props =>
      [email, name, perusahaan, provinsi, kota, image, imageUpdate];
}

class UpdatePassword extends AccountEvent {
  final String email;
  final String password;

  UpdatePassword({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
