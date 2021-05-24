import 'package:academics/model/options.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Options> getOptions() => Hive.box<Options>('options');
  static Box<Subjects> getSubjects() => Hive.box<Subjects>('subjects');
}
