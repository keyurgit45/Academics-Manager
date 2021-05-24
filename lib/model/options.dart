import 'package:hive/hive.dart';

part 'options.g.dart';

@HiveType(typeId: 0)
class Options extends HiveObject {
  @HiveField(0)
  List options;
}

@HiveType(typeId: 1)
class Subjects extends HiveObject {
  @HiveField(0)
  List myData;
}
