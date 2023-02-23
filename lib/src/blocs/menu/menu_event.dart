part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class IndexMenuEvent extends MenuEvent {
  final int indexMenu;
  const IndexMenuEvent(this.indexMenu);
}
