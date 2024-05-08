import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:player_league/screens/sign_up_screen/models/country_state_model.dart';
import 'package:player_league/utils/services/helpers.dart';

part 'country_state_event.dart';

part 'country_state_state.dart';

class CountryStateBloc extends Bloc<CountryStateEvent, CountryStateState> {
  List<CountryStateInfo> stateList = <CountryStateInfo>[];

  CountryStateBloc() : super(CountryStateInitial()) {
    on<GetStates>(_onGetStates);
    on<SearchStates>(_onSearchStates);
  }

  Future<FutureOr<void>> _onGetStates(
      GetStates event, Emitter<CountryStateState> emit) async {
    try {
      emit(CountryStateLoading());
      stateList = event.selectedCountry.state ?? <CountryStateInfo>[];
      emit(CountryStateLoaded(stateList: stateList));
    } catch (e, s) {
      printLog(e.toString());
      emit(CountryStateFailed(error: e.toString()));
    }
  }

  Future<FutureOr<void>> _onSearchStates(
      SearchStates event, Emitter<CountryStateState> emit) async {
    try {
      if (event.stateName.isNotEmpty) {
        emit(CountryStateLoading());
        List<CountryStateInfo>? searchStateList = <CountryStateInfo>[];

        for (CountryStateInfo element in stateList) {
          if (element.name
                  ?.toLowerCase()
                  .contains(event.stateName.trim().toLowerCase()) ??
              false) {
            searchStateList.add(element);
          }
        }
        emit(CountryStateLoaded(stateList: searchStateList));
      } else {
        emit(CountryStateLoaded(stateList: stateList));
      }
    } catch (e, s) {
      printLog(e.toString());
      emit(CountryStateFailed(error: e.toString()));
    }
  }
}
