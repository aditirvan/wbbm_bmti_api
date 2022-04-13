import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbbm_bmti/Event/Account.dart';
import 'package:wbbm_bmti/Repository/Account.dart';
import 'package:wbbm_bmti/State/Account.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository repository;
  AccountBloc(this.repository) : super(null);

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    try {
      if (event is Login) {
        yield AccountLoading();
        final data = await repository.login(event.email, event.password);
        yield LoginLoaded(data);
      } else if (event is GetAccount) {
        yield AccountLoading();
        final data = await repository.getAccount(event.email, event.password);
        yield AccountLoaded(data);
      } else if (event is InsertAccount) {
        yield AccountLoading();
        final data = await repository.insertAccount(
            event.email,
            event.password,
            event.name,
            event.perusahaan,
            event.provinsi,
            event.kota,
            event.image);
        yield InsertLoaded(data);
      } else if (event is UpdateAccount) {
        yield AccountLoading();
        final data = await repository.updateAccount(
            event.email,
            event.name,
            event.perusahaan,
            event.provinsi,
            event.kota,
            event.image,
            event.imageUpdate);
        yield UpdateLoaded(data);
      } else if (event is UpdatePassword) {
        yield AccountLoading();
        final data = await repository.updatePassword(
          event.email,
          event.password,
        );
        yield PasswordLoaded(data);
      }
    } catch (error) {
      print("Error: " + error.toString());
    }
  }
}
