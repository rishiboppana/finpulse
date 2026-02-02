// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_category_dao.dart';

// ignore_for_file: type=lint
mixin _$CustomCategoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $CustomCategoriesTable get customCategories =>
      attachedDatabase.customCategories;
  CustomCategoryDaoManager get managers => CustomCategoryDaoManager(this);
}

class CustomCategoryDaoManager {
  final _$CustomCategoryDaoMixin _db;
  CustomCategoryDaoManager(this._db);
  $$CustomCategoriesTableTableManager get customCategories =>
      $$CustomCategoriesTableTableManager(
        _db.attachedDatabase,
        _db.customCategories,
      );
}
