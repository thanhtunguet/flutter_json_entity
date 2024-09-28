part of 'push_notification_bloc.dart';

/// The base class for push notification states.
sealed class PushNotificationState extends Equatable {
  const PushNotificationState();

  @override
  List<Object> get props => [];
}

/// The initial state of the push notification BLoC.
final class PushNotificationInitial extends PushNotificationState {}
