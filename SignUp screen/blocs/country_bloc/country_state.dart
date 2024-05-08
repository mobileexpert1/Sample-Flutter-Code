part of 'country_bloc.dart';

abstract class CountryState extends Equatable {
  const CountryState();
}

class CountryInitial extends CountryState {
  @override
  List<Object> get props => [];
}

class CountryLoading extends CountryState {
  @override
  List<Object> get props => [];
}

class CountryLoaded extends CountryState {
  final List<CountryStateModel> countryList;

  CountryLoaded({required this.countryList});

  @override
  List<Object> get props => [countryList];
}

class CountryError extends CountryState {
 final String error;

  CountryError(this.error);
  @override
  List<Object> get props => [error];
}
