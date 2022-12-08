import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(0));

  void add(int c) => emit(HomeState(state.counter + c));
  void sub(int c) => emit(HomeState(state.counter - c));
}


@immutable
class HomeState {
  final int counter;

  const HomeState(this.counter); 
}