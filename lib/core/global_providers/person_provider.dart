import 'package:docu_ai_app/models/person.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personProvider =
    StateNotifierProvider<PDFNotifier, Person?>((ref) => PDFNotifier());

class PDFNotifier extends StateNotifier<Person?> {
  PDFNotifier() : super(Person(name: 'Jack Robin', email: 'email'));



  
}
