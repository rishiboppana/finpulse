// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_intelligence_dao.dart';

// ignore_for_file: type=lint
mixin _$MerchantIntelligenceDaoMixin on DatabaseAccessor<AppDatabase> {
  $MerchantIntelligenceTable get merchantIntelligence =>
      attachedDatabase.merchantIntelligence;
  MerchantIntelligenceDaoManager get managers =>
      MerchantIntelligenceDaoManager(this);
}

class MerchantIntelligenceDaoManager {
  final _$MerchantIntelligenceDaoMixin _db;
  MerchantIntelligenceDaoManager(this._db);
  $$MerchantIntelligenceTableTableManager get merchantIntelligence =>
      $$MerchantIntelligenceTableTableManager(
        _db.attachedDatabase,
        _db.merchantIntelligence,
      );
}
