//是否需要实现Equatable还需要再确认.
abstract class BaseBlocState {
  const BaseBlocState();
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
  String toString() {
    return '$runtimeType item $data';
  }
}

class ABUpdatedState<Item> extends ABSuccessState<Item> {
  ABUpdatedState([Item? item]) : super(item);
}

class ABFailureState extends BaseBlocState {
  final Exception? reason;

  ABFailureState([this.reason]);

  ABFailureState.cause(String cause) : reason = Exception(cause);
}

class ABCompleteState extends BaseBlocState {}

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

  bool isType<T>(T clz) {
    return this is T;
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
