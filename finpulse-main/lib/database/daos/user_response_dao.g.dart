// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response_dao.dart';

// ignore_for_file: type=lint
mixin _$UserResponseDaoMixin on DatabaseAccessor<AppDatabase> {
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $UserResponsesTable get userResponses => attachedDatabase.userResponses;
  UserResponseDaoManager get managers => UserResponseDaoManager(this);
}

class UserResponseDaoManager {
  final _$UserResponseDaoMixin _db;
  UserResponseDaoManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$UserResponsesTableTableManager get userResponses =>
      $$UserResponsesTableTableManager(_db.attachedDatabase, _db.userResponses);
}
