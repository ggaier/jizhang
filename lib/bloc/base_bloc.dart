import 'package:equatable/equatable.dart';

abstract class BaseBlocState extends Equatable {
  const BaseBlocState();

  @override
  List<Object?> get props => [];
}

class ABInitialState extends BaseBlocState {}

class ABInProgressState extends BaseBlocState {
  final int progress;

  ABInProgressState(this.progress);
}

class ABSuccessState<Item> extends BaseBlocState {
  final Item? data;

  ABSuccessState([this.data]);

  @override
  List<Object?> get props => [data];

  @override
  String toString() {
    return '$runtimeType item $data';
  }
}

class ABFailureState extends BaseBlocState {}

extension BlocStateExt on BaseBlocState {
  bool get isInitial {
    return this is ABInitialState;
  }

  bool get isFailure {
    return this is ABFailureState;
  }

  bool get isSuccess {
    return this is ABSuccessState;
  }

  bool get isLoading {
    return this is ABInProgressState;
  }

  int getProgress() {
    if (this.isSuccess) {
      return 100;
    }
    if (this.isFailure || this.isInitial) {
      return 0;
    }
    return this.isLoading ? (this as ABInProgressState).progress : 0;
  }

  Item? getData<Item>() {
    if (this.isSuccess) {
      var data = (this as ABSuccessState).data;
      return data is Item ? data : null;
    }
    return null;
  }
}
