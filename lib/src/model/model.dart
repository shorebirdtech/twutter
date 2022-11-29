import 'package:shorebird/datastore.dart';

import 'flap.dart';
import 'user.dart';

var classInfoMap = {
  Flap: ClassInfo<Flap>('flaps', Flap.fromDbJson, (value) => value.toDbJson()),
  User: ClassInfo<User>('users', User.fromDbJson, (value) => value.toDbJson()),
};
