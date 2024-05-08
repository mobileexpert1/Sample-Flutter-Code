import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:player_league/screens/sign_up_screen/models/country_state_model.dart';
import 'package:player_league/utils/services/helpers.dart';

part 'country_event.dart';

part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  List<CountryStateModel> allCountryList = <CountryStateModel>[];

  CountryBloc() : super(CountryInitial()) {
    on<GetCountryEvent>(_onGetCountryEvent);
    on<SearchCountryEvent>(_onSearchCountryEvent);
  }

  Future<FutureOr<void>> _onGetCountryEvent(GetCountryEvent event, Emitter<CountryState> emit) async {
    try {
      emit(CountryLoading());
      if (allCountryList.isEmpty) {
        String data = await rootBundle
            .loadString('assets/jsons/country.json');
        allCountryList = List<CountryStateModel>.from(
            jsonDecode(data).map((e) => CountryStateModel.fromJson(e)));
      }
      emit(CountryLoaded(countryList: allCountryList));
    } catch (e, s) {
      printLog(e.toString());
      emit(CountryError(e.toString()));
    }
  }
  Future<FutureOr<void>> _onSearchCountryEvent(
      SearchCountryEvent event, Emitter<CountryState> emit) async {
    try {
      emit(CountryLoading());
     if(event.searchValue.isNotEmpty){
       List<CountryStateModel>? searchStateList = <CountryStateModel>[];

       for (CountryStateModel element in allCountryList ) {
         if (element.name
             ?.toLowerCase()
             .contains(event.searchValue.trim().toLowerCase()) ??
             false) {
           searchStateList.add(element);
         }
       }
       emit(CountryLoaded(countryList: searchStateList));
     }else{
       emit(CountryLoaded(countryList: allCountryList));
     }
    } catch (e, s) {
      printLog(emit.toString());
      emit(CountryError(e.toString()));
    }
  }
}
