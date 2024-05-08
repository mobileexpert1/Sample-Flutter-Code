part of 'country_state_bloc.dart';

abstract class CountryStateEvent extends Equatable {
  const CountryStateEvent();
}

class GetStates extends CountryStateEvent {
  final CountryStateModel selectedCountry;

  const GetStates({required this.selectedCountry});

  @override
  List<Object?> get props => [selectedCountry];
}
class SearchStates extends CountryStateEvent {
  final String stateName;

  const SearchStates({required this.stateName});

  @override
  List<Object?> get props => [stateName];
}

class SaveStates extends CountryStateEvent {
  const SaveStates();

  @override
  List<Object?> get props => [];
}
