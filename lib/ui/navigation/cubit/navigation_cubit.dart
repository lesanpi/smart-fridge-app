import 'package:bloc/bloc.dart';
part 'navigation_state.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  /// A description for yourCustomFunction
  void onChangeTap(int tab) => emit(tab);
}
