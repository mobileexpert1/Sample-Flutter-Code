part of 'sign_up_screen.dart';

TextEditingController countryController = TextEditingController();
TextEditingController stateController = TextEditingController();

class CountryAndStateFields extends StatefulWidget {
  const CountryAndStateFields({Key? key}) : super(key: key);

  @override
  State<CountryAndStateFields> createState() => _CountryAndStateFieldsState();
}

class _CountryAndStateFieldsState extends State<CountryAndStateFields> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            Strings.textCountry,
            style: TextStyle(
              color: ColorRes.colorWhite,
              fontFamily: Fonts.regular,
              fontSize: FontSizes.font16,
            ),
          ),
          yHeight(screenHeight(context) * 0.005),
          InkWell(
            onTap: () {
              context.read<CountryBloc>().add(const GetCountryEvent());
              showDialog(context: context, builder: (context) => showCountry());
            },
            child: TextFormField(
              validator: (v) => customValidator(v, "Country"),
              enabled: false,
              style: const TextStyle(
                color: ColorRes.colorWhite,
                fontFamily: Fonts.regular,
                fontSize: FontSizes.font16,
              ),
              controller: countryController,
              cursorColor: ColorRes.colorWhite,
              decoration: fieldDecoNew(
                fillColor: ColorRes.colorBlackLight,
                hintText: Strings.selectCountry,
                prefixWidget: IconButton(
                  onPressed: null,
                  icon: Image.asset(
                    CommonUi.setPngImage(AssetsPath.statePrefixIcon),
                    height: 30,
                  ),
                ),
                suffix: IconButton(
                  onPressed: null,
                  icon: Image.asset(
                    CommonUi.setPngImage(AssetsPath.downArrow),
                    height: 30,
                  ),
                ),
              ),
            ),
          ),
          yHeight(20),
          const Text(
            Strings.textState,
            style: TextStyle(
              color: ColorRes.colorWhite,
              fontFamily: Fonts.regular,
              fontSize: FontSizes.font16,
            ),
          ),
          yHeight(screenHeight(context) * 0.005),
          InkWell(
            onTap: () {
              if (countryController.text.isNotEmpty) {
                showDialog(context: context, builder: (context) => showStates());
              } else {
                toast(msg: "Please Select Country");
              }
            },
            child: TextFormField(
              validator: (v) => customValidator(v, "State"),
              enabled: false,
              style: const TextStyle(
                color: ColorRes.colorWhite,
                fontFamily: Fonts.regular,
                fontSize: FontSizes.font16,
              ),
              controller: stateController,
              cursorColor: ColorRes.colorWhite,
              decoration: fieldDecoNew(
                fillColor: ColorRes.colorBlackLight,
                hintText: Strings.state,
                prefixWidget: IconButton(
                    onPressed: null,
                    icon: Image.asset(
                      CommonUi.setPngImage(AssetsPath.statePrefixIcon),
                      height: 30,
                    )),
                suffix: IconButton(
                  onPressed: null,
                  icon: Image.asset(
                    CommonUi.setPngImage(AssetsPath.downArrow),
                    height: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showCountry() {
    return Dialog(
      backgroundColor: primaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      alignment: Alignment.center,
      child: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Strings.selectCountry,
                style: TextStyle(
                  color: white,
                  fontSize: 20,
                ),
              ),
              yHeight(15),
              TextFormField(
                onChanged: (v) {
                  context.read<CountryBloc>().add(SearchCountryEvent(searchValue: v));
                },
                style: const TextStyle(
                  color: ColorRes.colorWhite,
                  fontFamily: Fonts.regular,
                  fontSize: FontSizes.font16,
                ),
                // controller: countryController,
                cursorColor: ColorRes.colorWhite,
                decoration: fieldDecoNew(
                  borderColor: ColorRes.colorCyan,
                  fillColor: ColorRes.colorBlackLight,
                  hintText: "Search",
                  hintStyle: const TextStyle(color: ColorRes.colorCyan),
                ),
              ),
              BlocBuilder<CountryBloc, CountryState>(
                builder: (context, state) {
                  if (state is CountryLoading) {
                    return Center(child: customLoader(color: white));
                  } else if (state is CountryError) {
                    return Center(child: Text(state.error));
                  } else if (state is CountryLoaded) {
                    final countryList = state.countryList;

                    if (countryList.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: countryList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  countryController.text = countryList[index].name ?? "";
                                  context.read<CountryStateBloc>().add(GetStates(selectedCountry: countryList[index]));
                                  back(context);
                                },
                                child: ListTile(
                                  tileColor: primaryDark,
                                  dense: true,
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              countryList[index].emoji ?? "",
                                              style: TextStyle(fontSize: 20, color: white),
                                            ),
                                            xWidth(10),
                                            Expanded(
                                              child: Text(
                                                countryList[index].name ?? "",
                                                style: TextStyle(fontSize: 15, color: white),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (countryController.text == countryList[index].name)
                                        Icon(
                                          Icons.check,
                                          color: white,
                                        )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "No Data Found",
                            style: TextStyle(color: white, fontSize: 20),
                          ),
                        ),
                      );
                    }
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showStates() {
    return Dialog(
      backgroundColor: primaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      alignment: Alignment.center,
      child: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Strings.selectState,
                style: TextStyle(
                  color: white,
                  fontSize: 20,
                ),
              ),
              yHeight(15),
              TextFormField(
                  onChanged: (v) {
                    context.read<CountryStateBloc>().add(SearchStates(stateName: v));
                  },
                  style: const TextStyle(
                    color: ColorRes.colorWhite,
                    fontFamily: Fonts.regular,
                    fontSize: FontSizes.font16,
                  ),
                  // controller: countryController,
                  cursorColor: ColorRes.colorWhite,
                  decoration: fieldDecoNew(
                    borderColor: ColorRes.colorCyan,
                    fillColor: ColorRes.colorBlackLight,
                    hintText: "Search",
                    hintStyle: const TextStyle(color: ColorRes.colorCyan),
                  ),
                  validator: emailValidator),
              BlocBuilder<CountryStateBloc, CountryStateState>(
                builder: (context, state) {
                  if (state is CountryStateLoading) {
                    return Center(child: customLoader(color: white));
                  } else if (state is CountryStateFailed) {
                    return Center(child: Text(state.error));
                  } else if (state is CountryStateLoaded) {
                    printLog(state.stateList.length);
                    final stateList = state.stateList;
                    stateList.sort((a, b) => a.name!.compareTo(b.name ?? "")); // Sort alphabetically
                    return Expanded(
                      child: ListView.builder(
                          itemCount: stateList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                stateController.text = stateList[index].name ?? "";
                                back(context);
                              },
                              child: ListTile(
                                tileColor: primaryDark,
                                dense: true,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      stateList[index].name ?? "",
                                      style: TextStyle(fontSize: 15, color: white),
                                    ),
                                    if (stateController.text == stateList[index].name)
                                      Icon(
                                        Icons.check,
                                        color: white,
                                      )
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
