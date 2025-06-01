import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

class InitialState extends BaseState {
  const InitialState();
}

class LoadingState extends BaseState {
  final String? message; // Optional message for loading
  const LoadingState({this.message});

  @override
  List<Object?> get props => [message];
}

// Generic success state, can be extended if specific success data is needed
class SuccessState<T> extends BaseState {
  final T? data; // Optional data to pass on success
  final String? message;
  const SuccessState({this.data, this.message});

  @override
  List<Object?> get props => [data, message];
}

class ErrorState extends BaseState {
  final String message;
  final String? details; // Optional technical details for logging

  const ErrorState({required this.message, this.details});

  @override
  List<Object?> get props => [message, details];
}
