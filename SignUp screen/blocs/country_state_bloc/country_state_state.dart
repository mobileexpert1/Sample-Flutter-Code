part of 'country_state_bloc.dart';

abstract class CountryStateState extends Equatable {
  const CountryStateState();
}

class CountryStateInitial extends CountryStateState {
  @override
  List<Object> get props => [];
}

class CountryStateLoading extends CountryStateState {
  @override
  List<Object> get props => [];
}
class CountryStateSaveSuccess extends CountryStateState {
  @override
  List<Object> get props => [];
}

class CountryStateLoaded extends CountryStateState {
  final List<CountryStateInfo> stateList;

  const CountryStateLoaded({required this.stateList});

  @override
  List<Object> get props => [stateList];
}

class CountryStateFailed extends CountryStateState {
  final String error;

  const CountryStateFailed({required this.error});

  @override
  List<Object> get props => [
        error,
      ];
}
