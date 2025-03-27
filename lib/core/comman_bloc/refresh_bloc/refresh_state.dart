abstract class RefreshState {
  const RefreshState();
}

class RefreshInitialState extends RefreshState {}

class RefreshLoadingState extends RefreshState {}

class RefreshLoadedState extends RefreshState {
  String check;
  RefreshLoadedState({required this.check});
}
