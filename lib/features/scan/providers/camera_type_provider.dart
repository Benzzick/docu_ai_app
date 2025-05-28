import 'package:docu_ai_app/models/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cameraTypeProvider = StateProvider<CameraType>((ref) => CameraType.back);
