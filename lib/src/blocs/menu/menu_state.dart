part of 'menu_bloc.dart';

class MenuState extends Equatable {
  final int indexMenu;
  const MenuState({
    this.indexMenu = 0,
  });

  MenuState copyWith(int? indexMenu) => MenuState(
        indexMenu: indexMenu ?? this.indexMenu,
      );
  @override
  List<Object> get props => [indexMenu];
}
