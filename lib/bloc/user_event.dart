abstract class UserEvent {
  UserEvent([List event = const []]);
}

class GetUserEvent extends UserEvent {
  GetUserEvent() : super([]);
}
