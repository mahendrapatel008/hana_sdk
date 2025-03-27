abstract class RefreshEvent {
  const RefreshEvent();
}

class RefreshFormEvent extends RefreshEvent {
  final String check;
  RefreshFormEvent({required this.check});
}
