import 'package:accountbook/db/pay_account_dao.dart';
import 'package:accountbook/vo/account_entity.dart';
import 'package:floor/floor.dart';

part 'abdatabase.g.dart';

@Database(version: 1, entities: [PayAccount])
abstract class ABDataBase extends FloorDatabase {

  AccountDao get payAccountDao;

}
