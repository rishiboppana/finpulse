// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detectedAtMeta = const VerificationMeta(
    'detectedAt',
  );
  @override
  late final GeneratedColumn<int> detectedAt = GeneratedColumn<int>(
    'detected_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawDateMeta = const VerificationMeta(
    'rawDate',
  );
  @override
  late final GeneratedColumn<String> rawDate = GeneratedColumn<String>(
    'raw_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawTimeMeta = const VerificationMeta(
    'rawTime',
  );
  @override
  late final GeneratedColumn<String> rawTime = GeneratedColumn<String>(
    'raw_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawTextMeta = const VerificationMeta(
    'rawText',
  );
  @override
  late final GeneratedColumn<String> rawText = GeneratedColumn<String>(
    'raw_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountLastDigitsMeta = const VerificationMeta(
    'accountLastDigits',
  );
  @override
  late final GeneratedColumn<String> accountLastDigits =
      GeneratedColumn<String>(
        'account_last_digits',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _rawMerchantIdMeta = const VerificationMeta(
    'rawMerchantId',
  );
  @override
  late final GeneratedColumn<String> rawMerchantId = GeneratedColumn<String>(
    'raw_merchant_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _normalizedMerchantIdMeta =
      const VerificationMeta('normalizedMerchantId');
  @override
  late final GeneratedColumn<String> normalizedMerchantId =
      GeneratedColumn<String>(
        'normalized_merchant_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _merchantNameMeta = const VerificationMeta(
    'merchantName',
  );
  @override
  late final GeneratedColumn<String> merchantName = GeneratedColumn<String>(
    'merchant_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCustomCategoryMeta = const VerificationMeta(
    'isCustomCategory',
  );
  @override
  late final GeneratedColumn<bool> isCustomCategory = GeneratedColumn<bool>(
    'is_custom_category',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom_category" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _subcategoryMeta = const VerificationMeta(
    'subcategory',
  );
  @override
  late final GeneratedColumn<String> subcategory = GeneratedColumn<String>(
    'subcategory',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCategorizedMeta = const VerificationMeta(
    'isCategorized',
  );
  @override
  late final GeneratedColumn<bool> isCategorized = GeneratedColumn<bool>(
    'is_categorized',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_categorized" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isParsedByAiMeta = const VerificationMeta(
    'isParsedByAi',
  );
  @override
  late final GeneratedColumn<bool> isParsedByAi = GeneratedColumn<bool>(
    'is_parsed_by_ai',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_parsed_by_ai" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fingerprint,
    amount,
    currency,
    timestamp,
    detectedAt,
    rawDate,
    rawTime,
    source,
    rawText,
    accountId,
    accountLastDigits,
    rawMerchantId,
    normalizedMerchantId,
    merchantName,
    category,
    isCustomCategory,
    subcategory,
    type,
    isCategorized,
    isParsedByAi,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('detected_at')) {
      context.handle(
        _detectedAtMeta,
        detectedAt.isAcceptableOrUnknown(data['detected_at']!, _detectedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_detectedAtMeta);
    }
    if (data.containsKey('raw_date')) {
      context.handle(
        _rawDateMeta,
        rawDate.isAcceptableOrUnknown(data['raw_date']!, _rawDateMeta),
      );
    }
    if (data.containsKey('raw_time')) {
      context.handle(
        _rawTimeMeta,
        rawTime.isAcceptableOrUnknown(data['raw_time']!, _rawTimeMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('raw_text')) {
      context.handle(
        _rawTextMeta,
        rawText.isAcceptableOrUnknown(data['raw_text']!, _rawTextMeta),
      );
    } else if (isInserting) {
      context.missing(_rawTextMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('account_last_digits')) {
      context.handle(
        _accountLastDigitsMeta,
        accountLastDigits.isAcceptableOrUnknown(
          data['account_last_digits']!,
          _accountLastDigitsMeta,
        ),
      );
    }
    if (data.containsKey('raw_merchant_id')) {
      context.handle(
        _rawMerchantIdMeta,
        rawMerchantId.isAcceptableOrUnknown(
          data['raw_merchant_id']!,
          _rawMerchantIdMeta,
        ),
      );
    }
    if (data.containsKey('normalized_merchant_id')) {
      context.handle(
        _normalizedMerchantIdMeta,
        normalizedMerchantId.isAcceptableOrUnknown(
          data['normalized_merchant_id']!,
          _normalizedMerchantIdMeta,
        ),
      );
    }
    if (data.containsKey('merchant_name')) {
      context.handle(
        _merchantNameMeta,
        merchantName.isAcceptableOrUnknown(
          data['merchant_name']!,
          _merchantNameMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('is_custom_category')) {
      context.handle(
        _isCustomCategoryMeta,
        isCustomCategory.isAcceptableOrUnknown(
          data['is_custom_category']!,
          _isCustomCategoryMeta,
        ),
      );
    }
    if (data.containsKey('subcategory')) {
      context.handle(
        _subcategoryMeta,
        subcategory.isAcceptableOrUnknown(
          data['subcategory']!,
          _subcategoryMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('is_categorized')) {
      context.handle(
        _isCategorizedMeta,
        isCategorized.isAcceptableOrUnknown(
          data['is_categorized']!,
          _isCategorizedMeta,
        ),
      );
    }
    if (data.containsKey('is_parsed_by_ai')) {
      context.handle(
        _isParsedByAiMeta,
        isParsedByAi.isAcceptableOrUnknown(
          data['is_parsed_by_ai']!,
          _isParsedByAiMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      detectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}detected_at'],
      )!,
      rawDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_date'],
      ),
      rawTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_time'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      rawText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_text'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      accountLastDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_last_digits'],
      ),
      rawMerchantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_merchant_id'],
      ),
      normalizedMerchantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_merchant_id'],
      ),
      merchantName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_name'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      isCustomCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom_category'],
      )!,
      subcategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subcategory'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      isCategorized: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_categorized'],
      )!,
      isParsedByAi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_parsed_by_ai'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String? fingerprint;
  final double amount;
  final String currency;
  final int timestamp;
  final int detectedAt;
  final String? rawDate;
  final String? rawTime;
  final String source;
  final String rawText;
  final String? accountId;
  final String? accountLastDigits;
  final String? rawMerchantId;
  final String? normalizedMerchantId;
  final String? merchantName;
  final String? category;
  final bool isCustomCategory;
  final String? subcategory;
  final String type;
  final bool isCategorized;
  final bool isParsedByAi;
  final int createdAt;
  final int updatedAt;
  const Transaction({
    required this.id,
    this.fingerprint,
    required this.amount,
    required this.currency,
    required this.timestamp,
    required this.detectedAt,
    this.rawDate,
    this.rawTime,
    required this.source,
    required this.rawText,
    this.accountId,
    this.accountLastDigits,
    this.rawMerchantId,
    this.normalizedMerchantId,
    this.merchantName,
    this.category,
    required this.isCustomCategory,
    this.subcategory,
    required this.type,
    required this.isCategorized,
    required this.isParsedByAi,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || fingerprint != null) {
      map['fingerprint'] = Variable<String>(fingerprint);
    }
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['timestamp'] = Variable<int>(timestamp);
    map['detected_at'] = Variable<int>(detectedAt);
    if (!nullToAbsent || rawDate != null) {
      map['raw_date'] = Variable<String>(rawDate);
    }
    if (!nullToAbsent || rawTime != null) {
      map['raw_time'] = Variable<String>(rawTime);
    }
    map['source'] = Variable<String>(source);
    map['raw_text'] = Variable<String>(rawText);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || accountLastDigits != null) {
      map['account_last_digits'] = Variable<String>(accountLastDigits);
    }
    if (!nullToAbsent || rawMerchantId != null) {
      map['raw_merchant_id'] = Variable<String>(rawMerchantId);
    }
    if (!nullToAbsent || normalizedMerchantId != null) {
      map['normalized_merchant_id'] = Variable<String>(normalizedMerchantId);
    }
    if (!nullToAbsent || merchantName != null) {
      map['merchant_name'] = Variable<String>(merchantName);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['is_custom_category'] = Variable<bool>(isCustomCategory);
    if (!nullToAbsent || subcategory != null) {
      map['subcategory'] = Variable<String>(subcategory);
    }
    map['type'] = Variable<String>(type);
    map['is_categorized'] = Variable<bool>(isCategorized);
    map['is_parsed_by_ai'] = Variable<bool>(isParsedByAi);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      fingerprint: fingerprint == null && nullToAbsent
          ? const Value.absent()
          : Value(fingerprint),
      amount: Value(amount),
      currency: Value(currency),
      timestamp: Value(timestamp),
      detectedAt: Value(detectedAt),
      rawDate: rawDate == null && nullToAbsent
          ? const Value.absent()
          : Value(rawDate),
      rawTime: rawTime == null && nullToAbsent
          ? const Value.absent()
          : Value(rawTime),
      source: Value(source),
      rawText: Value(rawText),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      accountLastDigits: accountLastDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(accountLastDigits),
      rawMerchantId: rawMerchantId == null && nullToAbsent
          ? const Value.absent()
          : Value(rawMerchantId),
      normalizedMerchantId: normalizedMerchantId == null && nullToAbsent
          ? const Value.absent()
          : Value(normalizedMerchantId),
      merchantName: merchantName == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantName),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      isCustomCategory: Value(isCustomCategory),
      subcategory: subcategory == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategory),
      type: Value(type),
      isCategorized: Value(isCategorized),
      isParsedByAi: Value(isParsedByAi),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      fingerprint: serializer.fromJson<String?>(json['fingerprint']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      detectedAt: serializer.fromJson<int>(json['detectedAt']),
      rawDate: serializer.fromJson<String?>(json['rawDate']),
      rawTime: serializer.fromJson<String?>(json['rawTime']),
      source: serializer.fromJson<String>(json['source']),
      rawText: serializer.fromJson<String>(json['rawText']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      accountLastDigits: serializer.fromJson<String?>(
        json['accountLastDigits'],
      ),
      rawMerchantId: serializer.fromJson<String?>(json['rawMerchantId']),
      normalizedMerchantId: serializer.fromJson<String?>(
        json['normalizedMerchantId'],
      ),
      merchantName: serializer.fromJson<String?>(json['merchantName']),
      category: serializer.fromJson<String?>(json['category']),
      isCustomCategory: serializer.fromJson<bool>(json['isCustomCategory']),
      subcategory: serializer.fromJson<String?>(json['subcategory']),
      type: serializer.fromJson<String>(json['type']),
      isCategorized: serializer.fromJson<bool>(json['isCategorized']),
      isParsedByAi: serializer.fromJson<bool>(json['isParsedByAi']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fingerprint': serializer.toJson<String?>(fingerprint),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'timestamp': serializer.toJson<int>(timestamp),
      'detectedAt': serializer.toJson<int>(detectedAt),
      'rawDate': serializer.toJson<String?>(rawDate),
      'rawTime': serializer.toJson<String?>(rawTime),
      'source': serializer.toJson<String>(source),
      'rawText': serializer.toJson<String>(rawText),
      'accountId': serializer.toJson<String?>(accountId),
      'accountLastDigits': serializer.toJson<String?>(accountLastDigits),
      'rawMerchantId': serializer.toJson<String?>(rawMerchantId),
      'normalizedMerchantId': serializer.toJson<String?>(normalizedMerchantId),
      'merchantName': serializer.toJson<String?>(merchantName),
      'category': serializer.toJson<String?>(category),
      'isCustomCategory': serializer.toJson<bool>(isCustomCategory),
      'subcategory': serializer.toJson<String?>(subcategory),
      'type': serializer.toJson<String>(type),
      'isCategorized': serializer.toJson<bool>(isCategorized),
      'isParsedByAi': serializer.toJson<bool>(isParsedByAi),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Transaction copyWith({
    String? id,
    Value<String?> fingerprint = const Value.absent(),
    double? amount,
    String? currency,
    int? timestamp,
    int? detectedAt,
    Value<String?> rawDate = const Value.absent(),
    Value<String?> rawTime = const Value.absent(),
    String? source,
    String? rawText,
    Value<String?> accountId = const Value.absent(),
    Value<String?> accountLastDigits = const Value.absent(),
    Value<String?> rawMerchantId = const Value.absent(),
    Value<String?> normalizedMerchantId = const Value.absent(),
    Value<String?> merchantName = const Value.absent(),
    Value<String?> category = const Value.absent(),
    bool? isCustomCategory,
    Value<String?> subcategory = const Value.absent(),
    String? type,
    bool? isCategorized,
    bool? isParsedByAi,
    int? createdAt,
    int? updatedAt,
  }) => Transaction(
    id: id ?? this.id,
    fingerprint: fingerprint.present ? fingerprint.value : this.fingerprint,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    timestamp: timestamp ?? this.timestamp,
    detectedAt: detectedAt ?? this.detectedAt,
    rawDate: rawDate.present ? rawDate.value : this.rawDate,
    rawTime: rawTime.present ? rawTime.value : this.rawTime,
    source: source ?? this.source,
    rawText: rawText ?? this.rawText,
    accountId: accountId.present ? accountId.value : this.accountId,
    accountLastDigits: accountLastDigits.present
        ? accountLastDigits.value
        : this.accountLastDigits,
    rawMerchantId: rawMerchantId.present
        ? rawMerchantId.value
        : this.rawMerchantId,
    normalizedMerchantId: normalizedMerchantId.present
        ? normalizedMerchantId.value
        : this.normalizedMerchantId,
    merchantName: merchantName.present ? merchantName.value : this.merchantName,
    category: category.present ? category.value : this.category,
    isCustomCategory: isCustomCategory ?? this.isCustomCategory,
    subcategory: subcategory.present ? subcategory.value : this.subcategory,
    type: type ?? this.type,
    isCategorized: isCategorized ?? this.isCategorized,
    isParsedByAi: isParsedByAi ?? this.isParsedByAi,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      detectedAt: data.detectedAt.present
          ? data.detectedAt.value
          : this.detectedAt,
      rawDate: data.rawDate.present ? data.rawDate.value : this.rawDate,
      rawTime: data.rawTime.present ? data.rawTime.value : this.rawTime,
      source: data.source.present ? data.source.value : this.source,
      rawText: data.rawText.present ? data.rawText.value : this.rawText,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      accountLastDigits: data.accountLastDigits.present
          ? data.accountLastDigits.value
          : this.accountLastDigits,
      rawMerchantId: data.rawMerchantId.present
          ? data.rawMerchantId.value
          : this.rawMerchantId,
      normalizedMerchantId: data.normalizedMerchantId.present
          ? data.normalizedMerchantId.value
          : this.normalizedMerchantId,
      merchantName: data.merchantName.present
          ? data.merchantName.value
          : this.merchantName,
      category: data.category.present ? data.category.value : this.category,
      isCustomCategory: data.isCustomCategory.present
          ? data.isCustomCategory.value
          : this.isCustomCategory,
      subcategory: data.subcategory.present
          ? data.subcategory.value
          : this.subcategory,
      type: data.type.present ? data.type.value : this.type,
      isCategorized: data.isCategorized.present
          ? data.isCategorized.value
          : this.isCategorized,
      isParsedByAi: data.isParsedByAi.present
          ? data.isParsedByAi.value
          : this.isParsedByAi,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('timestamp: $timestamp, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('rawDate: $rawDate, ')
          ..write('rawTime: $rawTime, ')
          ..write('source: $source, ')
          ..write('rawText: $rawText, ')
          ..write('accountId: $accountId, ')
          ..write('accountLastDigits: $accountLastDigits, ')
          ..write('rawMerchantId: $rawMerchantId, ')
          ..write('normalizedMerchantId: $normalizedMerchantId, ')
          ..write('merchantName: $merchantName, ')
          ..write('category: $category, ')
          ..write('isCustomCategory: $isCustomCategory, ')
          ..write('subcategory: $subcategory, ')
          ..write('type: $type, ')
          ..write('isCategorized: $isCategorized, ')
          ..write('isParsedByAi: $isParsedByAi, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    fingerprint,
    amount,
    currency,
    timestamp,
    detectedAt,
    rawDate,
    rawTime,
    source,
    rawText,
    accountId,
    accountLastDigits,
    rawMerchantId,
    normalizedMerchantId,
    merchantName,
    category,
    isCustomCategory,
    subcategory,
    type,
    isCategorized,
    isParsedByAi,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.fingerprint == this.fingerprint &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.timestamp == this.timestamp &&
          other.detectedAt == this.detectedAt &&
          other.rawDate == this.rawDate &&
          other.rawTime == this.rawTime &&
          other.source == this.source &&
          other.rawText == this.rawText &&
          other.accountId == this.accountId &&
          other.accountLastDigits == this.accountLastDigits &&
          other.rawMerchantId == this.rawMerchantId &&
          other.normalizedMerchantId == this.normalizedMerchantId &&
          other.merchantName == this.merchantName &&
          other.category == this.category &&
          other.isCustomCategory == this.isCustomCategory &&
          other.subcategory == this.subcategory &&
          other.type == this.type &&
          other.isCategorized == this.isCategorized &&
          other.isParsedByAi == this.isParsedByAi &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String?> fingerprint;
  final Value<double> amount;
  final Value<String> currency;
  final Value<int> timestamp;
  final Value<int> detectedAt;
  final Value<String?> rawDate;
  final Value<String?> rawTime;
  final Value<String> source;
  final Value<String> rawText;
  final Value<String?> accountId;
  final Value<String?> accountLastDigits;
  final Value<String?> rawMerchantId;
  final Value<String?> normalizedMerchantId;
  final Value<String?> merchantName;
  final Value<String?> category;
  final Value<bool> isCustomCategory;
  final Value<String?> subcategory;
  final Value<String> type;
  final Value<bool> isCategorized;
  final Value<bool> isParsedByAi;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.rawDate = const Value.absent(),
    this.rawTime = const Value.absent(),
    this.source = const Value.absent(),
    this.rawText = const Value.absent(),
    this.accountId = const Value.absent(),
    this.accountLastDigits = const Value.absent(),
    this.rawMerchantId = const Value.absent(),
    this.normalizedMerchantId = const Value.absent(),
    this.merchantName = const Value.absent(),
    this.category = const Value.absent(),
    this.isCustomCategory = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.type = const Value.absent(),
    this.isCategorized = const Value.absent(),
    this.isParsedByAi = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    this.fingerprint = const Value.absent(),
    required double amount,
    this.currency = const Value.absent(),
    required int timestamp,
    required int detectedAt,
    this.rawDate = const Value.absent(),
    this.rawTime = const Value.absent(),
    required String source,
    required String rawText,
    this.accountId = const Value.absent(),
    this.accountLastDigits = const Value.absent(),
    this.rawMerchantId = const Value.absent(),
    this.normalizedMerchantId = const Value.absent(),
    this.merchantName = const Value.absent(),
    this.category = const Value.absent(),
    this.isCustomCategory = const Value.absent(),
    this.subcategory = const Value.absent(),
    required String type,
    this.isCategorized = const Value.absent(),
    this.isParsedByAi = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       timestamp = Value(timestamp),
       detectedAt = Value(detectedAt),
       source = Value(source),
       rawText = Value(rawText),
       type = Value(type),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? fingerprint,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<int>? timestamp,
    Expression<int>? detectedAt,
    Expression<String>? rawDate,
    Expression<String>? rawTime,
    Expression<String>? source,
    Expression<String>? rawText,
    Expression<String>? accountId,
    Expression<String>? accountLastDigits,
    Expression<String>? rawMerchantId,
    Expression<String>? normalizedMerchantId,
    Expression<String>? merchantName,
    Expression<String>? category,
    Expression<bool>? isCustomCategory,
    Expression<String>? subcategory,
    Expression<String>? type,
    Expression<bool>? isCategorized,
    Expression<bool>? isParsedByAi,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (timestamp != null) 'timestamp': timestamp,
      if (detectedAt != null) 'detected_at': detectedAt,
      if (rawDate != null) 'raw_date': rawDate,
      if (rawTime != null) 'raw_time': rawTime,
      if (source != null) 'source': source,
      if (rawText != null) 'raw_text': rawText,
      if (accountId != null) 'account_id': accountId,
      if (accountLastDigits != null) 'account_last_digits': accountLastDigits,
      if (rawMerchantId != null) 'raw_merchant_id': rawMerchantId,
      if (normalizedMerchantId != null)
        'normalized_merchant_id': normalizedMerchantId,
      if (merchantName != null) 'merchant_name': merchantName,
      if (category != null) 'category': category,
      if (isCustomCategory != null) 'is_custom_category': isCustomCategory,
      if (subcategory != null) 'subcategory': subcategory,
      if (type != null) 'type': type,
      if (isCategorized != null) 'is_categorized': isCategorized,
      if (isParsedByAi != null) 'is_parsed_by_ai': isParsedByAi,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? fingerprint,
    Value<double>? amount,
    Value<String>? currency,
    Value<int>? timestamp,
    Value<int>? detectedAt,
    Value<String?>? rawDate,
    Value<String?>? rawTime,
    Value<String>? source,
    Value<String>? rawText,
    Value<String?>? accountId,
    Value<String?>? accountLastDigits,
    Value<String?>? rawMerchantId,
    Value<String?>? normalizedMerchantId,
    Value<String?>? merchantName,
    Value<String?>? category,
    Value<bool>? isCustomCategory,
    Value<String?>? subcategory,
    Value<String>? type,
    Value<bool>? isCategorized,
    Value<bool>? isParsedByAi,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      fingerprint: fingerprint ?? this.fingerprint,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      timestamp: timestamp ?? this.timestamp,
      detectedAt: detectedAt ?? this.detectedAt,
      rawDate: rawDate ?? this.rawDate,
      rawTime: rawTime ?? this.rawTime,
      source: source ?? this.source,
      rawText: rawText ?? this.rawText,
      accountId: accountId ?? this.accountId,
      accountLastDigits: accountLastDigits ?? this.accountLastDigits,
      rawMerchantId: rawMerchantId ?? this.rawMerchantId,
      normalizedMerchantId: normalizedMerchantId ?? this.normalizedMerchantId,
      merchantName: merchantName ?? this.merchantName,
      category: category ?? this.category,
      isCustomCategory: isCustomCategory ?? this.isCustomCategory,
      subcategory: subcategory ?? this.subcategory,
      type: type ?? this.type,
      isCategorized: isCategorized ?? this.isCategorized,
      isParsedByAi: isParsedByAi ?? this.isParsedByAi,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<int>(detectedAt.value);
    }
    if (rawDate.present) {
      map['raw_date'] = Variable<String>(rawDate.value);
    }
    if (rawTime.present) {
      map['raw_time'] = Variable<String>(rawTime.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rawText.present) {
      map['raw_text'] = Variable<String>(rawText.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (accountLastDigits.present) {
      map['account_last_digits'] = Variable<String>(accountLastDigits.value);
    }
    if (rawMerchantId.present) {
      map['raw_merchant_id'] = Variable<String>(rawMerchantId.value);
    }
    if (normalizedMerchantId.present) {
      map['normalized_merchant_id'] = Variable<String>(
        normalizedMerchantId.value,
      );
    }
    if (merchantName.present) {
      map['merchant_name'] = Variable<String>(merchantName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isCustomCategory.present) {
      map['is_custom_category'] = Variable<bool>(isCustomCategory.value);
    }
    if (subcategory.present) {
      map['subcategory'] = Variable<String>(subcategory.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isCategorized.present) {
      map['is_categorized'] = Variable<bool>(isCategorized.value);
    }
    if (isParsedByAi.present) {
      map['is_parsed_by_ai'] = Variable<bool>(isParsedByAi.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('timestamp: $timestamp, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('rawDate: $rawDate, ')
          ..write('rawTime: $rawTime, ')
          ..write('source: $source, ')
          ..write('rawText: $rawText, ')
          ..write('accountId: $accountId, ')
          ..write('accountLastDigits: $accountLastDigits, ')
          ..write('rawMerchantId: $rawMerchantId, ')
          ..write('normalizedMerchantId: $normalizedMerchantId, ')
          ..write('merchantName: $merchantName, ')
          ..write('category: $category, ')
          ..write('isCustomCategory: $isCustomCategory, ')
          ..write('subcategory: $subcategory, ')
          ..write('type: $type, ')
          ..write('isCategorized: $isCategorized, ')
          ..write('isParsedByAi: $isParsedByAi, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserResponsesTable extends UserResponses
    with TableInfo<$UserResponsesTable, UserResponse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserResponsesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _aiSuggestionsMeta = const VerificationMeta(
    'aiSuggestions',
  );
  @override
  late final GeneratedColumn<String> aiSuggestions = GeneratedColumn<String>(
    'ai_suggestions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inputMethodMeta = const VerificationMeta(
    'inputMethod',
  );
  @override
  late final GeneratedColumn<String> inputMethod = GeneratedColumn<String>(
    'input_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawInputMeta = const VerificationMeta(
    'rawInput',
  );
  @override
  late final GeneratedColumn<String> rawInput = GeneratedColumn<String>(
    'raw_input',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voiceTranscriptMeta = const VerificationMeta(
    'voiceTranscript',
  );
  @override
  late final GeneratedColumn<String> voiceTranscript = GeneratedColumn<String>(
    'voice_transcript',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voiceConfidenceMeta = const VerificationMeta(
    'voiceConfidence',
  );
  @override
  late final GeneratedColumn<double> voiceConfidence = GeneratedColumn<double>(
    'voice_confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _geminiInterpretationMeta =
      const VerificationMeta('geminiInterpretation');
  @override
  late final GeneratedColumn<String> geminiInterpretation =
      GeneratedColumn<String>(
        'gemini_interpretation',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _geminiCategoryMeta = const VerificationMeta(
    'geminiCategory',
  );
  @override
  late final GeneratedColumn<String> geminiCategory = GeneratedColumn<String>(
    'gemini_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _geminiSubcategoryMeta = const VerificationMeta(
    'geminiSubcategory',
  );
  @override
  late final GeneratedColumn<String> geminiSubcategory =
      GeneratedColumn<String>(
        'gemini_subcategory',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _geminiConfidenceMeta = const VerificationMeta(
    'geminiConfidence',
  );
  @override
  late final GeneratedColumn<double> geminiConfidence = GeneratedColumn<double>(
    'gemini_confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _geminiReasoningMeta = const VerificationMeta(
    'geminiReasoning',
  );
  @override
  late final GeneratedColumn<String> geminiReasoning = GeneratedColumn<String>(
    'gemini_reasoning',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finalCategoryMeta = const VerificationMeta(
    'finalCategory',
  );
  @override
  late final GeneratedColumn<String> finalCategory = GeneratedColumn<String>(
    'final_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomCategoryMeta = const VerificationMeta(
    'isCustomCategory',
  );
  @override
  late final GeneratedColumn<bool> isCustomCategory = GeneratedColumn<bool>(
    'is_custom_category',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom_category" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _userConfirmedMeta = const VerificationMeta(
    'userConfirmed',
  );
  @override
  late final GeneratedColumn<bool> userConfirmed = GeneratedColumn<bool>(
    'user_confirmed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("user_confirmed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _userCorrectionMeta = const VerificationMeta(
    'userCorrection',
  );
  @override
  late final GeneratedColumn<String> userCorrection = GeneratedColumn<String>(
    'user_correction',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _merchantAtTimeMeta = const VerificationMeta(
    'merchantAtTime',
  );
  @override
  late final GeneratedColumn<String> merchantAtTime = GeneratedColumn<String>(
    'merchant_at_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountAtTimeMeta = const VerificationMeta(
    'amountAtTime',
  );
  @override
  late final GeneratedColumn<double> amountAtTime = GeneratedColumn<double>(
    'amount_at_time',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _responseTimeMsMeta = const VerificationMeta(
    'responseTimeMs',
  );
  @override
  late final GeneratedColumn<int> responseTimeMs = GeneratedColumn<int>(
    'response_time_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _interpretedAtMeta = const VerificationMeta(
    'interpretedAt',
  );
  @override
  late final GeneratedColumn<int> interpretedAt = GeneratedColumn<int>(
    'interpreted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confirmedAtMeta = const VerificationMeta(
    'confirmedAt',
  );
  @override
  late final GeneratedColumn<int> confirmedAt = GeneratedColumn<int>(
    'confirmed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    aiSuggestions,
    inputMethod,
    rawInput,
    voiceTranscript,
    voiceConfidence,
    geminiInterpretation,
    geminiCategory,
    geminiSubcategory,
    geminiConfidence,
    geminiReasoning,
    finalCategory,
    isCustomCategory,
    userConfirmed,
    userCorrection,
    merchantAtTime,
    amountAtTime,
    responseTimeMs,
    interpretedAt,
    confirmedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_responses';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserResponse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('ai_suggestions')) {
      context.handle(
        _aiSuggestionsMeta,
        aiSuggestions.isAcceptableOrUnknown(
          data['ai_suggestions']!,
          _aiSuggestionsMeta,
        ),
      );
    }
    if (data.containsKey('input_method')) {
      context.handle(
        _inputMethodMeta,
        inputMethod.isAcceptableOrUnknown(
          data['input_method']!,
          _inputMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inputMethodMeta);
    }
    if (data.containsKey('raw_input')) {
      context.handle(
        _rawInputMeta,
        rawInput.isAcceptableOrUnknown(data['raw_input']!, _rawInputMeta),
      );
    }
    if (data.containsKey('voice_transcript')) {
      context.handle(
        _voiceTranscriptMeta,
        voiceTranscript.isAcceptableOrUnknown(
          data['voice_transcript']!,
          _voiceTranscriptMeta,
        ),
      );
    }
    if (data.containsKey('voice_confidence')) {
      context.handle(
        _voiceConfidenceMeta,
        voiceConfidence.isAcceptableOrUnknown(
          data['voice_confidence']!,
          _voiceConfidenceMeta,
        ),
      );
    }
    if (data.containsKey('gemini_interpretation')) {
      context.handle(
        _geminiInterpretationMeta,
        geminiInterpretation.isAcceptableOrUnknown(
          data['gemini_interpretation']!,
          _geminiInterpretationMeta,
        ),
      );
    }
    if (data.containsKey('gemini_category')) {
      context.handle(
        _geminiCategoryMeta,
        geminiCategory.isAcceptableOrUnknown(
          data['gemini_category']!,
          _geminiCategoryMeta,
        ),
      );
    }
    if (data.containsKey('gemini_subcategory')) {
      context.handle(
        _geminiSubcategoryMeta,
        geminiSubcategory.isAcceptableOrUnknown(
          data['gemini_subcategory']!,
          _geminiSubcategoryMeta,
        ),
      );
    }
    if (data.containsKey('gemini_confidence')) {
      context.handle(
        _geminiConfidenceMeta,
        geminiConfidence.isAcceptableOrUnknown(
          data['gemini_confidence']!,
          _geminiConfidenceMeta,
        ),
      );
    }
    if (data.containsKey('gemini_reasoning')) {
      context.handle(
        _geminiReasoningMeta,
        geminiReasoning.isAcceptableOrUnknown(
          data['gemini_reasoning']!,
          _geminiReasoningMeta,
        ),
      );
    }
    if (data.containsKey('final_category')) {
      context.handle(
        _finalCategoryMeta,
        finalCategory.isAcceptableOrUnknown(
          data['final_category']!,
          _finalCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_finalCategoryMeta);
    }
    if (data.containsKey('is_custom_category')) {
      context.handle(
        _isCustomCategoryMeta,
        isCustomCategory.isAcceptableOrUnknown(
          data['is_custom_category']!,
          _isCustomCategoryMeta,
        ),
      );
    }
    if (data.containsKey('user_confirmed')) {
      context.handle(
        _userConfirmedMeta,
        userConfirmed.isAcceptableOrUnknown(
          data['user_confirmed']!,
          _userConfirmedMeta,
        ),
      );
    }
    if (data.containsKey('user_correction')) {
      context.handle(
        _userCorrectionMeta,
        userCorrection.isAcceptableOrUnknown(
          data['user_correction']!,
          _userCorrectionMeta,
        ),
      );
    }
    if (data.containsKey('merchant_at_time')) {
      context.handle(
        _merchantAtTimeMeta,
        merchantAtTime.isAcceptableOrUnknown(
          data['merchant_at_time']!,
          _merchantAtTimeMeta,
        ),
      );
    }
    if (data.containsKey('amount_at_time')) {
      context.handle(
        _amountAtTimeMeta,
        amountAtTime.isAcceptableOrUnknown(
          data['amount_at_time']!,
          _amountAtTimeMeta,
        ),
      );
    }
    if (data.containsKey('response_time_ms')) {
      context.handle(
        _responseTimeMsMeta,
        responseTimeMs.isAcceptableOrUnknown(
          data['response_time_ms']!,
          _responseTimeMsMeta,
        ),
      );
    }
    if (data.containsKey('interpreted_at')) {
      context.handle(
        _interpretedAtMeta,
        interpretedAt.isAcceptableOrUnknown(
          data['interpreted_at']!,
          _interpretedAtMeta,
        ),
      );
    }
    if (data.containsKey('confirmed_at')) {
      context.handle(
        _confirmedAtMeta,
        confirmedAt.isAcceptableOrUnknown(
          data['confirmed_at']!,
          _confirmedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserResponse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserResponse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      aiSuggestions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_suggestions'],
      ),
      inputMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}input_method'],
      )!,
      rawInput: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_input'],
      ),
      voiceTranscript: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voice_transcript'],
      ),
      voiceConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}voice_confidence'],
      ),
      geminiInterpretation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gemini_interpretation'],
      ),
      geminiCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gemini_category'],
      ),
      geminiSubcategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gemini_subcategory'],
      ),
      geminiConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gemini_confidence'],
      ),
      geminiReasoning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gemini_reasoning'],
      ),
      finalCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}final_category'],
      )!,
      isCustomCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom_category'],
      )!,
      userConfirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}user_confirmed'],
      )!,
      userCorrection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_correction'],
      ),
      merchantAtTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_at_time'],
      ),
      amountAtTime: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_at_time'],
      ),
      responseTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}response_time_ms'],
      ),
      interpretedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interpreted_at'],
      ),
      confirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}confirmed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserResponsesTable createAlias(String alias) {
    return $UserResponsesTable(attachedDatabase, alias);
  }
}

class UserResponse extends DataClass implements Insertable<UserResponse> {
  final int id;
  final String transactionId;
  final String? aiSuggestions;
  final String inputMethod;
  final String? rawInput;
  final String? voiceTranscript;
  final double? voiceConfidence;
  final String? geminiInterpretation;
  final String? geminiCategory;
  final String? geminiSubcategory;
  final double? geminiConfidence;
  final String? geminiReasoning;
  final String finalCategory;
  final bool isCustomCategory;
  final bool userConfirmed;
  final String? userCorrection;
  final String? merchantAtTime;
  final double? amountAtTime;
  final int? responseTimeMs;
  final int? interpretedAt;
  final int? confirmedAt;
  final int createdAt;
  const UserResponse({
    required this.id,
    required this.transactionId,
    this.aiSuggestions,
    required this.inputMethod,
    this.rawInput,
    this.voiceTranscript,
    this.voiceConfidence,
    this.geminiInterpretation,
    this.geminiCategory,
    this.geminiSubcategory,
    this.geminiConfidence,
    this.geminiReasoning,
    required this.finalCategory,
    required this.isCustomCategory,
    required this.userConfirmed,
    this.userCorrection,
    this.merchantAtTime,
    this.amountAtTime,
    this.responseTimeMs,
    this.interpretedAt,
    this.confirmedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<String>(transactionId);
    if (!nullToAbsent || aiSuggestions != null) {
      map['ai_suggestions'] = Variable<String>(aiSuggestions);
    }
    map['input_method'] = Variable<String>(inputMethod);
    if (!nullToAbsent || rawInput != null) {
      map['raw_input'] = Variable<String>(rawInput);
    }
    if (!nullToAbsent || voiceTranscript != null) {
      map['voice_transcript'] = Variable<String>(voiceTranscript);
    }
    if (!nullToAbsent || voiceConfidence != null) {
      map['voice_confidence'] = Variable<double>(voiceConfidence);
    }
    if (!nullToAbsent || geminiInterpretation != null) {
      map['gemini_interpretation'] = Variable<String>(geminiInterpretation);
    }
    if (!nullToAbsent || geminiCategory != null) {
      map['gemini_category'] = Variable<String>(geminiCategory);
    }
    if (!nullToAbsent || geminiSubcategory != null) {
      map['gemini_subcategory'] = Variable<String>(geminiSubcategory);
    }
    if (!nullToAbsent || geminiConfidence != null) {
      map['gemini_confidence'] = Variable<double>(geminiConfidence);
    }
    if (!nullToAbsent || geminiReasoning != null) {
      map['gemini_reasoning'] = Variable<String>(geminiReasoning);
    }
    map['final_category'] = Variable<String>(finalCategory);
    map['is_custom_category'] = Variable<bool>(isCustomCategory);
    map['user_confirmed'] = Variable<bool>(userConfirmed);
    if (!nullToAbsent || userCorrection != null) {
      map['user_correction'] = Variable<String>(userCorrection);
    }
    if (!nullToAbsent || merchantAtTime != null) {
      map['merchant_at_time'] = Variable<String>(merchantAtTime);
    }
    if (!nullToAbsent || amountAtTime != null) {
      map['amount_at_time'] = Variable<double>(amountAtTime);
    }
    if (!nullToAbsent || responseTimeMs != null) {
      map['response_time_ms'] = Variable<int>(responseTimeMs);
    }
    if (!nullToAbsent || interpretedAt != null) {
      map['interpreted_at'] = Variable<int>(interpretedAt);
    }
    if (!nullToAbsent || confirmedAt != null) {
      map['confirmed_at'] = Variable<int>(confirmedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  UserResponsesCompanion toCompanion(bool nullToAbsent) {
    return UserResponsesCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      aiSuggestions: aiSuggestions == null && nullToAbsent
          ? const Value.absent()
          : Value(aiSuggestions),
      inputMethod: Value(inputMethod),
      rawInput: rawInput == null && nullToAbsent
          ? const Value.absent()
          : Value(rawInput),
      voiceTranscript: voiceTranscript == null && nullToAbsent
          ? const Value.absent()
          : Value(voiceTranscript),
      voiceConfidence: voiceConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(voiceConfidence),
      geminiInterpretation: geminiInterpretation == null && nullToAbsent
          ? const Value.absent()
          : Value(geminiInterpretation),
      geminiCategory: geminiCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(geminiCategory),
      geminiSubcategory: geminiSubcategory == null && nullToAbsent
          ? const Value.absent()
          : Value(geminiSubcategory),
      geminiConfidence: geminiConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(geminiConfidence),
      geminiReasoning: geminiReasoning == null && nullToAbsent
          ? const Value.absent()
          : Value(geminiReasoning),
      finalCategory: Value(finalCategory),
      isCustomCategory: Value(isCustomCategory),
      userConfirmed: Value(userConfirmed),
      userCorrection: userCorrection == null && nullToAbsent
          ? const Value.absent()
          : Value(userCorrection),
      merchantAtTime: merchantAtTime == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantAtTime),
      amountAtTime: amountAtTime == null && nullToAbsent
          ? const Value.absent()
          : Value(amountAtTime),
      responseTimeMs: responseTimeMs == null && nullToAbsent
          ? const Value.absent()
          : Value(responseTimeMs),
      interpretedAt: interpretedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(interpretedAt),
      confirmedAt: confirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedAt),
      createdAt: Value(createdAt),
    );
  }

  factory UserResponse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserResponse(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      aiSuggestions: serializer.fromJson<String?>(json['aiSuggestions']),
      inputMethod: serializer.fromJson<String>(json['inputMethod']),
      rawInput: serializer.fromJson<String?>(json['rawInput']),
      voiceTranscript: serializer.fromJson<String?>(json['voiceTranscript']),
      voiceConfidence: serializer.fromJson<double?>(json['voiceConfidence']),
      geminiInterpretation: serializer.fromJson<String?>(
        json['geminiInterpretation'],
      ),
      geminiCategory: serializer.fromJson<String?>(json['geminiCategory']),
      geminiSubcategory: serializer.fromJson<String?>(
        json['geminiSubcategory'],
      ),
      geminiConfidence: serializer.fromJson<double?>(json['geminiConfidence']),
      geminiReasoning: serializer.fromJson<String?>(json['geminiReasoning']),
      finalCategory: serializer.fromJson<String>(json['finalCategory']),
      isCustomCategory: serializer.fromJson<bool>(json['isCustomCategory']),
      userConfirmed: serializer.fromJson<bool>(json['userConfirmed']),
      userCorrection: serializer.fromJson<String?>(json['userCorrection']),
      merchantAtTime: serializer.fromJson<String?>(json['merchantAtTime']),
      amountAtTime: serializer.fromJson<double?>(json['amountAtTime']),
      responseTimeMs: serializer.fromJson<int?>(json['responseTimeMs']),
      interpretedAt: serializer.fromJson<int?>(json['interpretedAt']),
      confirmedAt: serializer.fromJson<int?>(json['confirmedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<String>(transactionId),
      'aiSuggestions': serializer.toJson<String?>(aiSuggestions),
      'inputMethod': serializer.toJson<String>(inputMethod),
      'rawInput': serializer.toJson<String?>(rawInput),
      'voiceTranscript': serializer.toJson<String?>(voiceTranscript),
      'voiceConfidence': serializer.toJson<double?>(voiceConfidence),
      'geminiInterpretation': serializer.toJson<String?>(geminiInterpretation),
      'geminiCategory': serializer.toJson<String?>(geminiCategory),
      'geminiSubcategory': serializer.toJson<String?>(geminiSubcategory),
      'geminiConfidence': serializer.toJson<double?>(geminiConfidence),
      'geminiReasoning': serializer.toJson<String?>(geminiReasoning),
      'finalCategory': serializer.toJson<String>(finalCategory),
      'isCustomCategory': serializer.toJson<bool>(isCustomCategory),
      'userConfirmed': serializer.toJson<bool>(userConfirmed),
      'userCorrection': serializer.toJson<String?>(userCorrection),
      'merchantAtTime': serializer.toJson<String?>(merchantAtTime),
      'amountAtTime': serializer.toJson<double?>(amountAtTime),
      'responseTimeMs': serializer.toJson<int?>(responseTimeMs),
      'interpretedAt': serializer.toJson<int?>(interpretedAt),
      'confirmedAt': serializer.toJson<int?>(confirmedAt),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  UserResponse copyWith({
    int? id,
    String? transactionId,
    Value<String?> aiSuggestions = const Value.absent(),
    String? inputMethod,
    Value<String?> rawInput = const Value.absent(),
    Value<String?> voiceTranscript = const Value.absent(),
    Value<double?> voiceConfidence = const Value.absent(),
    Value<String?> geminiInterpretation = const Value.absent(),
    Value<String?> geminiCategory = const Value.absent(),
    Value<String?> geminiSubcategory = const Value.absent(),
    Value<double?> geminiConfidence = const Value.absent(),
    Value<String?> geminiReasoning = const Value.absent(),
    String? finalCategory,
    bool? isCustomCategory,
    bool? userConfirmed,
    Value<String?> userCorrection = const Value.absent(),
    Value<String?> merchantAtTime = const Value.absent(),
    Value<double?> amountAtTime = const Value.absent(),
    Value<int?> responseTimeMs = const Value.absent(),
    Value<int?> interpretedAt = const Value.absent(),
    Value<int?> confirmedAt = const Value.absent(),
    int? createdAt,
  }) => UserResponse(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    aiSuggestions: aiSuggestions.present
        ? aiSuggestions.value
        : this.aiSuggestions,
    inputMethod: inputMethod ?? this.inputMethod,
    rawInput: rawInput.present ? rawInput.value : this.rawInput,
    voiceTranscript: voiceTranscript.present
        ? voiceTranscript.value
        : this.voiceTranscript,
    voiceConfidence: voiceConfidence.present
        ? voiceConfidence.value
        : this.voiceConfidence,
    geminiInterpretation: geminiInterpretation.present
        ? geminiInterpretation.value
        : this.geminiInterpretation,
    geminiCategory: geminiCategory.present
        ? geminiCategory.value
        : this.geminiCategory,
    geminiSubcategory: geminiSubcategory.present
        ? geminiSubcategory.value
        : this.geminiSubcategory,
    geminiConfidence: geminiConfidence.present
        ? geminiConfidence.value
        : this.geminiConfidence,
    geminiReasoning: geminiReasoning.present
        ? geminiReasoning.value
        : this.geminiReasoning,
    finalCategory: finalCategory ?? this.finalCategory,
    isCustomCategory: isCustomCategory ?? this.isCustomCategory,
    userConfirmed: userConfirmed ?? this.userConfirmed,
    userCorrection: userCorrection.present
        ? userCorrection.value
        : this.userCorrection,
    merchantAtTime: merchantAtTime.present
        ? merchantAtTime.value
        : this.merchantAtTime,
    amountAtTime: amountAtTime.present ? amountAtTime.value : this.amountAtTime,
    responseTimeMs: responseTimeMs.present
        ? responseTimeMs.value
        : this.responseTimeMs,
    interpretedAt: interpretedAt.present
        ? interpretedAt.value
        : this.interpretedAt,
    confirmedAt: confirmedAt.present ? confirmedAt.value : this.confirmedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  UserResponse copyWithCompanion(UserResponsesCompanion data) {
    return UserResponse(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      aiSuggestions: data.aiSuggestions.present
          ? data.aiSuggestions.value
          : this.aiSuggestions,
      inputMethod: data.inputMethod.present
          ? data.inputMethod.value
          : this.inputMethod,
      rawInput: data.rawInput.present ? data.rawInput.value : this.rawInput,
      voiceTranscript: data.voiceTranscript.present
          ? data.voiceTranscript.value
          : this.voiceTranscript,
      voiceConfidence: data.voiceConfidence.present
          ? data.voiceConfidence.value
          : this.voiceConfidence,
      geminiInterpretation: data.geminiInterpretation.present
          ? data.geminiInterpretation.value
          : this.geminiInterpretation,
      geminiCategory: data.geminiCategory.present
          ? data.geminiCategory.value
          : this.geminiCategory,
      geminiSubcategory: data.geminiSubcategory.present
          ? data.geminiSubcategory.value
          : this.geminiSubcategory,
      geminiConfidence: data.geminiConfidence.present
          ? data.geminiConfidence.value
          : this.geminiConfidence,
      geminiReasoning: data.geminiReasoning.present
          ? data.geminiReasoning.value
          : this.geminiReasoning,
      finalCategory: data.finalCategory.present
          ? data.finalCategory.value
          : this.finalCategory,
      isCustomCategory: data.isCustomCategory.present
          ? data.isCustomCategory.value
          : this.isCustomCategory,
      userConfirmed: data.userConfirmed.present
          ? data.userConfirmed.value
          : this.userConfirmed,
      userCorrection: data.userCorrection.present
          ? data.userCorrection.value
          : this.userCorrection,
      merchantAtTime: data.merchantAtTime.present
          ? data.merchantAtTime.value
          : this.merchantAtTime,
      amountAtTime: data.amountAtTime.present
          ? data.amountAtTime.value
          : this.amountAtTime,
      responseTimeMs: data.responseTimeMs.present
          ? data.responseTimeMs.value
          : this.responseTimeMs,
      interpretedAt: data.interpretedAt.present
          ? data.interpretedAt.value
          : this.interpretedAt,
      confirmedAt: data.confirmedAt.present
          ? data.confirmedAt.value
          : this.confirmedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserResponse(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('aiSuggestions: $aiSuggestions, ')
          ..write('inputMethod: $inputMethod, ')
          ..write('rawInput: $rawInput, ')
          ..write('voiceTranscript: $voiceTranscript, ')
          ..write('voiceConfidence: $voiceConfidence, ')
          ..write('geminiInterpretation: $geminiInterpretation, ')
          ..write('geminiCategory: $geminiCategory, ')
          ..write('geminiSubcategory: $geminiSubcategory, ')
          ..write('geminiConfidence: $geminiConfidence, ')
          ..write('geminiReasoning: $geminiReasoning, ')
          ..write('finalCategory: $finalCategory, ')
          ..write('isCustomCategory: $isCustomCategory, ')
          ..write('userConfirmed: $userConfirmed, ')
          ..write('userCorrection: $userCorrection, ')
          ..write('merchantAtTime: $merchantAtTime, ')
          ..write('amountAtTime: $amountAtTime, ')
          ..write('responseTimeMs: $responseTimeMs, ')
          ..write('interpretedAt: $interpretedAt, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    transactionId,
    aiSuggestions,
    inputMethod,
    rawInput,
    voiceTranscript,
    voiceConfidence,
    geminiInterpretation,
    geminiCategory,
    geminiSubcategory,
    geminiConfidence,
    geminiReasoning,
    finalCategory,
    isCustomCategory,
    userConfirmed,
    userCorrection,
    merchantAtTime,
    amountAtTime,
    responseTimeMs,
    interpretedAt,
    confirmedAt,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserResponse &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.aiSuggestions == this.aiSuggestions &&
          other.inputMethod == this.inputMethod &&
          other.rawInput == this.rawInput &&
          other.voiceTranscript == this.voiceTranscript &&
          other.voiceConfidence == this.voiceConfidence &&
          other.geminiInterpretation == this.geminiInterpretation &&
          other.geminiCategory == this.geminiCategory &&
          other.geminiSubcategory == this.geminiSubcategory &&
          other.geminiConfidence == this.geminiConfidence &&
          other.geminiReasoning == this.geminiReasoning &&
          other.finalCategory == this.finalCategory &&
          other.isCustomCategory == this.isCustomCategory &&
          other.userConfirmed == this.userConfirmed &&
          other.userCorrection == this.userCorrection &&
          other.merchantAtTime == this.merchantAtTime &&
          other.amountAtTime == this.amountAtTime &&
          other.responseTimeMs == this.responseTimeMs &&
          other.interpretedAt == this.interpretedAt &&
          other.confirmedAt == this.confirmedAt &&
          other.createdAt == this.createdAt);
}

class UserResponsesCompanion extends UpdateCompanion<UserResponse> {
  final Value<int> id;
  final Value<String> transactionId;
  final Value<String?> aiSuggestions;
  final Value<String> inputMethod;
  final Value<String?> rawInput;
  final Value<String?> voiceTranscript;
  final Value<double?> voiceConfidence;
  final Value<String?> geminiInterpretation;
  final Value<String?> geminiCategory;
  final Value<String?> geminiSubcategory;
  final Value<double?> geminiConfidence;
  final Value<String?> geminiReasoning;
  final Value<String> finalCategory;
  final Value<bool> isCustomCategory;
  final Value<bool> userConfirmed;
  final Value<String?> userCorrection;
  final Value<String?> merchantAtTime;
  final Value<double?> amountAtTime;
  final Value<int?> responseTimeMs;
  final Value<int?> interpretedAt;
  final Value<int?> confirmedAt;
  final Value<int> createdAt;
  const UserResponsesCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.aiSuggestions = const Value.absent(),
    this.inputMethod = const Value.absent(),
    this.rawInput = const Value.absent(),
    this.voiceTranscript = const Value.absent(),
    this.voiceConfidence = const Value.absent(),
    this.geminiInterpretation = const Value.absent(),
    this.geminiCategory = const Value.absent(),
    this.geminiSubcategory = const Value.absent(),
    this.geminiConfidence = const Value.absent(),
    this.geminiReasoning = const Value.absent(),
    this.finalCategory = const Value.absent(),
    this.isCustomCategory = const Value.absent(),
    this.userConfirmed = const Value.absent(),
    this.userCorrection = const Value.absent(),
    this.merchantAtTime = const Value.absent(),
    this.amountAtTime = const Value.absent(),
    this.responseTimeMs = const Value.absent(),
    this.interpretedAt = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UserResponsesCompanion.insert({
    this.id = const Value.absent(),
    required String transactionId,
    this.aiSuggestions = const Value.absent(),
    required String inputMethod,
    this.rawInput = const Value.absent(),
    this.voiceTranscript = const Value.absent(),
    this.voiceConfidence = const Value.absent(),
    this.geminiInterpretation = const Value.absent(),
    this.geminiCategory = const Value.absent(),
    this.geminiSubcategory = const Value.absent(),
    this.geminiConfidence = const Value.absent(),
    this.geminiReasoning = const Value.absent(),
    required String finalCategory,
    this.isCustomCategory = const Value.absent(),
    this.userConfirmed = const Value.absent(),
    this.userCorrection = const Value.absent(),
    this.merchantAtTime = const Value.absent(),
    this.amountAtTime = const Value.absent(),
    this.responseTimeMs = const Value.absent(),
    this.interpretedAt = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    required int createdAt,
  }) : transactionId = Value(transactionId),
       inputMethod = Value(inputMethod),
       finalCategory = Value(finalCategory),
       createdAt = Value(createdAt);
  static Insertable<UserResponse> custom({
    Expression<int>? id,
    Expression<String>? transactionId,
    Expression<String>? aiSuggestions,
    Expression<String>? inputMethod,
    Expression<String>? rawInput,
    Expression<String>? voiceTranscript,
    Expression<double>? voiceConfidence,
    Expression<String>? geminiInterpretation,
    Expression<String>? geminiCategory,
    Expression<String>? geminiSubcategory,
    Expression<double>? geminiConfidence,
    Expression<String>? geminiReasoning,
    Expression<String>? finalCategory,
    Expression<bool>? isCustomCategory,
    Expression<bool>? userConfirmed,
    Expression<String>? userCorrection,
    Expression<String>? merchantAtTime,
    Expression<double>? amountAtTime,
    Expression<int>? responseTimeMs,
    Expression<int>? interpretedAt,
    Expression<int>? confirmedAt,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (aiSuggestions != null) 'ai_suggestions': aiSuggestions,
      if (inputMethod != null) 'input_method': inputMethod,
      if (rawInput != null) 'raw_input': rawInput,
      if (voiceTranscript != null) 'voice_transcript': voiceTranscript,
      if (voiceConfidence != null) 'voice_confidence': voiceConfidence,
      if (geminiInterpretation != null)
        'gemini_interpretation': geminiInterpretation,
      if (geminiCategory != null) 'gemini_category': geminiCategory,
      if (geminiSubcategory != null) 'gemini_subcategory': geminiSubcategory,
      if (geminiConfidence != null) 'gemini_confidence': geminiConfidence,
      if (geminiReasoning != null) 'gemini_reasoning': geminiReasoning,
      if (finalCategory != null) 'final_category': finalCategory,
      if (isCustomCategory != null) 'is_custom_category': isCustomCategory,
      if (userConfirmed != null) 'user_confirmed': userConfirmed,
      if (userCorrection != null) 'user_correction': userCorrection,
      if (merchantAtTime != null) 'merchant_at_time': merchantAtTime,
      if (amountAtTime != null) 'amount_at_time': amountAtTime,
      if (responseTimeMs != null) 'response_time_ms': responseTimeMs,
      if (interpretedAt != null) 'interpreted_at': interpretedAt,
      if (confirmedAt != null) 'confirmed_at': confirmedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UserResponsesCompanion copyWith({
    Value<int>? id,
    Value<String>? transactionId,
    Value<String?>? aiSuggestions,
    Value<String>? inputMethod,
    Value<String?>? rawInput,
    Value<String?>? voiceTranscript,
    Value<double?>? voiceConfidence,
    Value<String?>? geminiInterpretation,
    Value<String?>? geminiCategory,
    Value<String?>? geminiSubcategory,
    Value<double?>? geminiConfidence,
    Value<String?>? geminiReasoning,
    Value<String>? finalCategory,
    Value<bool>? isCustomCategory,
    Value<bool>? userConfirmed,
    Value<String?>? userCorrection,
    Value<String?>? merchantAtTime,
    Value<double?>? amountAtTime,
    Value<int?>? responseTimeMs,
    Value<int?>? interpretedAt,
    Value<int?>? confirmedAt,
    Value<int>? createdAt,
  }) {
    return UserResponsesCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      aiSuggestions: aiSuggestions ?? this.aiSuggestions,
      inputMethod: inputMethod ?? this.inputMethod,
      rawInput: rawInput ?? this.rawInput,
      voiceTranscript: voiceTranscript ?? this.voiceTranscript,
      voiceConfidence: voiceConfidence ?? this.voiceConfidence,
      geminiInterpretation: geminiInterpretation ?? this.geminiInterpretation,
      geminiCategory: geminiCategory ?? this.geminiCategory,
      geminiSubcategory: geminiSubcategory ?? this.geminiSubcategory,
      geminiConfidence: geminiConfidence ?? this.geminiConfidence,
      geminiReasoning: geminiReasoning ?? this.geminiReasoning,
      finalCategory: finalCategory ?? this.finalCategory,
      isCustomCategory: isCustomCategory ?? this.isCustomCategory,
      userConfirmed: userConfirmed ?? this.userConfirmed,
      userCorrection: userCorrection ?? this.userCorrection,
      merchantAtTime: merchantAtTime ?? this.merchantAtTime,
      amountAtTime: amountAtTime ?? this.amountAtTime,
      responseTimeMs: responseTimeMs ?? this.responseTimeMs,
      interpretedAt: interpretedAt ?? this.interpretedAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (aiSuggestions.present) {
      map['ai_suggestions'] = Variable<String>(aiSuggestions.value);
    }
    if (inputMethod.present) {
      map['input_method'] = Variable<String>(inputMethod.value);
    }
    if (rawInput.present) {
      map['raw_input'] = Variable<String>(rawInput.value);
    }
    if (voiceTranscript.present) {
      map['voice_transcript'] = Variable<String>(voiceTranscript.value);
    }
    if (voiceConfidence.present) {
      map['voice_confidence'] = Variable<double>(voiceConfidence.value);
    }
    if (geminiInterpretation.present) {
      map['gemini_interpretation'] = Variable<String>(
        geminiInterpretation.value,
      );
    }
    if (geminiCategory.present) {
      map['gemini_category'] = Variable<String>(geminiCategory.value);
    }
    if (geminiSubcategory.present) {
      map['gemini_subcategory'] = Variable<String>(geminiSubcategory.value);
    }
    if (geminiConfidence.present) {
      map['gemini_confidence'] = Variable<double>(geminiConfidence.value);
    }
    if (geminiReasoning.present) {
      map['gemini_reasoning'] = Variable<String>(geminiReasoning.value);
    }
    if (finalCategory.present) {
      map['final_category'] = Variable<String>(finalCategory.value);
    }
    if (isCustomCategory.present) {
      map['is_custom_category'] = Variable<bool>(isCustomCategory.value);
    }
    if (userConfirmed.present) {
      map['user_confirmed'] = Variable<bool>(userConfirmed.value);
    }
    if (userCorrection.present) {
      map['user_correction'] = Variable<String>(userCorrection.value);
    }
    if (merchantAtTime.present) {
      map['merchant_at_time'] = Variable<String>(merchantAtTime.value);
    }
    if (amountAtTime.present) {
      map['amount_at_time'] = Variable<double>(amountAtTime.value);
    }
    if (responseTimeMs.present) {
      map['response_time_ms'] = Variable<int>(responseTimeMs.value);
    }
    if (interpretedAt.present) {
      map['interpreted_at'] = Variable<int>(interpretedAt.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<int>(confirmedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserResponsesCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('aiSuggestions: $aiSuggestions, ')
          ..write('inputMethod: $inputMethod, ')
          ..write('rawInput: $rawInput, ')
          ..write('voiceTranscript: $voiceTranscript, ')
          ..write('voiceConfidence: $voiceConfidence, ')
          ..write('geminiInterpretation: $geminiInterpretation, ')
          ..write('geminiCategory: $geminiCategory, ')
          ..write('geminiSubcategory: $geminiSubcategory, ')
          ..write('geminiConfidence: $geminiConfidence, ')
          ..write('geminiReasoning: $geminiReasoning, ')
          ..write('finalCategory: $finalCategory, ')
          ..write('isCustomCategory: $isCustomCategory, ')
          ..write('userConfirmed: $userConfirmed, ')
          ..write('userCorrection: $userCorrection, ')
          ..write('merchantAtTime: $merchantAtTime, ')
          ..write('amountAtTime: $amountAtTime, ')
          ..write('responseTimeMs: $responseTimeMs, ')
          ..write('interpretedAt: $interpretedAt, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CustomCategoriesTable extends CustomCategories
    with TableInfo<$CustomCategoriesTable, CustomCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _learnedKeywordsMeta = const VerificationMeta(
    'learnedKeywords',
  );
  @override
  late final GeneratedColumn<String> learnedKeywords = GeneratedColumn<String>(
    'learned_keywords',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _learnedMerchantsMeta = const VerificationMeta(
    'learnedMerchants',
  );
  @override
  late final GeneratedColumn<String> learnedMerchants = GeneratedColumn<String>(
    'learned_merchants',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usageCountMeta = const VerificationMeta(
    'usageCount',
  );
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
    'usage_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<int> lastUsedAt = GeneratedColumn<int>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    displayName,
    emoji,
    color,
    description,
    learnedKeywords,
    learnedMerchants,
    usageCount,
    lastUsedAt,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('learned_keywords')) {
      context.handle(
        _learnedKeywordsMeta,
        learnedKeywords.isAcceptableOrUnknown(
          data['learned_keywords']!,
          _learnedKeywordsMeta,
        ),
      );
    }
    if (data.containsKey('learned_merchants')) {
      context.handle(
        _learnedMerchantsMeta,
        learnedMerchants.isAcceptableOrUnknown(
          data['learned_merchants']!,
          _learnedMerchantsMeta,
        ),
      );
    }
    if (data.containsKey('usage_count')) {
      context.handle(
        _usageCountMeta,
        usageCount.isAcceptableOrUnknown(data['usage_count']!, _usageCountMeta),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      learnedKeywords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learned_keywords'],
      ),
      learnedMerchants: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learned_merchants'],
      ),
      usageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usage_count'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_used_at'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CustomCategoriesTable createAlias(String alias) {
    return $CustomCategoriesTable(attachedDatabase, alias);
  }
}

class CustomCategory extends DataClass implements Insertable<CustomCategory> {
  final int id;
  final String name;
  final String displayName;
  final String? emoji;
  final String? color;
  final String? description;
  final String? learnedKeywords;
  final String? learnedMerchants;
  final int usageCount;
  final int? lastUsedAt;
  final bool isActive;
  final int createdAt;
  final int updatedAt;
  const CustomCategory({
    required this.id,
    required this.name,
    required this.displayName,
    this.emoji,
    this.color,
    this.description,
    this.learnedKeywords,
    this.learnedMerchants,
    required this.usageCount,
    this.lastUsedAt,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || emoji != null) {
      map['emoji'] = Variable<String>(emoji);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || learnedKeywords != null) {
      map['learned_keywords'] = Variable<String>(learnedKeywords);
    }
    if (!nullToAbsent || learnedMerchants != null) {
      map['learned_merchants'] = Variable<String>(learnedMerchants);
    }
    map['usage_count'] = Variable<int>(usageCount);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<int>(lastUsedAt);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  CustomCategoriesCompanion toCompanion(bool nullToAbsent) {
    return CustomCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      displayName: Value(displayName),
      emoji: emoji == null && nullToAbsent
          ? const Value.absent()
          : Value(emoji),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      learnedKeywords: learnedKeywords == null && nullToAbsent
          ? const Value.absent()
          : Value(learnedKeywords),
      learnedMerchants: learnedMerchants == null && nullToAbsent
          ? const Value.absent()
          : Value(learnedMerchants),
      usageCount: Value(usageCount),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CustomCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      displayName: serializer.fromJson<String>(json['displayName']),
      emoji: serializer.fromJson<String?>(json['emoji']),
      color: serializer.fromJson<String?>(json['color']),
      description: serializer.fromJson<String?>(json['description']),
      learnedKeywords: serializer.fromJson<String?>(json['learnedKeywords']),
      learnedMerchants: serializer.fromJson<String?>(json['learnedMerchants']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      lastUsedAt: serializer.fromJson<int?>(json['lastUsedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'displayName': serializer.toJson<String>(displayName),
      'emoji': serializer.toJson<String?>(emoji),
      'color': serializer.toJson<String?>(color),
      'description': serializer.toJson<String?>(description),
      'learnedKeywords': serializer.toJson<String?>(learnedKeywords),
      'learnedMerchants': serializer.toJson<String?>(learnedMerchants),
      'usageCount': serializer.toJson<int>(usageCount),
      'lastUsedAt': serializer.toJson<int?>(lastUsedAt),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  CustomCategory copyWith({
    int? id,
    String? name,
    String? displayName,
    Value<String?> emoji = const Value.absent(),
    Value<String?> color = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> learnedKeywords = const Value.absent(),
    Value<String?> learnedMerchants = const Value.absent(),
    int? usageCount,
    Value<int?> lastUsedAt = const Value.absent(),
    bool? isActive,
    int? createdAt,
    int? updatedAt,
  }) => CustomCategory(
    id: id ?? this.id,
    name: name ?? this.name,
    displayName: displayName ?? this.displayName,
    emoji: emoji.present ? emoji.value : this.emoji,
    color: color.present ? color.value : this.color,
    description: description.present ? description.value : this.description,
    learnedKeywords: learnedKeywords.present
        ? learnedKeywords.value
        : this.learnedKeywords,
    learnedMerchants: learnedMerchants.present
        ? learnedMerchants.value
        : this.learnedMerchants,
    usageCount: usageCount ?? this.usageCount,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CustomCategory copyWithCompanion(CustomCategoriesCompanion data) {
    return CustomCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      color: data.color.present ? data.color.value : this.color,
      description: data.description.present
          ? data.description.value
          : this.description,
      learnedKeywords: data.learnedKeywords.present
          ? data.learnedKeywords.value
          : this.learnedKeywords,
      learnedMerchants: data.learnedMerchants.present
          ? data.learnedMerchants.value
          : this.learnedMerchants,
      usageCount: data.usageCount.present
          ? data.usageCount.value
          : this.usageCount,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('emoji: $emoji, ')
          ..write('color: $color, ')
          ..write('description: $description, ')
          ..write('learnedKeywords: $learnedKeywords, ')
          ..write('learnedMerchants: $learnedMerchants, ')
          ..write('usageCount: $usageCount, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    displayName,
    emoji,
    color,
    description,
    learnedKeywords,
    learnedMerchants,
    usageCount,
    lastUsedAt,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.displayName == this.displayName &&
          other.emoji == this.emoji &&
          other.color == this.color &&
          other.description == this.description &&
          other.learnedKeywords == this.learnedKeywords &&
          other.learnedMerchants == this.learnedMerchants &&
          other.usageCount == this.usageCount &&
          other.lastUsedAt == this.lastUsedAt &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomCategoriesCompanion extends UpdateCompanion<CustomCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> displayName;
  final Value<String?> emoji;
  final Value<String?> color;
  final Value<String?> description;
  final Value<String?> learnedKeywords;
  final Value<String?> learnedMerchants;
  final Value<int> usageCount;
  final Value<int?> lastUsedAt;
  final Value<bool> isActive;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const CustomCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.displayName = const Value.absent(),
    this.emoji = const Value.absent(),
    this.color = const Value.absent(),
    this.description = const Value.absent(),
    this.learnedKeywords = const Value.absent(),
    this.learnedMerchants = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CustomCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String displayName,
    this.emoji = const Value.absent(),
    this.color = const Value.absent(),
    this.description = const Value.absent(),
    this.learnedKeywords = const Value.absent(),
    this.learnedMerchants = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : name = Value(name),
       displayName = Value(displayName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CustomCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? displayName,
    Expression<String>? emoji,
    Expression<String>? color,
    Expression<String>? description,
    Expression<String>? learnedKeywords,
    Expression<String>? learnedMerchants,
    Expression<int>? usageCount,
    Expression<int>? lastUsedAt,
    Expression<bool>? isActive,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (displayName != null) 'display_name': displayName,
      if (emoji != null) 'emoji': emoji,
      if (color != null) 'color': color,
      if (description != null) 'description': description,
      if (learnedKeywords != null) 'learned_keywords': learnedKeywords,
      if (learnedMerchants != null) 'learned_merchants': learnedMerchants,
      if (usageCount != null) 'usage_count': usageCount,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CustomCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? displayName,
    Value<String?>? emoji,
    Value<String?>? color,
    Value<String?>? description,
    Value<String?>? learnedKeywords,
    Value<String?>? learnedMerchants,
    Value<int>? usageCount,
    Value<int?>? lastUsedAt,
    Value<bool>? isActive,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return CustomCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      description: description ?? this.description,
      learnedKeywords: learnedKeywords ?? this.learnedKeywords,
      learnedMerchants: learnedMerchants ?? this.learnedMerchants,
      usageCount: usageCount ?? this.usageCount,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (learnedKeywords.present) {
      map['learned_keywords'] = Variable<String>(learnedKeywords.value);
    }
    if (learnedMerchants.present) {
      map['learned_merchants'] = Variable<String>(learnedMerchants.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<int>(lastUsedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('emoji: $emoji, ')
          ..write('color: $color, ')
          ..write('description: $description, ')
          ..write('learnedKeywords: $learnedKeywords, ')
          ..write('learnedMerchants: $learnedMerchants, ')
          ..write('usageCount: $usageCount, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MerchantsTable extends Merchants
    with TableInfo<$MerchantsTable, Merchant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MerchantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawIdMeta = const VerificationMeta('rawId');
  @override
  late final GeneratedColumn<String> rawId = GeneratedColumn<String>(
    'raw_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCustomCategoryMeta = const VerificationMeta(
    'isCustomCategory',
  );
  @override
  late final GeneratedColumn<bool> isCustomCategory = GeneratedColumn<bool>(
    'is_custom_category',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom_category" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _friendlyNameMeta = const VerificationMeta(
    'friendlyName',
  );
  @override
  late final GeneratedColumn<String> friendlyName = GeneratedColumn<String>(
    'friendly_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timesCategorizedMeta = const VerificationMeta(
    'timesCategorized',
  );
  @override
  late final GeneratedColumn<int> timesCategorized = GeneratedColumn<int>(
    'times_categorized',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastCategoryCountsMeta =
      const VerificationMeta('lastCategoryCounts');
  @override
  late final GeneratedColumn<String> lastCategoryCounts =
      GeneratedColumn<String>(
        'last_category_counts',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _usageCountMeta = const VerificationMeta(
    'usageCount',
  );
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
    'usage_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _totalSpentMeta = const VerificationMeta(
    'totalSpent',
  );
  @override
  late final GeneratedColumn<double> totalSpent = GeneratedColumn<double>(
    'total_spent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<int> lastUsedAt = GeneratedColumn<int>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _learnedAtMeta = const VerificationMeta(
    'learnedAt',
  );
  @override
  late final GeneratedColumn<int> learnedAt = GeneratedColumn<int>(
    'learned_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rawId,
    category,
    isCustomCategory,
    friendlyName,
    timesCategorized,
    lastCategoryCounts,
    usageCount,
    totalSpent,
    lastUsedAt,
    learnedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'merchants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Merchant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('raw_id')) {
      context.handle(
        _rawIdMeta,
        rawId.isAcceptableOrUnknown(data['raw_id']!, _rawIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rawIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('is_custom_category')) {
      context.handle(
        _isCustomCategoryMeta,
        isCustomCategory.isAcceptableOrUnknown(
          data['is_custom_category']!,
          _isCustomCategoryMeta,
        ),
      );
    }
    if (data.containsKey('friendly_name')) {
      context.handle(
        _friendlyNameMeta,
        friendlyName.isAcceptableOrUnknown(
          data['friendly_name']!,
          _friendlyNameMeta,
        ),
      );
    }
    if (data.containsKey('times_categorized')) {
      context.handle(
        _timesCategorizedMeta,
        timesCategorized.isAcceptableOrUnknown(
          data['times_categorized']!,
          _timesCategorizedMeta,
        ),
      );
    }
    if (data.containsKey('last_category_counts')) {
      context.handle(
        _lastCategoryCountsMeta,
        lastCategoryCounts.isAcceptableOrUnknown(
          data['last_category_counts']!,
          _lastCategoryCountsMeta,
        ),
      );
    }
    if (data.containsKey('usage_count')) {
      context.handle(
        _usageCountMeta,
        usageCount.isAcceptableOrUnknown(data['usage_count']!, _usageCountMeta),
      );
    }
    if (data.containsKey('total_spent')) {
      context.handle(
        _totalSpentMeta,
        totalSpent.isAcceptableOrUnknown(data['total_spent']!, _totalSpentMeta),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    if (data.containsKey('learned_at')) {
      context.handle(
        _learnedAtMeta,
        learnedAt.isAcceptableOrUnknown(data['learned_at']!, _learnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_learnedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Merchant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Merchant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rawId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      isCustomCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom_category'],
      )!,
      friendlyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}friendly_name'],
      ),
      timesCategorized: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_categorized'],
      )!,
      lastCategoryCounts: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_category_counts'],
      ),
      usageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usage_count'],
      )!,
      totalSpent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_spent'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_used_at'],
      ),
      learnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}learned_at'],
      )!,
    );
  }

  @override
  $MerchantsTable createAlias(String alias) {
    return $MerchantsTable(attachedDatabase, alias);
  }
}

class Merchant extends DataClass implements Insertable<Merchant> {
  final String id;
  final String rawId;
  final String? category;
  final bool isCustomCategory;
  final String? friendlyName;
  final int timesCategorized;
  final String? lastCategoryCounts;
  final int usageCount;
  final double totalSpent;
  final int? lastUsedAt;
  final int learnedAt;
  const Merchant({
    required this.id,
    required this.rawId,
    this.category,
    required this.isCustomCategory,
    this.friendlyName,
    required this.timesCategorized,
    this.lastCategoryCounts,
    required this.usageCount,
    required this.totalSpent,
    this.lastUsedAt,
    required this.learnedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['raw_id'] = Variable<String>(rawId);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['is_custom_category'] = Variable<bool>(isCustomCategory);
    if (!nullToAbsent || friendlyName != null) {
      map['friendly_name'] = Variable<String>(friendlyName);
    }
    map['times_categorized'] = Variable<int>(timesCategorized);
    if (!nullToAbsent || lastCategoryCounts != null) {
      map['last_category_counts'] = Variable<String>(lastCategoryCounts);
    }
    map['usage_count'] = Variable<int>(usageCount);
    map['total_spent'] = Variable<double>(totalSpent);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<int>(lastUsedAt);
    }
    map['learned_at'] = Variable<int>(learnedAt);
    return map;
  }

  MerchantsCompanion toCompanion(bool nullToAbsent) {
    return MerchantsCompanion(
      id: Value(id),
      rawId: Value(rawId),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      isCustomCategory: Value(isCustomCategory),
      friendlyName: friendlyName == null && nullToAbsent
          ? const Value.absent()
          : Value(friendlyName),
      timesCategorized: Value(timesCategorized),
      lastCategoryCounts: lastCategoryCounts == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCategoryCounts),
      usageCount: Value(usageCount),
      totalSpent: Value(totalSpent),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      learnedAt: Value(learnedAt),
    );
  }

  factory Merchant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Merchant(
      id: serializer.fromJson<String>(json['id']),
      rawId: serializer.fromJson<String>(json['rawId']),
      category: serializer.fromJson<String?>(json['category']),
      isCustomCategory: serializer.fromJson<bool>(json['isCustomCategory']),
      friendlyName: serializer.fromJson<String?>(json['friendlyName']),
      timesCategorized: serializer.fromJson<int>(json['timesCategorized']),
      lastCategoryCounts: serializer.fromJson<String?>(
        json['lastCategoryCounts'],
      ),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      totalSpent: serializer.fromJson<double>(json['totalSpent']),
      lastUsedAt: serializer.fromJson<int?>(json['lastUsedAt']),
      learnedAt: serializer.fromJson<int>(json['learnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rawId': serializer.toJson<String>(rawId),
      'category': serializer.toJson<String?>(category),
      'isCustomCategory': serializer.toJson<bool>(isCustomCategory),
      'friendlyName': serializer.toJson<String?>(friendlyName),
      'timesCategorized': serializer.toJson<int>(timesCategorized),
      'lastCategoryCounts': serializer.toJson<String?>(lastCategoryCounts),
      'usageCount': serializer.toJson<int>(usageCount),
      'totalSpent': serializer.toJson<double>(totalSpent),
      'lastUsedAt': serializer.toJson<int?>(lastUsedAt),
      'learnedAt': serializer.toJson<int>(learnedAt),
    };
  }

  Merchant copyWith({
    String? id,
    String? rawId,
    Value<String?> category = const Value.absent(),
    bool? isCustomCategory,
    Value<String?> friendlyName = const Value.absent(),
    int? timesCategorized,
    Value<String?> lastCategoryCounts = const Value.absent(),
    int? usageCount,
    double? totalSpent,
    Value<int?> lastUsedAt = const Value.absent(),
    int? learnedAt,
  }) => Merchant(
    id: id ?? this.id,
    rawId: rawId ?? this.rawId,
    category: category.present ? category.value : this.category,
    isCustomCategory: isCustomCategory ?? this.isCustomCategory,
    friendlyName: friendlyName.present ? friendlyName.value : this.friendlyName,
    timesCategorized: timesCategorized ?? this.timesCategorized,
    lastCategoryCounts: lastCategoryCounts.present
        ? lastCategoryCounts.value
        : this.lastCategoryCounts,
    usageCount: usageCount ?? this.usageCount,
    totalSpent: totalSpent ?? this.totalSpent,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    learnedAt: learnedAt ?? this.learnedAt,
  );
  Merchant copyWithCompanion(MerchantsCompanion data) {
    return Merchant(
      id: data.id.present ? data.id.value : this.id,
      rawId: data.rawId.present ? data.rawId.value : this.rawId,
      category: data.category.present ? data.category.value : this.category,
      isCustomCategory: data.isCustomCategory.present
          ? data.isCustomCategory.value
          : this.isCustomCategory,
      friendlyName: data.friendlyName.present
          ? data.friendlyName.value
          : this.friendlyName,
      timesCategorized: data.timesCategorized.present
          ? data.timesCategorized.value
          : this.timesCategorized,
      lastCategoryCounts: data.lastCategoryCounts.present
          ? data.lastCategoryCounts.value
          : this.lastCategoryCounts,
      usageCount: data.usageCount.present
          ? data.usageCount.value
          : this.usageCount,
      totalSpent: data.totalSpent.present
          ? data.totalSpent.value
          : this.totalSpent,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
      learnedAt: data.learnedAt.present ? data.learnedAt.value : this.learnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Merchant(')
          ..write('id: $id, ')
          ..write('rawId: $rawId, ')
          ..write('category: $category, ')
          ..write('isCustomCategory: $isCustomCategory, ')
          ..write('friendlyName: $friendlyName, ')
          ..write('timesCategorized: $timesCategorized, ')
          ..write('lastCategoryCounts: $lastCategoryCounts, ')
          ..write('usageCount: $usageCount, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('learnedAt: $learnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    rawId,
    category,
    isCustomCategory,
    friendlyName,
    timesCategorized,
    lastCategoryCounts,
    usageCount,
    totalSpent,
    lastUsedAt,
    learnedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Merchant &&
          other.id == this.id &&
          other.rawId == this.rawId &&
          other.category == this.category &&
          other.isCustomCategory == this.isCustomCategory &&
          other.friendlyName == this.friendlyName &&
          other.timesCategorized == this.timesCategorized &&
          other.lastCategoryCounts == this.lastCategoryCounts &&
          other.usageCount == this.usageCount &&
          other.totalSpent == this.totalSpent &&
          other.lastUsedAt == this.lastUsedAt &&
          other.learnedAt == this.learnedAt);
}

class MerchantsCompanion extends UpdateCompanion<Merchant> {
  final Value<String> id;
  final Value<String> rawId;
  final Value<String?> category;
  final Value<bool> isCustomCategory;
  final Value<String?> friendlyName;
  final Value<int> timesCategorized;
  final Value<String?> lastCategoryCounts;
  final Value<int> usageCount;
  final Value<double> totalSpent;
  final Value<int?> lastUsedAt;
  final Value<int> learnedAt;
  final Value<int> rowid;
  const MerchantsCompanion({
    this.id = const Value.absent(),
    this.rawId = const Value.absent(),
    this.category = const Value.absent(),
    this.isCustomCategory = const Value.absent(),
    this.friendlyName = const Value.absent(),
    this.timesCategorized = const Value.absent(),
    this.lastCategoryCounts = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.totalSpent = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.learnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MerchantsCompanion.insert({
    required String id,
    required String rawId,
    this.category = const Value.absent(),
    this.isCustomCategory = const Value.absent(),
    this.friendlyName = const Value.absent(),
    this.timesCategorized = const Value.absent(),
    this.lastCategoryCounts = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.totalSpent = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    required int learnedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rawId = Value(rawId),
       learnedAt = Value(learnedAt);
  static Insertable<Merchant> custom({
    Expression<String>? id,
    Expression<String>? rawId,
    Expression<String>? category,
    Expression<bool>? isCustomCategory,
    Expression<String>? friendlyName,
    Expression<int>? timesCategorized,
    Expression<String>? lastCategoryCounts,
    Expression<int>? usageCount,
    Expression<double>? totalSpent,
    Expression<int>? lastUsedAt,
    Expression<int>? learnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rawId != null) 'raw_id': rawId,
      if (category != null) 'category': category,
      if (isCustomCategory != null) 'is_custom_category': isCustomCategory,
      if (friendlyName != null) 'friendly_name': friendlyName,
      if (timesCategorized != null) 'times_categorized': timesCategorized,
      if (lastCategoryCounts != null)
        'last_category_counts': lastCategoryCounts,
      if (usageCount != null) 'usage_count': usageCount,
      if (totalSpent != null) 'total_spent': totalSpent,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (learnedAt != null) 'learned_at': learnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MerchantsCompanion copyWith({
    Value<String>? id,
    Value<String>? rawId,
    Value<String?>? category,
    Value<bool>? isCustomCategory,
    Value<String?>? friendlyName,
    Value<int>? timesCategorized,
    Value<String?>? lastCategoryCounts,
    Value<int>? usageCount,
    Value<double>? totalSpent,
    Value<int?>? lastUsedAt,
    Value<int>? learnedAt,
    Value<int>? rowid,
  }) {
    return MerchantsCompanion(
      id: id ?? this.id,
      rawId: rawId ?? this.rawId,
      category: category ?? this.category,
      isCustomCategory: isCustomCategory ?? this.isCustomCategory,
      friendlyName: friendlyName ?? this.friendlyName,
      timesCategorized: timesCategorized ?? this.timesCategorized,
      lastCategoryCounts: lastCategoryCounts ?? this.lastCategoryCounts,
      usageCount: usageCount ?? this.usageCount,
      totalSpent: totalSpent ?? this.totalSpent,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      learnedAt: learnedAt ?? this.learnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rawId.present) {
      map['raw_id'] = Variable<String>(rawId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isCustomCategory.present) {
      map['is_custom_category'] = Variable<bool>(isCustomCategory.value);
    }
    if (friendlyName.present) {
      map['friendly_name'] = Variable<String>(friendlyName.value);
    }
    if (timesCategorized.present) {
      map['times_categorized'] = Variable<int>(timesCategorized.value);
    }
    if (lastCategoryCounts.present) {
      map['last_category_counts'] = Variable<String>(lastCategoryCounts.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (totalSpent.present) {
      map['total_spent'] = Variable<double>(totalSpent.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<int>(lastUsedAt.value);
    }
    if (learnedAt.present) {
      map['learned_at'] = Variable<int>(learnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MerchantsCompanion(')
          ..write('id: $id, ')
          ..write('rawId: $rawId, ')
          ..write('category: $category, ')
          ..write('isCustomCategory: $isCustomCategory, ')
          ..write('friendlyName: $friendlyName, ')
          ..write('timesCategorized: $timesCategorized, ')
          ..write('lastCategoryCounts: $lastCategoryCounts, ')
          ..write('usageCount: $usageCount, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('learnedAt: $learnedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomCategoryMeta = const VerificationMeta(
    'isCustomCategory',
  );
  @override
  late final GeneratedColumn<bool> isCustomCategory = GeneratedColumn<bool>(
    'is_custom_category',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom_category" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    isCustomCategory,
    period,
    amount,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('is_custom_category')) {
      context.handle(
        _isCustomCategoryMeta,
        isCustomCategory.isAcceptableOrUnknown(
          data['is_custom_category']!,
          _isCustomCategoryMeta,
        ),
      );
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {category, period},
  ];
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      isCustomCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom_category'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final int id;
  final String category;
  final bool isCustomCategory;
  final String period;
  final double amount;
  final int createdAt;
  final int updatedAt;
  const Budget({
    required this.id,
    required this.category,
    required this.isCustomCategory,
    required this.period,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['is_custom_category'] = Variable<bool>(isCustomCategory);
    map['period'] = Variable<String>(period);
    map['amount'] = Variable<double>(amount);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      category: Value(category),
      isCustomCategory: Value(isCustomCategory),
      period: Value(period),
      amount: Value(amount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      isCustomCategory: serializer.fromJson<bool>(json['isCustomCategory']),
      period: serializer.fromJson<String>(json['period']),
      amount: serializer.fromJson<double>(json['amount']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'isCustomCategory': serializer.toJson<bool>(isCustomCategory),
      'period': serializer.toJson<String>(period),
      'amount': serializer.toJson<double>(amount),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Budget copyWith({
    int? id,
    String? category,
    bool? isCustomCategory,
    String? period,
    double? amount,
    int? createdAt,
    int? updatedAt,
  }) => Budget(
    id: id ?? this.id,
    category: category ?? this.category,
    isCustomCategory: isCustomCategory ?? this.isCustomCategory,
    period: period ?? this.period,
    amount: amount ?? this.amount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      isCustomCategory: data.isCustomCategory.present
          ? data.isCustomCategory.value
          : this.isCustomCategory,
      period: data.period.present ? data.period.value : this.period,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('isCustomCategory: $isCustomCategory, ')
          ..write('period: $period, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    isCustomCategory,
    period,
    amount,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.category == this.category &&
          other.isCustomCategory == this.isCustomCategory &&
          other.period == this.period &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<int> id;
  final Value<String> category;
  final Value<bool> isCustomCategory;
  final Value<String> period;
  final Value<double> amount;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.isCustomCategory = const Value.absent(),
    this.period = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    this.isCustomCategory = const Value.absent(),
    required String period,
    required double amount,
    required int createdAt,
    required int updatedAt,
  }) : category = Value(category),
       period = Value(period),
       amount = Value(amount),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Budget> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<bool>? isCustomCategory,
    Expression<String>? period,
    Expression<double>? amount,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (isCustomCategory != null) 'is_custom_category': isCustomCategory,
      if (period != null) 'period': period,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<bool>? isCustomCategory,
    Value<String>? period,
    Value<double>? amount,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      isCustomCategory: isCustomCategory ?? this.isCustomCategory,
      period: period ?? this.period,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isCustomCategory.present) {
      map['is_custom_category'] = Variable<bool>(isCustomCategory.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('isCustomCategory: $isCustomCategory, ')
          ..write('period: $period, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InsightsTable extends Insights with TableInfo<$InsightsTable, Insight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InsightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<int> generatedAt = GeneratedColumn<int>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<int> expiresAt = GeneratedColumn<int>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDismissedMeta = const VerificationMeta(
    'isDismissed',
  );
  @override
  late final GeneratedColumn<bool> isDismissed = GeneratedColumn<bool>(
    'is_dismissed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dismissed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    title,
    subtitle,
    icon,
    category,
    generatedAt,
    expiresAt,
    isRead,
    isDismissed,
    dataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'insights';
  @override
  VerificationContext validateIntegrity(
    Insertable<Insight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('is_dismissed')) {
      context.handle(
        _isDismissedMeta,
        isDismissed.isAcceptableOrUnknown(
          data['is_dismissed']!,
          _isDismissedMeta,
        ),
      );
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Insight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Insight(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}generated_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expires_at'],
      ),
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      isDismissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dismissed'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      ),
    );
  }

  @override
  $InsightsTable createAlias(String alias) {
    return $InsightsTable(attachedDatabase, alias);
  }
}

class Insight extends DataClass implements Insertable<Insight> {
  final int id;
  final String type;
  final String title;
  final String? subtitle;
  final String? icon;
  final String? category;
  final int generatedAt;
  final int? expiresAt;
  final bool isRead;
  final bool isDismissed;
  final String? dataJson;
  const Insight({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.icon,
    this.category,
    required this.generatedAt,
    this.expiresAt,
    required this.isRead,
    required this.isDismissed,
    this.dataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['generated_at'] = Variable<int>(generatedAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<int>(expiresAt);
    }
    map['is_read'] = Variable<bool>(isRead);
    map['is_dismissed'] = Variable<bool>(isDismissed);
    if (!nullToAbsent || dataJson != null) {
      map['data_json'] = Variable<String>(dataJson);
    }
    return map;
  }

  InsightsCompanion toCompanion(bool nullToAbsent) {
    return InsightsCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      generatedAt: Value(generatedAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      isRead: Value(isRead),
      isDismissed: Value(isDismissed),
      dataJson: dataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(dataJson),
    );
  }

  factory Insight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Insight(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      icon: serializer.fromJson<String?>(json['icon']),
      category: serializer.fromJson<String?>(json['category']),
      generatedAt: serializer.fromJson<int>(json['generatedAt']),
      expiresAt: serializer.fromJson<int?>(json['expiresAt']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      isDismissed: serializer.fromJson<bool>(json['isDismissed']),
      dataJson: serializer.fromJson<String?>(json['dataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String?>(subtitle),
      'icon': serializer.toJson<String?>(icon),
      'category': serializer.toJson<String?>(category),
      'generatedAt': serializer.toJson<int>(generatedAt),
      'expiresAt': serializer.toJson<int?>(expiresAt),
      'isRead': serializer.toJson<bool>(isRead),
      'isDismissed': serializer.toJson<bool>(isDismissed),
      'dataJson': serializer.toJson<String?>(dataJson),
    };
  }

  Insight copyWith({
    int? id,
    String? type,
    String? title,
    Value<String?> subtitle = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    Value<String?> category = const Value.absent(),
    int? generatedAt,
    Value<int?> expiresAt = const Value.absent(),
    bool? isRead,
    bool? isDismissed,
    Value<String?> dataJson = const Value.absent(),
  }) => Insight(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    subtitle: subtitle.present ? subtitle.value : this.subtitle,
    icon: icon.present ? icon.value : this.icon,
    category: category.present ? category.value : this.category,
    generatedAt: generatedAt ?? this.generatedAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    isRead: isRead ?? this.isRead,
    isDismissed: isDismissed ?? this.isDismissed,
    dataJson: dataJson.present ? dataJson.value : this.dataJson,
  );
  Insight copyWithCompanion(InsightsCompanion data) {
    return Insight(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      icon: data.icon.present ? data.icon.value : this.icon,
      category: data.category.present ? data.category.value : this.category,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      isDismissed: data.isDismissed.present
          ? data.isDismissed.value
          : this.isDismissed,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Insight(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('icon: $icon, ')
          ..write('category: $category, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('isRead: $isRead, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('dataJson: $dataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    title,
    subtitle,
    icon,
    category,
    generatedAt,
    expiresAt,
    isRead,
    isDismissed,
    dataJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Insight &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.icon == this.icon &&
          other.category == this.category &&
          other.generatedAt == this.generatedAt &&
          other.expiresAt == this.expiresAt &&
          other.isRead == this.isRead &&
          other.isDismissed == this.isDismissed &&
          other.dataJson == this.dataJson);
}

class InsightsCompanion extends UpdateCompanion<Insight> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> subtitle;
  final Value<String?> icon;
  final Value<String?> category;
  final Value<int> generatedAt;
  final Value<int?> expiresAt;
  final Value<bool> isRead;
  final Value<bool> isDismissed;
  final Value<String?> dataJson;
  const InsightsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.icon = const Value.absent(),
    this.category = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isDismissed = const Value.absent(),
    this.dataJson = const Value.absent(),
  });
  InsightsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String title,
    this.subtitle = const Value.absent(),
    this.icon = const Value.absent(),
    this.category = const Value.absent(),
    required int generatedAt,
    this.expiresAt = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isDismissed = const Value.absent(),
    this.dataJson = const Value.absent(),
  }) : type = Value(type),
       title = Value(title),
       generatedAt = Value(generatedAt);
  static Insertable<Insight> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<String>? icon,
    Expression<String>? category,
    Expression<int>? generatedAt,
    Expression<int>? expiresAt,
    Expression<bool>? isRead,
    Expression<bool>? isDismissed,
    Expression<String>? dataJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (icon != null) 'icon': icon,
      if (category != null) 'category': category,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (isRead != null) 'is_read': isRead,
      if (isDismissed != null) 'is_dismissed': isDismissed,
      if (dataJson != null) 'data_json': dataJson,
    });
  }

  InsightsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? title,
    Value<String?>? subtitle,
    Value<String?>? icon,
    Value<String?>? category,
    Value<int>? generatedAt,
    Value<int?>? expiresAt,
    Value<bool>? isRead,
    Value<bool>? isDismissed,
    Value<String?>? dataJson,
  }) {
    return InsightsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      generatedAt: generatedAt ?? this.generatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isRead: isRead ?? this.isRead,
      isDismissed: isDismissed ?? this.isDismissed,
      dataJson: dataJson ?? this.dataJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<int>(generatedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<int>(expiresAt.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (isDismissed.present) {
      map['is_dismissed'] = Variable<bool>(isDismissed.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InsightsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('icon: $icon, ')
          ..write('category: $category, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('isRead: $isRead, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('dataJson: $dataJson')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isUserMeta = const VerificationMeta('isUser');
  @override
  late final GeneratedColumn<bool> isUser = GeneratedColumn<bool>(
    'is_user',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_user" IN (0, 1))',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextJsonMeta = const VerificationMeta(
    'contextJson',
  );
  @override
  late final GeneratedColumn<String> contextJson = GeneratedColumn<String>(
    'context_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    isUser,
    timestamp,
    contextJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_user')) {
      context.handle(
        _isUserMeta,
        isUser.isAcceptableOrUnknown(data['is_user']!, _isUserMeta),
      );
    } else if (isInserting) {
      context.missing(_isUserMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('context_json')) {
      context.handle(
        _contextJsonMeta,
        contextJson.isAcceptableOrUnknown(
          data['context_json']!,
          _contextJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      isUser: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_user'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      contextJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_json'],
      ),
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessage extends DataClass implements Insertable<ChatMessage> {
  final int id;
  final String content;
  final bool isUser;
  final int timestamp;
  final String? contextJson;
  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.contextJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['is_user'] = Variable<bool>(isUser);
    map['timestamp'] = Variable<int>(timestamp);
    if (!nullToAbsent || contextJson != null) {
      map['context_json'] = Variable<String>(contextJson);
    }
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      content: Value(content),
      isUser: Value(isUser),
      timestamp: Value(timestamp),
      contextJson: contextJson == null && nullToAbsent
          ? const Value.absent()
          : Value(contextJson),
    );
  }

  factory ChatMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessage(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      isUser: serializer.fromJson<bool>(json['isUser']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      contextJson: serializer.fromJson<String?>(json['contextJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'isUser': serializer.toJson<bool>(isUser),
      'timestamp': serializer.toJson<int>(timestamp),
      'contextJson': serializer.toJson<String?>(contextJson),
    };
  }

  ChatMessage copyWith({
    int? id,
    String? content,
    bool? isUser,
    int? timestamp,
    Value<String?> contextJson = const Value.absent(),
  }) => ChatMessage(
    id: id ?? this.id,
    content: content ?? this.content,
    isUser: isUser ?? this.isUser,
    timestamp: timestamp ?? this.timestamp,
    contextJson: contextJson.present ? contextJson.value : this.contextJson,
  );
  ChatMessage copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessage(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      isUser: data.isUser.present ? data.isUser.value : this.isUser,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      contextJson: data.contextJson.present
          ? data.contextJson.value
          : this.contextJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessage(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('isUser: $isUser, ')
          ..write('timestamp: $timestamp, ')
          ..write('contextJson: $contextJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, isUser, timestamp, contextJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          other.id == this.id &&
          other.content == this.content &&
          other.isUser == this.isUser &&
          other.timestamp == this.timestamp &&
          other.contextJson == this.contextJson);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessage> {
  final Value<int> id;
  final Value<String> content;
  final Value<bool> isUser;
  final Value<int> timestamp;
  final Value<String?> contextJson;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.isUser = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.contextJson = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    required bool isUser,
    required int timestamp,
    this.contextJson = const Value.absent(),
  }) : content = Value(content),
       isUser = Value(isUser),
       timestamp = Value(timestamp);
  static Insertable<ChatMessage> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<bool>? isUser,
    Expression<int>? timestamp,
    Expression<String>? contextJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (isUser != null) 'is_user': isUser,
      if (timestamp != null) 'timestamp': timestamp,
      if (contextJson != null) 'context_json': contextJson,
    });
  }

  ChatMessagesCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<bool>? isUser,
    Value<int>? timestamp,
    Value<String?>? contextJson,
  }) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      contextJson: contextJson ?? this.contextJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isUser.present) {
      map['is_user'] = Variable<bool>(isUser.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (contextJson.present) {
      map['context_json'] = Variable<String>(contextJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('isUser: $isUser, ')
          ..write('timestamp: $timestamp, ')
          ..write('contextJson: $contextJson')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountNameMeta = const VerificationMeta(
    'accountName',
  );
  @override
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
    'account_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _institutionIdMeta = const VerificationMeta(
    'institutionId',
  );
  @override
  late final GeneratedColumn<String> institutionId = GeneratedColumn<String>(
    'institution_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _institutionNameMeta = const VerificationMeta(
    'institutionName',
  );
  @override
  late final GeneratedColumn<String> institutionName = GeneratedColumn<String>(
    'institution_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maskedNumberMeta = const VerificationMeta(
    'maskedNumber',
  );
  @override
  late final GeneratedColumn<String> maskedNumber = GeneratedColumn<String>(
    'masked_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _isPrimaryMeta = const VerificationMeta(
    'isPrimary',
  );
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
    'is_primary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_primary" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountName,
    institutionId,
    institutionName,
    maskedNumber,
    accountType,
    balance,
    currency,
    isPrimary,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_name')) {
      context.handle(
        _accountNameMeta,
        accountName.isAcceptableOrUnknown(
          data['account_name']!,
          _accountNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountNameMeta);
    }
    if (data.containsKey('institution_id')) {
      context.handle(
        _institutionIdMeta,
        institutionId.isAcceptableOrUnknown(
          data['institution_id']!,
          _institutionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_institutionIdMeta);
    }
    if (data.containsKey('institution_name')) {
      context.handle(
        _institutionNameMeta,
        institutionName.isAcceptableOrUnknown(
          data['institution_name']!,
          _institutionNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_institutionNameMeta);
    }
    if (data.containsKey('masked_number')) {
      context.handle(
        _maskedNumberMeta,
        maskedNumber.isAcceptableOrUnknown(
          data['masked_number']!,
          _maskedNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maskedNumberMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountTypeMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('is_primary')) {
      context.handle(
        _isPrimaryMeta,
        isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_name'],
      )!,
      institutionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution_id'],
      )!,
      institutionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution_name'],
      )!,
      maskedNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}masked_number'],
      )!,
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      isPrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_primary'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final String id;
  final String accountName;
  final String institutionId;
  final String institutionName;
  final String maskedNumber;
  final String accountType;
  final double balance;
  final String currency;
  final bool isPrimary;
  final int createdAt;
  final int updatedAt;
  const Account({
    required this.id,
    required this.accountName,
    required this.institutionId,
    required this.institutionName,
    required this.maskedNumber,
    required this.accountType,
    required this.balance,
    required this.currency,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_name'] = Variable<String>(accountName);
    map['institution_id'] = Variable<String>(institutionId);
    map['institution_name'] = Variable<String>(institutionName);
    map['masked_number'] = Variable<String>(maskedNumber);
    map['account_type'] = Variable<String>(accountType);
    map['balance'] = Variable<double>(balance);
    map['currency'] = Variable<String>(currency);
    map['is_primary'] = Variable<bool>(isPrimary);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      accountName: Value(accountName),
      institutionId: Value(institutionId),
      institutionName: Value(institutionName),
      maskedNumber: Value(maskedNumber),
      accountType: Value(accountType),
      balance: Value(balance),
      currency: Value(currency),
      isPrimary: Value(isPrimary),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      accountName: serializer.fromJson<String>(json['accountName']),
      institutionId: serializer.fromJson<String>(json['institutionId']),
      institutionName: serializer.fromJson<String>(json['institutionName']),
      maskedNumber: serializer.fromJson<String>(json['maskedNumber']),
      accountType: serializer.fromJson<String>(json['accountType']),
      balance: serializer.fromJson<double>(json['balance']),
      currency: serializer.fromJson<String>(json['currency']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountName': serializer.toJson<String>(accountName),
      'institutionId': serializer.toJson<String>(institutionId),
      'institutionName': serializer.toJson<String>(institutionName),
      'maskedNumber': serializer.toJson<String>(maskedNumber),
      'accountType': serializer.toJson<String>(accountType),
      'balance': serializer.toJson<double>(balance),
      'currency': serializer.toJson<String>(currency),
      'isPrimary': serializer.toJson<bool>(isPrimary),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Account copyWith({
    String? id,
    String? accountName,
    String? institutionId,
    String? institutionName,
    String? maskedNumber,
    String? accountType,
    double? balance,
    String? currency,
    bool? isPrimary,
    int? createdAt,
    int? updatedAt,
  }) => Account(
    id: id ?? this.id,
    accountName: accountName ?? this.accountName,
    institutionId: institutionId ?? this.institutionId,
    institutionName: institutionName ?? this.institutionName,
    maskedNumber: maskedNumber ?? this.maskedNumber,
    accountType: accountType ?? this.accountType,
    balance: balance ?? this.balance,
    currency: currency ?? this.currency,
    isPrimary: isPrimary ?? this.isPrimary,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      accountName: data.accountName.present
          ? data.accountName.value
          : this.accountName,
      institutionId: data.institutionId.present
          ? data.institutionId.value
          : this.institutionId,
      institutionName: data.institutionName.present
          ? data.institutionName.value
          : this.institutionName,
      maskedNumber: data.maskedNumber.present
          ? data.maskedNumber.value
          : this.maskedNumber,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      balance: data.balance.present ? data.balance.value : this.balance,
      currency: data.currency.present ? data.currency.value : this.currency,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('accountName: $accountName, ')
          ..write('institutionId: $institutionId, ')
          ..write('institutionName: $institutionName, ')
          ..write('maskedNumber: $maskedNumber, ')
          ..write('accountType: $accountType, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountName,
    institutionId,
    institutionName,
    maskedNumber,
    accountType,
    balance,
    currency,
    isPrimary,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.accountName == this.accountName &&
          other.institutionId == this.institutionId &&
          other.institutionName == this.institutionName &&
          other.maskedNumber == this.maskedNumber &&
          other.accountType == this.accountType &&
          other.balance == this.balance &&
          other.currency == this.currency &&
          other.isPrimary == this.isPrimary &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String> accountName;
  final Value<String> institutionId;
  final Value<String> institutionName;
  final Value<String> maskedNumber;
  final Value<String> accountType;
  final Value<double> balance;
  final Value<String> currency;
  final Value<bool> isPrimary;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.accountName = const Value.absent(),
    this.institutionId = const Value.absent(),
    this.institutionName = const Value.absent(),
    this.maskedNumber = const Value.absent(),
    this.accountType = const Value.absent(),
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String accountName,
    required String institutionId,
    required String institutionName,
    required String maskedNumber,
    required String accountType,
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
    this.isPrimary = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountName = Value(accountName),
       institutionId = Value(institutionId),
       institutionName = Value(institutionName),
       maskedNumber = Value(maskedNumber),
       accountType = Value(accountType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? accountName,
    Expression<String>? institutionId,
    Expression<String>? institutionName,
    Expression<String>? maskedNumber,
    Expression<String>? accountType,
    Expression<double>? balance,
    Expression<String>? currency,
    Expression<bool>? isPrimary,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountName != null) 'account_name': accountName,
      if (institutionId != null) 'institution_id': institutionId,
      if (institutionName != null) 'institution_name': institutionName,
      if (maskedNumber != null) 'masked_number': maskedNumber,
      if (accountType != null) 'account_type': accountType,
      if (balance != null) 'balance': balance,
      if (currency != null) 'currency': currency,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountName,
    Value<String>? institutionId,
    Value<String>? institutionName,
    Value<String>? maskedNumber,
    Value<String>? accountType,
    Value<double>? balance,
    Value<String>? currency,
    Value<bool>? isPrimary,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      accountName: accountName ?? this.accountName,
      institutionId: institutionId ?? this.institutionId,
      institutionName: institutionName ?? this.institutionName,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      accountType: accountType ?? this.accountType,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (institutionId.present) {
      map['institution_id'] = Variable<String>(institutionId.value);
    }
    if (institutionName.present) {
      map['institution_name'] = Variable<String>(institutionName.value);
    }
    if (maskedNumber.present) {
      map['masked_number'] = Variable<String>(maskedNumber.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('accountName: $accountName, ')
          ..write('institutionId: $institutionId, ')
          ..write('institutionName: $institutionName, ')
          ..write('maskedNumber: $maskedNumber, ')
          ..write('accountType: $accountType, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreferencesTable extends Preferences
    with TableInfo<$PreferencesTable, Preference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Preference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Preference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preference(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PreferencesTable createAlias(String alias) {
    return $PreferencesTable(attachedDatabase, alias);
  }
}

class Preference extends DataClass implements Insertable<Preference> {
  final String key;
  final String value;
  final int updatedAt;
  const Preference({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory Preference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preference(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Preference copyWith({String? key, String? value, int? updatedAt}) =>
      Preference(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Preference copyWithCompanion(PreferencesCompanion data) {
    return Preference(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preference(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preference &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class PreferencesCompanion extends UpdateCompanion<Preference> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const PreferencesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreferencesCompanion.insert({
    required String key,
    required String value,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<Preference> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreferencesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return PreferencesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $UserResponsesTable userResponses = $UserResponsesTable(this);
  late final $CustomCategoriesTable customCategories = $CustomCategoriesTable(
    this,
  );
  late final $MerchantsTable merchants = $MerchantsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $InsightsTable insights = $InsightsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $PreferencesTable preferences = $PreferencesTable(this);
  late final TransactionDao transactionDao = TransactionDao(
    this as AppDatabase,
  );
  late final UserResponseDao userResponseDao = UserResponseDao(
    this as AppDatabase,
  );
  late final CustomCategoryDao customCategoryDao = CustomCategoryDao(
    this as AppDatabase,
  );
  late final MerchantDao merchantDao = MerchantDao(this as AppDatabase);
  late final BudgetDao budgetDao = BudgetDao(this as AppDatabase);
  late final InsightDao insightDao = InsightDao(this as AppDatabase);
  late final ChatDao chatDao = ChatDao(this as AppDatabase);
  late final PreferenceDao preferenceDao = PreferenceDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    transactions,
    userResponses,
    customCategories,
    merchants,
    budgets,
    insights,
    chatMessages,
    accounts,
    preferences,
  ];
}

typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      Value<String?> fingerprint,
      required double amount,
      Value<String> currency,
      required int timestamp,
      required int detectedAt,
      Value<String?> rawDate,
      Value<String?> rawTime,
      required String source,
      required String rawText,
      Value<String?> accountId,
      Value<String?> accountLastDigits,
      Value<String?> rawMerchantId,
      Value<String?> normalizedMerchantId,
      Value<String?> merchantName,
      Value<String?> category,
      Value<bool> isCustomCategory,
      Value<String?> subcategory,
      required String type,
      Value<bool> isCategorized,
      Value<bool> isParsedByAi,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String?> fingerprint,
      Value<double> amount,
      Value<String> currency,
      Value<int> timestamp,
      Value<int> detectedAt,
      Value<String?> rawDate,
      Value<String?> rawTime,
      Value<String> source,
      Value<String> rawText,
      Value<String?> accountId,
      Value<String?> accountLastDigits,
      Value<String?> rawMerchantId,
      Value<String?> normalizedMerchantId,
      Value<String?> merchantName,
      Value<String?> category,
      Value<bool> isCustomCategory,
      Value<String?> subcategory,
      Value<String> type,
      Value<bool> isCategorized,
      Value<bool> isParsedByAi,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserResponsesTable, List<UserResponse>>
  _userResponsesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userResponses,
    aliasName: $_aliasNameGenerator(
      db.transactions.id,
      db.userResponses.transactionId,
    ),
  );

  $$UserResponsesTableProcessedTableManager get userResponsesRefs {
    final manager = $$UserResponsesTableTableManager(
      $_db,
      $_db.userResponses,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_userResponsesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawDate => $composableBuilder(
    column: $table.rawDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawTime => $composableBuilder(
    column: $table.rawTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountLastDigits => $composableBuilder(
    column: $table.accountLastDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawMerchantId => $composableBuilder(
    column: $table.rawMerchantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedMerchantId => $composableBuilder(
    column: $table.normalizedMerchantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustomCategory => $composableBuilder(
    column: $table.isCustomCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCategorized => $composableBuilder(
    column: $table.isCategorized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isParsedByAi => $composableBuilder(
    column: $table.isParsedByAi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userResponsesRefs(
    Expression<bool> Function($$UserResponsesTableFilterComposer f) f,
  ) {
    final $$UserResponsesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userResponses,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserResponsesTableFilterComposer(
            $db: $db,
            $table: $db.userResponses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawDate => $composableBuilder(
    column: $table.rawDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawTime => $composableBuilder(
    column: $table.rawTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountLastDigits => $composableBuilder(
    column: $table.accountLastDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawMerchantId => $composableBuilder(
    column: $table.rawMerchantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedMerchantId => $composableBuilder(
    column: $table.normalizedMerchantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustomCategory => $composableBuilder(
    column: $table.isCustomCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCategorized => $composableBuilder(
    column: $table.isCategorized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isParsedByAi => $composableBuilder(
    column: $table.isParsedByAi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawDate =>
      $composableBuilder(column: $table.rawDate, builder: (column) => column);

  GeneratedColumn<String> get rawTime =>
      $composableBuilder(column: $table.rawTime, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get accountLastDigits => $composableBuilder(
    column: $table.accountLastDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawMerchantId => $composableBuilder(
    column: $table.rawMerchantId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get normalizedMerchantId => $composableBuilder(
    column: $table.normalizedMerchantId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isCustomCategory => $composableBuilder(
    column: $table.isCustomCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isCategorized => $composableBuilder(
    column: $table.isCategorized,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isParsedByAi => $composableBuilder(
    column: $table.isParsedByAi,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> userResponsesRefs<T extends Object>(
    Expression<T> Function($$UserResponsesTableAnnotationComposer a) f,
  ) {
    final $$UserResponsesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userResponses,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserResponsesTableAnnotationComposer(
            $db: $db,
            $table: $db.userResponses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({bool userResponsesRefs})
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> fingerprint = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<int> detectedAt = const Value.absent(),
                Value<String?> rawDate = const Value.absent(),
                Value<String?> rawTime = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> rawText = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String?> accountLastDigits = const Value.absent(),
                Value<String?> rawMerchantId = const Value.absent(),
                Value<String?> normalizedMerchantId = const Value.absent(),
                Value<String?> merchantName = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<bool> isCustomCategory = const Value.absent(),
                Value<String?> subcategory = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> isCategorized = const Value.absent(),
                Value<bool> isParsedByAi = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                fingerprint: fingerprint,
                amount: amount,
                currency: currency,
                timestamp: timestamp,
                detectedAt: detectedAt,
                rawDate: rawDate,
                rawTime: rawTime,
                source: source,
                rawText: rawText,
                accountId: accountId,
                accountLastDigits: accountLastDigits,
                rawMerchantId: rawMerchantId,
                normalizedMerchantId: normalizedMerchantId,
                merchantName: merchantName,
                category: category,
                isCustomCategory: isCustomCategory,
                subcategory: subcategory,
                type: type,
                isCategorized: isCategorized,
                isParsedByAi: isParsedByAi,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> fingerprint = const Value.absent(),
                required double amount,
                Value<String> currency = const Value.absent(),
                required int timestamp,
                required int detectedAt,
                Value<String?> rawDate = const Value.absent(),
                Value<String?> rawTime = const Value.absent(),
                required String source,
                required String rawText,
                Value<String?> accountId = const Value.absent(),
                Value<String?> accountLastDigits = const Value.absent(),
                Value<String?> rawMerchantId = const Value.absent(),
                Value<String?> normalizedMerchantId = const Value.absent(),
                Value<String?> merchantName = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<bool> isCustomCategory = const Value.absent(),
                Value<String?> subcategory = const Value.absent(),
                required String type,
                Value<bool> isCategorized = const Value.absent(),
                Value<bool> isParsedByAi = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                fingerprint: fingerprint,
                amount: amount,
                currency: currency,
                timestamp: timestamp,
                detectedAt: detectedAt,
                rawDate: rawDate,
                rawTime: rawTime,
                source: source,
                rawText: rawText,
                accountId: accountId,
                accountLastDigits: accountLastDigits,
                rawMerchantId: rawMerchantId,
                normalizedMerchantId: normalizedMerchantId,
                merchantName: merchantName,
                category: category,
                isCustomCategory: isCustomCategory,
                subcategory: subcategory,
                type: type,
                isCategorized: isCategorized,
                isParsedByAi: isParsedByAi,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userResponsesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (userResponsesRefs) db.userResponses,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userResponsesRefs)
                    await $_getPrefetchedData<
                      Transaction,
                      $TransactionsTable,
                      UserResponse
                    >(
                      currentTable: table,
                      referencedTable: $$TransactionsTableReferences
                          ._userResponsesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TransactionsTableReferences(
                            db,
                            table,
                            p0,
                          ).userResponsesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.transactionId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({bool userResponsesRefs})
    >;
typedef $$UserResponsesTableCreateCompanionBuilder =
    UserResponsesCompanion Function({
      Value<int> id,
      required String transactionId,
      Value<String?> aiSuggestions,
      required String inputMethod,
      Value<String?> rawInput,
      Value<String?> voiceTranscript,
      Value<double?> voiceConfidence,
      Value<String?> geminiInterpretation,
      Value<String?> geminiCategory,
      Value<String?> geminiSubcategory,
      Value<double?> geminiConfidence,
      Value<String?> geminiReasoning,
      required String finalCategory,
      Value<bool> isCustomCategory,
      Value<bool> userConfirmed,
      Value<String?> userCorrection,
      Value<String?> merchantAtTime,
      Value<double?> amountAtTime,
      Value<int?> responseTimeMs,
      Value<int?> interpretedAt,
      Value<int?> confirmedAt,
      required int createdAt,
    });
typedef $$UserResponsesTableUpdateCompanionBuilder =
    UserResponsesCompanion Function({
      Value<int> id,
      Value<String> transactionId,
      Value<String?> aiSuggestions,
      Value<String> inputMethod,
      Value<String?> rawInput,
      Value<String?> voiceTranscript,
      Value<double?> voiceConfidence,
      Value<String?> geminiInterpretation,
      Value<String?> geminiCategory,
      Value<String?> geminiSubcategory,
      Value<double?> geminiConfidence,
      Value<String?> geminiReasoning,
      Value<String> finalCategory,
      Value<bool> isCustomCategory,
      Value<bool> userConfirmed,
      Value<String?> userCorrection,
      Value<String?> merchantAtTime,
      Value<double?> amountAtTime,
      Value<int?> responseTimeMs,
      Value<int?> interpretedAt,
      Value<int?> confirmedAt,
      Value<int> createdAt,
    });

final class $$UserResponsesTableReferences
    extends BaseReferences<_$AppDatabase, $UserResponsesTable, UserResponse> {
  $$UserResponsesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias(
        $_aliasNameGenerator(
          db.userResponses.transactionId,
          db.transactions.id,
        ),
      );

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<String>('transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserResponsesTableFilterComposer
    extends Composer<_$AppDatabase, $UserResponsesTable> {
  $$UserResponsesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiSuggestions => $composableBuilder(
    column: $table.aiSuggestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputMethod => $composableBuilder(
    column: $table.inputMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawInput => $composableBuilder(
    column: $table.rawInput,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voiceTranscript => $composableBuilder(
    column: $table.voiceTranscript,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get voiceConfidence => $composableBuilder(
    column: $table.voiceConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geminiInterpretation => $composableBuilder(
    column: $table.geminiInterpretation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geminiCategory => $composableBuilder(
    column: $table.geminiCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geminiSubcategory => $composableBuilder(
    column: $table.geminiSubcategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get geminiConfidence => $composableBuilder(
    column: $table.geminiConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geminiReasoning => $composableBuilder(
    column: $table.geminiReasoning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get finalCategory => $composableBuilder(
    column: $table.finalCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustomCategory => $composableBuilder(
    column: $table.isCustomCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get userConfirmed => $composableBuilder(
    column: $table.userConfirmed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userCorrection => $composableBuilder(
    column: $table.userCorrection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantAtTime => $composableBuilder(
    column: $table.merchantAtTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountAtTime => $composableBuilder(
    column: $table.amountAtTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interpretedAt => $composableBuilder(
    column: $table.interpretedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserResponsesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserResponsesTable> {
  $$UserResponsesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiSuggestions => $composableBuilder(
    column: $table.aiSuggestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputMethod => $composableBuilder(
    column: $table.inputMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawInput => $composableBuilder(
    column: $table.rawInput,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voiceTranscript => $composableBuilder(
    column: $table.voiceTranscript,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get voiceConfidence => $composableBuilder(
    column: $table.voiceConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geminiInterpretation => $composableBuilder(
    column: $table.geminiInterpretation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geminiCategory => $composableBuilder(
    column: $table.geminiCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geminiSubcategory => $composableBuilder(
    column: $table.geminiSubcategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get geminiConfidence => $composableBuilder(
    column: $table.geminiConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geminiReasoning => $composableBuilder(
    column: $table.geminiReasoning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finalCategory => $composableBuilder(
    column: $table.finalCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustomCategory => $composableBuilder(
    column: $table.isCustomCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get userConfirmed => $composableBuilder(
    column: $table.userConfirmed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userCorrection => $composableBuilder(
    column: $table.userCorrection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantAtTime => $composableBuilder(
    column: $table.merchantAtTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountAtTime => $composableBuilder(
    column: $table.amountAtTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interpretedAt => $composableBuilder(
    column: $table.interpretedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserResponsesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserResponsesTable> {
  $$UserResponsesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get aiSuggestions => $composableBuilder(
    column: $table.aiSuggestions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get inputMethod => $composableBuilder(
    column: $table.inputMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawInput =>
      $composableBuilder(column: $table.rawInput, builder: (column) => column);

  GeneratedColumn<String> get voiceTranscript => $composableBuilder(
    column: $table.voiceTranscript,
    builder: (column) => column,
  );

  GeneratedColumn<double> get voiceConfidence => $composableBuilder(
    column: $table.voiceConfidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get geminiInterpretation => $composableBuilder(
    column: $table.geminiInterpretation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get geminiCategory => $composableBuilder(
    column: $table.geminiCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get geminiSubcategory => $composableBuilder(
    column: $table.geminiSubcategory,
    builder: (column) => column,
  );

  GeneratedColumn<double> get geminiConfidence => $composableBuilder(
    column: $table.geminiConfidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get geminiReasoning => $composableBuilder(
    column: $table.geminiReasoning,
    builder: (column) => column,
  );

  GeneratedColumn<String> get finalCategory => $composableBuilder(
    column: $table.finalCategory,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCustomCategory => $composableBuilder(
    column: $table.isCustomCategory,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get userConfirmed => $composableBuilder(
    column: $table.userConfirmed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userCorrection => $composableBuilder(
    column: $table.userCorrection,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchantAtTime => $composableBuilder(
    column: $table.merchantAtTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountAtTime => $composableBuilder(
    column: $table.amountAtTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interpretedAt => $composableBuilder(
    column: $table.interpretedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserResponsesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserResponsesTable,
          UserResponse,
          $$UserResponsesTableFilterComposer,
          $$UserResponsesTableOrderingComposer,
          $$UserResponsesTableAnnotationComposer,
          $$UserResponsesTableCreateCompanionBuilder,
          $$UserResponsesTableUpdateCompanionBuilder,
          (UserResponse, $$UserResponsesTableReferences),
          UserResponse,
          PrefetchHooks Function({bool transactionId})
        > {
  $$UserResponsesTableTableManager(_$AppDatabase db, $UserResponsesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserResponsesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserResponsesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserResponsesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String?> aiSuggestions = const Value.absent(),
                Value<String> inputMethod = const Value.absent(),
                Value<String?> rawInput = const Value.absent(),
                Value<String?> voiceTranscript = const Value.absent(),
                Value<double?> voiceConfidence = const Value.absent(),
                Value<String?> geminiInterpretation = const Value.absent(),
                Value<String?> geminiCategory = const Value.absent(),
                Value<String?> geminiSubcategory = const Value.absent(),
                Value<double?> geminiConfidence = const Value.absent(),
                Value<String?> geminiReasoning = const Value.absent(),
                Value<String> finalCategory = const Value.absent(),
                Value<bool> isCustomCategory = const Value.absent(),
                Value<bool> userConfirmed = const Value.absent(),
                Value<String?> userCorrection = const Value.absent(),
                Value<String?> merchantAtTime = const Value.absent(),
                Value<double?> amountAtTime = const Value.absent(),
                Value<int?> responseTimeMs = const Value.absent(),
                Value<int?> interpretedAt = const Value.absent(),
                Value<int?> confirmedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => UserResponsesCompanion(
                id: id,
                transactionId: transactionId,
                aiSuggestions: aiSuggestions,
                inputMethod: inputMethod,
                rawInput: rawInput,
                voiceTranscript: voiceTranscript,
                voiceConfidence: voiceConfidence,
                geminiInterpretation: geminiInterpretation,
                geminiCategory: geminiCategory,
                geminiSubcategory: geminiSubcategory,
                geminiConfidence: geminiConfidence,
                geminiReasoning: geminiReasoning,
                finalCategory: finalCategory,
                isCustomCategory: isCustomCategory,
                userConfirmed: userConfirmed,
                userCorrection: userCorrection,
                merchantAtTime: merchantAtTime,
                amountAtTime: amountAtTime,
                responseTimeMs: responseTimeMs,
                interpretedAt: interpretedAt,
                confirmedAt: confirmedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String transactionId,
                Value<String?> aiSuggestions = const Value.absent(),
                required String inputMethod,
                Value<String?> rawInput = const Value.absent(),
                Value<String?> voiceTranscript = const Value.absent(),
                Value<double?> voiceConfidence = const Value.absent(),
                Value<String?> geminiInterpretation = const Value.absent(),
                Value<String?> geminiCategory = const Value.absent(),
                Value<String?> geminiSubcategory = const Value.absent(),
                Value<double?> geminiConfidence = const Value.absent(),
                Value<String?> geminiReasoning = const Value.absent(),
                required String finalCategory,
                Value<bool> isCustomCategory = const Value.absent(),
                Value<bool> userConfirmed = const Value.absent(),
                Value<String?> userCorrection = const Value.absent(),
                Value<String?> merchantAtTime = const Value.absent(),
                Value<double?> amountAtTime = const Value.absent(),
                Value<int?> responseTimeMs = const Value.absent(),
                Value<int?> interpretedAt = const Value.absent(),
                Value<int?> confirmedAt = const Value.absent(),
                required int createdAt,
              }) => UserResponsesCompanion.insert(
                id: id,
                transactionId: transactionId,
                aiSuggestions: aiSuggestions,
                inputMethod: inputMethod,
                rawInput: rawInput,
                voiceTranscript: voiceTranscript,
                voiceConfidence: voiceConfidence,
                geminiInterpretation: geminiInterpretation,
                geminiCategory: geminiCategory,
                geminiSubcategory: geminiSubcategory,
                geminiConfidence: geminiConfidence,
                geminiReasoning: geminiReasoning,
                finalCategory: finalCategory,
                isCustomCategory: isCustomCategory,
                userConfirmed: userConfirmed,
                userCorrection: userCorrection,
                merchantAtTime: merchantAtTime,
                amountAtTime: amountAtTime,
                responseTimeMs: responseTimeMs,
                interpretedAt: interpretedAt,
                confirmedAt: confirmedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserResponsesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (transactionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.transactionId,
                                referencedTable: $$UserResponsesTableReferences
                                    ._transactionIdTable(db),
                                referencedColumn: $$UserResponsesTableReferences
                                    ._transactionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserResponsesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserResponsesTable,
      UserResponse,
      $$UserResponsesTableFilterComposer,
      $$UserResponsesTableOrderingComposer,
      $$UserResponsesTableAnnotationComposer,
      $$UserResponsesTableCreateCompanionBuilder,
      $$UserResponsesTableUpdateCompanionBuilder,
      (UserResponse, $$UserResponsesTableReferences),
      UserResponse,
      PrefetchHooks Function({bool transactionId})
    >;
typedef $$CustomCategoriesTableCreateCompanionBuilder =
    CustomCategoriesCompanion Function({
      Value<int> id,
      required String name,
      required String displayName,
      Value<String?> emoji,
      Value<String?> color,
      Value<String?> description,
      Value<String?> learnedKeywords,
      Value<String?> learnedMerchants,
      Value<int> usageCount,
      Value<int?> lastUsedAt,
      Value<bool> isActive,
      required int createdAt,
      required int updatedAt,
    });
typedef $$CustomCategoriesTableUpdateCompanionBuilder =
    CustomCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> displayName,
      Value<String?> emoji,
      Value<String?> color,
      Value<String?> description,
      Value<String?> learnedKeywords,
      Value<String?> learnedMerchants,
      Value<int> usageCount,
      Value<int?> lastUsedAt,
      Value<bool> isActive,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$CustomCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomCategoriesTable> {
  $$CustomCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learnedKeywords => $composableBuilder(
    column: $table.learnedKeywords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learnedMerchants => $composableBuilder(
    column: $table.learnedMerchants,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomCategoriesTable> {
  $$CustomCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learnedKeywords => $composableBuilder(
    column: $table.learnedKeywords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learnedMerchants => $composableBuilder(
    column: $table.learnedMerchants,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomCategoriesTable> {
  $$CustomCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get learnedKeywords => $composableBuilder(
    column: $table.learnedKeywords,
    builder: (column) => column,
  );

  GeneratedColumn<String> get learnedMerchants => $composableBuilder(
    column: $table.learnedMerchants,
    builder: (column) => column,
  );

  GeneratedColumn<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CustomCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomCategoriesTable,
          CustomCategory,
          $$CustomCategoriesTableFilterComposer,
          $$CustomCategoriesTableOrderingComposer,
          $$CustomCategoriesTableAnnotationComposer,
          $$CustomCategoriesTableCreateCompanionBuilder,
          $$CustomCategoriesTableUpdateCompanionBuilder,
          (
            CustomCategory,
            BaseReferences<
              _$AppDatabase,
              $CustomCategoriesTable,
              CustomCategory
            >,
          ),
          CustomCategory,
          PrefetchHooks Function()
        > {
  $$CustomCategoriesTableTableManager(
    _$AppDatabase db,
    $CustomCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> emoji = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> learnedKeywords = const Value.absent(),
                Value<String?> learnedMerchants = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<int?> lastUsedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => CustomCategoriesCompanion(
                id: id,
                name: name,
                displayName: displayName,
                emoji: emoji,
                color: color,
                description: description,
                learnedKeywords: learnedKeywords,
                learnedMerchants: learnedMerchants,
                usageCount: usageCount,
                lastUsedAt: lastUsedAt,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String displayName,
                Value<String?> emoji = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> learnedKeywords = const Value.absent(),
                Value<String?> learnedMerchants = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<int?> lastUsedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => CustomCategoriesCompanion.insert(
                id: id,
                name: name,
                displayName: displayName,
                emoji: emoji,
                color: color,
                description: description,
                learnedKeywords: learnedKeywords,
                learnedMerchants: learnedMerchants,
                usageCount: usageCount,
                lastUsedAt: lastUsedAt,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomCategoriesTable,
      CustomCategory,
      $$CustomCategoriesTableFilterComposer,
      $$CustomCategoriesTableOrderingComposer,
      $$CustomCategoriesTableAnnotationComposer,
      $$CustomCategoriesTableCreateCompanionBuilder,
      $$CustomCategoriesTableUpdateCompanionBuilder,
      (
        CustomCategory,
        BaseReferences<_$AppDatabase, $CustomCategoriesTable, CustomCategory>,
      ),
      CustomCategory,
      PrefetchHooks Function()
    >;
typedef $$MerchantsTableCreateCompanionBuilder =
    MerchantsCompanion Function({
      required String id,
      required String rawId,
      Value<String?> category,
      Value<bool> isCustomCategory,
      Value<String?> friendlyName,
      Value<int> timesCategorized,
      Value<String?> lastCategoryCounts,
      Value<int> usageCount,
      Value<double> totalSpent,
      Value<int?> lastUsedAt,
      required int learnedAt,
      Value<int> rowid,
    });
typedef $$MerchantsTableUpdateCompanionBuilder =
    MerchantsCompanion Function({
      Value<String> id,
      Value<String> rawId,
      Value<String?> category,
      Value<bool> isCustomCategory,
      Value<String?> friendlyName,
      Value<int> timesCategorized,
      Value<String?> lastCategoryCounts,
      Value<int> usageCount,
      Value<double> totalSpent,
      Value<int?> lastUsedAt,
      Value<int> learnedAt,
      Value<int> rowid,
    });

class $$MerchantsTableFilterComposer
    extends Composer<_$AppDatabase, $MerchantsTable> {
  $$MerchantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawId => $composableBuilder(
    column: $table.rawId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustomCategory => $composableBuilder(
    column: $table.isCustomCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get friendlyName => $composableBuilder(
    column: $table.friendlyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesCategorized => $composableBuilder(
    column: $table.timesCategorized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastCategoryCounts => $composableBuilder(
    column: $table.lastCategoryCounts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalSpent => $composableBuilder(
    column: $table.totalSpent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get learnedAt => $composableBuilder(
    column: $table.learnedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MerchantsTableOrderingComposer
    extends Composer<_$AppDatabase, $MerchantsTable> {
  $$MerchantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawId => $composableBuilder(
    column: $table.rawId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustomCategory => $composableBuilder(
    column: $table.isCustomCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get friendlyName => $composableBuilder(
    column: $table.friendlyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesCategorized => $composableBuilder(
    column: $table.timesCategorized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastCategoryCounts => $composableBuilder(
    column: $table.lastCategoryCounts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalSpent => $composableBuilder(
    column: $table.totalSpent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get learnedAt => $composableBuilder(
    column: $table.learnedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MerchantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MerchantsTable> {
  $$MerchantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rawId =>
      $composableBuilder(column: $table.rawId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isCustomCategory => $composableBuilder(
    column: $table.isCustomCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get friendlyName => $composableBuilder(
    column: $table.friendlyName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesCategorized => $composableBuilder(
    column: $table.timesCategorized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastCategoryCounts => $composableBuilder(
    column: $table.lastCategoryCounts,
    builder: (column) => column,
  );

  GeneratedColumn<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalSpent => $composableBuilder(
    column: $table.totalSpent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get learnedAt =>
      $composableBuilder(column: $table.learnedAt, builder: (column) => column);
}

class $$MerchantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MerchantsTable,
          Merchant,
          $$MerchantsTableFilterComposer,
          $$MerchantsTableOrderingComposer,
          $$MerchantsTableAnnotationComposer,
          $$MerchantsTableCreateCompanionBuilder,
          $$MerchantsTableUpdateCompanionBuilder,
          (Merchant, BaseReferences<_$AppDatabase, $MerchantsTable, Merchant>),
          Merchant,
          PrefetchHooks Function()
        > {
  $$MerchantsTableTableManager(_$AppDatabase db, $MerchantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MerchantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MerchantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MerchantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rawId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<bool> isCustomCategory = const Value.absent(),
                Value<String?> friendlyName = const Value.absent(),
                Value<int> timesCategorized = const Value.absent(),
                Value<String?> lastCategoryCounts = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<double> totalSpent = const Value.absent(),
                Value<int?> lastUsedAt = const Value.absent(),
                Value<int> learnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MerchantsCompanion(
                id: id,
                rawId: rawId,
                category: category,
                isCustomCategory: isCustomCategory,
                friendlyName: friendlyName,
                timesCategorized: timesCategorized,
                lastCategoryCounts: lastCategoryCounts,
                usageCount: usageCount,
                totalSpent: totalSpent,
                lastUsedAt: lastUsedAt,
                learnedAt: learnedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rawId,
                Value<String?> category = const Value.absent(),
                Value<bool> isCustomCategory = const Value.absent(),
                Value<String?> friendlyName = const Value.absent(),
                Value<int> timesCategorized = const Value.absent(),
                Value<String?> lastCategoryCounts = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<double> totalSpent = const Value.absent(),
                Value<int?> lastUsedAt = const Value.absent(),
                required int learnedAt,
                Value<int> rowid = const Value.absent(),
              }) => MerchantsCompanion.insert(
                id: id,
                rawId: rawId,
                category: category,
                isCustomCategory: isCustomCategory,
                friendlyName: friendlyName,
                timesCategorized: timesCategorized,
                lastCategoryCounts: lastCategoryCounts,
                usageCount: usageCount,
                totalSpent: totalSpent,
                lastUsedAt: lastUsedAt,
                learnedAt: learnedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MerchantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MerchantsTable,
      Merchant,
      $$MerchantsTableFilterComposer,
      $$MerchantsTableOrderingComposer,
      $$MerchantsTableAnnotationComposer,
      $$MerchantsTableCreateCompanionBuilder,
      $$MerchantsTableUpdateCompanionBuilder,
      (Merchant, BaseReferences<_$AppDatabase, $MerchantsTable, Merchant>),
      Merchant,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      required String category,
      Value<bool> isCustomCategory,
      required String period,
      required double amount,
      required int createdAt,
      required int updatedAt,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<bool> isCustomCategory,
      Value<String> period,
      Value<double> amount,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustomCategory => $composableBuilder(
    column: $table.isCustomCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustomCategory => $composableBuilder(
    column: $table.isCustomCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isCustomCategory => $composableBuilder(
    column: $table.isCustomCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          Budget,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
          Budget,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> isCustomCategory = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                category: category,
                isCustomCategory: isCustomCategory,
                period: period,
                amount: amount,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String category,
                Value<bool> isCustomCategory = const Value.absent(),
                required String period,
                required double amount,
                required int createdAt,
                required int updatedAt,
              }) => BudgetsCompanion.insert(
                id: id,
                category: category,
                isCustomCategory: isCustomCategory,
                period: period,
                amount: amount,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      Budget,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
      Budget,
      PrefetchHooks Function()
    >;
typedef $$InsightsTableCreateCompanionBuilder =
    InsightsCompanion Function({
      Value<int> id,
      required String type,
      required String title,
      Value<String?> subtitle,
      Value<String?> icon,
      Value<String?> category,
      required int generatedAt,
      Value<int?> expiresAt,
      Value<bool> isRead,
      Value<bool> isDismissed,
      Value<String?> dataJson,
    });
typedef $$InsightsTableUpdateCompanionBuilder =
    InsightsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> title,
      Value<String?> subtitle,
      Value<String?> icon,
      Value<String?> category,
      Value<int> generatedAt,
      Value<int?> expiresAt,
      Value<bool> isRead,
      Value<bool> isDismissed,
      Value<String?> dataJson,
    });

class $$InsightsTableFilterComposer
    extends Composer<_$AppDatabase, $InsightsTable> {
  $$InsightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InsightsTableOrderingComposer
    extends Composer<_$AppDatabase, $InsightsTable> {
  $$InsightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InsightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InsightsTable> {
  $$InsightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);
}

class $$InsightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InsightsTable,
          Insight,
          $$InsightsTableFilterComposer,
          $$InsightsTableOrderingComposer,
          $$InsightsTableAnnotationComposer,
          $$InsightsTableCreateCompanionBuilder,
          $$InsightsTableUpdateCompanionBuilder,
          (Insight, BaseReferences<_$AppDatabase, $InsightsTable, Insight>),
          Insight,
          PrefetchHooks Function()
        > {
  $$InsightsTableTableManager(_$AppDatabase db, $InsightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InsightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InsightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InsightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<int> generatedAt = const Value.absent(),
                Value<int?> expiresAt = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
                Value<String?> dataJson = const Value.absent(),
              }) => InsightsCompanion(
                id: id,
                type: type,
                title: title,
                subtitle: subtitle,
                icon: icon,
                category: category,
                generatedAt: generatedAt,
                expiresAt: expiresAt,
                isRead: isRead,
                isDismissed: isDismissed,
                dataJson: dataJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required String title,
                Value<String?> subtitle = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> category = const Value.absent(),
                required int generatedAt,
                Value<int?> expiresAt = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
                Value<String?> dataJson = const Value.absent(),
              }) => InsightsCompanion.insert(
                id: id,
                type: type,
                title: title,
                subtitle: subtitle,
                icon: icon,
                category: category,
                generatedAt: generatedAt,
                expiresAt: expiresAt,
                isRead: isRead,
                isDismissed: isDismissed,
                dataJson: dataJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InsightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InsightsTable,
      Insight,
      $$InsightsTableFilterComposer,
      $$InsightsTableOrderingComposer,
      $$InsightsTableAnnotationComposer,
      $$InsightsTableCreateCompanionBuilder,
      $$InsightsTableUpdateCompanionBuilder,
      (Insight, BaseReferences<_$AppDatabase, $InsightsTable, Insight>),
      Insight,
      PrefetchHooks Function()
    >;
typedef $$ChatMessagesTableCreateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> id,
      required String content,
      required bool isUser,
      required int timestamp,
      Value<String?> contextJson,
    });
typedef $$ChatMessagesTableUpdateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<bool> isUser,
      Value<int> timestamp,
      Value<String?> contextJson,
    });

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUser => $composableBuilder(
    column: $table.isUser,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextJson => $composableBuilder(
    column: $table.contextJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUser => $composableBuilder(
    column: $table.isUser,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextJson => $composableBuilder(
    column: $table.contextJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isUser =>
      $composableBuilder(column: $table.isUser, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get contextJson => $composableBuilder(
    column: $table.contextJson,
    builder: (column) => column,
  );
}

class $$ChatMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMessagesTable,
          ChatMessage,
          $$ChatMessagesTableFilterComposer,
          $$ChatMessagesTableOrderingComposer,
          $$ChatMessagesTableAnnotationComposer,
          $$ChatMessagesTableCreateCompanionBuilder,
          $$ChatMessagesTableUpdateCompanionBuilder,
          (
            ChatMessage,
            BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>,
          ),
          ChatMessage,
          PrefetchHooks Function()
        > {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<bool> isUser = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<String?> contextJson = const Value.absent(),
              }) => ChatMessagesCompanion(
                id: id,
                content: content,
                isUser: isUser,
                timestamp: timestamp,
                contextJson: contextJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                required bool isUser,
                required int timestamp,
                Value<String?> contextJson = const Value.absent(),
              }) => ChatMessagesCompanion.insert(
                id: id,
                content: content,
                isUser: isUser,
                timestamp: timestamp,
                contextJson: contextJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMessagesTable,
      ChatMessage,
      $$ChatMessagesTableFilterComposer,
      $$ChatMessagesTableOrderingComposer,
      $$ChatMessagesTableAnnotationComposer,
      $$ChatMessagesTableCreateCompanionBuilder,
      $$ChatMessagesTableUpdateCompanionBuilder,
      (
        ChatMessage,
        BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>,
      ),
      ChatMessage,
      PrefetchHooks Function()
    >;
typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      required String id,
      required String accountName,
      required String institutionId,
      required String institutionName,
      required String maskedNumber,
      required String accountType,
      Value<double> balance,
      Value<String> currency,
      Value<bool> isPrimary,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<String> id,
      Value<String> accountName,
      Value<String> institutionId,
      Value<String> institutionName,
      Value<String> maskedNumber,
      Value<String> accountType,
      Value<double> balance,
      Value<String> currency,
      Value<bool> isPrimary,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institutionId => $composableBuilder(
    column: $table.institutionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get maskedNumber => $composableBuilder(
    column: $table.maskedNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institutionId => $composableBuilder(
    column: $table.institutionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maskedNumber => $composableBuilder(
    column: $table.maskedNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get institutionId => $composableBuilder(
    column: $table.institutionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get maskedNumber => $composableBuilder(
    column: $table.maskedNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
          Account,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountName = const Value.absent(),
                Value<String> institutionId = const Value.absent(),
                Value<String> institutionName = const Value.absent(),
                Value<String> maskedNumber = const Value.absent(),
                Value<String> accountType = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                accountName: accountName,
                institutionId: institutionId,
                institutionName: institutionName,
                maskedNumber: maskedNumber,
                accountType: accountType,
                balance: balance,
                currency: currency,
                isPrimary: isPrimary,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountName,
                required String institutionId,
                required String institutionName,
                required String maskedNumber,
                required String accountType,
                Value<double> balance = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                accountName: accountName,
                institutionId: institutionId,
                institutionName: institutionName,
                maskedNumber: maskedNumber,
                accountType: accountType,
                balance: balance,
                currency: currency,
                isPrimary: isPrimary,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
      Account,
      PrefetchHooks Function()
    >;
typedef $$PreferencesTableCreateCompanionBuilder =
    PreferencesCompanion Function({
      required String key,
      required String value,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$PreferencesTableUpdateCompanionBuilder =
    PreferencesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$PreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferencesTable,
          Preference,
          $$PreferencesTableFilterComposer,
          $$PreferencesTableOrderingComposer,
          $$PreferencesTableAnnotationComposer,
          $$PreferencesTableCreateCompanionBuilder,
          $$PreferencesTableUpdateCompanionBuilder,
          (
            Preference,
            BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
          ),
          Preference,
          PrefetchHooks Function()
        > {
  $$PreferencesTableTableManager(_$AppDatabase db, $PreferencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreferencesCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PreferencesCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferencesTable,
      Preference,
      $$PreferencesTableFilterComposer,
      $$PreferencesTableOrderingComposer,
      $$PreferencesTableAnnotationComposer,
      $$PreferencesTableCreateCompanionBuilder,
      $$PreferencesTableUpdateCompanionBuilder,
      (
        Preference,
        BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
      ),
      Preference,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$UserResponsesTableTableManager get userResponses =>
      $$UserResponsesTableTableManager(_db, _db.userResponses);
  $$CustomCategoriesTableTableManager get customCategories =>
      $$CustomCategoriesTableTableManager(_db, _db.customCategories);
  $$MerchantsTableTableManager get merchants =>
      $$MerchantsTableTableManager(_db, _db.merchants);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$InsightsTableTableManager get insights =>
      $$InsightsTableTableManager(_db, _db.insights);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
}
