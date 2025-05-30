import 'package:docu_ai_app/models/enums.dart';
import 'package:docu_ai_app/shared/utils/formatters.dart';

Stream<String> dateModifiedStream(DateTime date, DateFormat format) async* {
  yield formatDateModified(date, format); // Initial value

  while (true) {
    await Future.delayed(const Duration(minutes: 1));
    yield formatDateModified(date, format);
  }
}
