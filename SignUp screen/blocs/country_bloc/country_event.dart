part of 'country_bloc.dart';

abstract class CountryEvent extends Equatable {
  const CountryEvent();
}

class GetCountryEvent extends CountryEvent {
  const GetCountryEvent();

  @override
  List<Object?> get props => [];
}

class SearchCountryEvent extends CountryEvent {
  final String searchValue;

  const SearchCountryEvent({required this.searchValue});

  @override
  List<Object?> get props => [searchValue];
}
