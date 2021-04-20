import 'package:accountbook/db/bill_category_dao.dart';
import 'package:accountbook/db/pay_account_dao.dart';
import 'package:accountbook/vo/account_entity.dart';
import 'package:accountbook/vo/bill_category.dart';
import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'abdatabase.g.dart';

@Database(version: 2, entities: [PayAccount, BillCategory])
abstract class ABDataBase extends FloorDatabase {

  AccountDao get payAccountDao;

  BillCategoryDao get billCategoryDao;

}
