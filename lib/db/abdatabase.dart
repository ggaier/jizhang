import 'package:accountbook/vo/account_entity.dart';
import 'package:floor/floor.dart';

@Database(version: 1, entities: [PayAccount])
abstract class ABDataBase extends FloorDatabase {}
