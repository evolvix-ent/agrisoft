import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para el índice de la navegación actual
final navigationIndexProvider = StateProvider<int>((ref) => 0);
