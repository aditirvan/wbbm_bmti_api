import 'package:equatable/equatable.dart';
import 'package:wbbm_bmti/Model/Account.dart';

abstract class AccountState extends Equatable {
  const AccountState();
}

class AccountLoading extends AccountState {
  const AccountLoading();

  @override
  List<Object> get props => [];
}

class AccountLoaded extends AccountState {
  final Account account;
  const AccountLoaded(this.account);

  @override
  List<Object> get props => [account];
}

class LoginLoaded extends AccountState {
  final AccountLogin accountLogin;
  const LoginLoaded(this.accountLogin);

  @override
  List<Object> get props => [accountLogin];
}

class InsertLoaded extends AccountState {
  final AccountInsert accountInsert;
  const InsertLoaded(this.accountInsert);

  @override
  List<Object> get props => [accountInsert];
}

class UpdateLoaded extends AccountState {
  final AccountUpdate accountUpdate;
  const UpdateLoaded(this.accountUpdate);

  @override
  List<Object> get props => [accountUpdate];
}

class PasswordLoaded extends AccountState {
  final PasswordUpdate passwordUpdate;
  const PasswordLoaded(this.passwordUpdate);

  @override
  List<Object> get props => [passwordUpdate];
}
