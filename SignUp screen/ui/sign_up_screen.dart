import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:player_league/screens/common_widgets/dialog/dialogs.dart';
import 'package:player_league/screens/home_page_screens/my_profile/blocs/get_profile_detail_bloc/get_profile_detail_bloc.dart';
import 'package:player_league/screens/login_screen/ui/login_screen.dart';
import 'package:player_league/screens/select_account_type_screen/ui/select_account_without_api.dart';
import 'package:player_league/screens/sign_up_screen/blocs/country_state_bloc/country_state_bloc.dart';
import 'package:player_league/screens/sign_up_screen/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:player_league/screens/sign_up_screen/models/country_state_model.dart';
import 'package:player_league/utils/color_res.dart';
import 'package:player_league/utils/font_sizes.dart';
import 'package:player_league/utils/fonts.dart';
import 'package:player_league/utils/assets_paths.dart';
import 'package:player_league/utils/common_ui.dart';
import 'package:player_league/utils/services/constents.dart';
import 'package:player_league/utils/services/helpers.dart';
import 'package:player_league/utils/services/validations.dart';
import '../../../../utils/strings.dart';
import '../../home_page_screens/dashBoard/ui/dashboard.dart';
import '../blocs/country_bloc/country_bloc.dart';

part 'country_and_state_fields.dart';

CountryStateModel? selectedCountry;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();

  List<dynamic> countryName = [];
  String countryId = '';

  @override
  void initState() {
    context.read<CountryBloc>().add(const GetCountryEvent());
    super.initState();
    countryName.add({"id": "1", "name": "India"});
    countryName.add({"id": "2", "name": "UAE"});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await exitDialog(context),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            backgroundColor: primary,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: black,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: Image.asset(
                        CommonUi.setPngImage(
                          AssetsPath.newAppLogo,
                        ),
                        height: screenHeight(context) / 5,
                        width: screenWidth(context) / 2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///SignUp header
                          yHeight(screenHeight(context) * 0.055),
                          const Center(
                            child: Text(
                              Strings.textSignUpHeader,
                              style: TextStyle(
                                color: ColorRes.colorWhite,
                                fontFamily: Fonts.bold,
                                fontSize: FontSizes.font24,
                              ),
                            ),
                          ),

                          ///Name Field
                          yHeight(screenHeight(context) * 0.06),
                          const Text(
                            Strings.textName,
                            style: TextStyle(
                              color: ColorRes.colorWhite,
                              fontFamily: Fonts.regular,
                              fontSize: FontSizes.font16,
                            ),
                          ),
                          yHeight(screenHeight(context) * 0.005),
                          TextFormField(
                              style: const TextStyle(
                                color: ColorRes.colorWhite,
                                fontFamily: Fonts.regular,
                                fontSize: FontSizes.font16,
                              ),
                              controller: nameCtrl,
                              cursorColor: ColorRes.colorWhite,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              decoration: fieldDecoNew(
                                fillColor: ColorRes.colorBlackLight,
                                hintText: Strings.textName,
                                prefixWidget: IconButton(
                                    onPressed: null,
                                    icon: Image.asset(
                                      CommonUi.setPngImage(AssetsPath.userIcon),
                                      height: 18,
                                    )),
                              ),
                              validator: nameValidator),

                          ///Email field
                          yHeight(screenHeight(context) * 0.03),
                          const Text(
                            Strings.textEmail,
                            style: TextStyle(
                              color: ColorRes.colorWhite,
                              fontFamily: Fonts.regular,
                              fontSize: FontSizes.font16,
                            ),
                          ),
                          yHeight(screenHeight(context) * 0.005),
                          TextFormField(
                              style: const TextStyle(
                                color: ColorRes.colorWhite,
                                fontFamily: Fonts.regular,
                                fontSize: FontSizes.font16,
                              ),
                              controller: emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: ColorRes.colorWhite,
                              decoration: fieldDecoNew(
                                fillColor: ColorRes.colorBlackLight,
                                hintText: Strings.textEmail,
                                prefixWidget: IconButton(
                                    onPressed: null,
                                    icon: Image.asset(
                                      CommonUi.setPngImage(AssetsPath.emailIcon),
                                      height: 18,
                                    )),
                              ),
                              validator: emailValidator),

                          ///Password field
                          yHeight(screenHeight(context) * 0.03),
                          const CountryAndStateFields(),
                          yHeight(screenHeight(context) * 0.03),
                          const Text(
                            Strings.textPassword,
                            style: TextStyle(
                              color: ColorRes.colorWhite,
                              fontFamily: Fonts.regular,
                              fontSize: FontSizes.font16,
                            ),
                          ),
                          yHeight(screenHeight(context) * 0.005),

                          TextFormField(
                            style: const TextStyle(
                              color: ColorRes.colorWhite,
                              fontFamily: Fonts.regular,
                              fontSize: FontSizes.font16,
                            ),
                            controller: passwordCtrl,
                            cursorColor: ColorRes.colorWhite,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: fieldDecoNew(
                              fillColor: ColorRes.colorBlackLight,
                              hintText: Strings.textPassword,
                              prefixWidget: IconButton(
                                  onPressed: null,
                                  icon: Image.asset(
                                    CommonUi.setPngImage(AssetsPath.passwordIcon),
                                    height: 25,
                                  )),
                            ),
                            validator: passwordValidator,
                          ),

                          ///SignUp Button
                          yHeight(screenHeight(context) * 0.1),
                          BlocProvider(
                            create: (context) => SignUpBloc(),
                            child: BlocConsumer<SignUpBloc, SignUpState>(
                              listener: (context, state) {
                                if (state is SignUpSuccess) {
                                  final Map<String, dynamic> body = {
                                    BodyConst.email: state.email ?? "",
                                  };
                                   context.read<GetProfileDetailBloc>().add(GetPlayerDetail(
                                        body: body,
                                        isLoginUser: true,
                                      ));

                                  pushReplacementAll(context, const DashBoard());
                                  // pushReplacementAll(
                                  //     context, const SelectAccountTypePage());
                                }
                                if (state is SignUpFailed) {
                                  toast(msg: state.error);
                                }
                              },
                              builder: (context, state) {
                                return Center(
                                  child: GeneralBtn(
                                    fontFamily: Fonts.semiBold,
                                    title: Strings.textSignUpBtn,
                                    fontSize: FontSizes.font18,
                                    loading: state is SignUpLoading ? true : false,
                                    color: ColorRes.colorBlueLight,
                                    onTap: () async {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        if (countryController.text.isEmpty) {
                                          toast(msg: "Please Select Country");
                                        } else {
                                          if (stateController.text.isEmpty) {
                                            toast(msg: "Please Select State");
                                          } else {
                                            Map<String, dynamic> body = {
                                              BodyConst.email: emailCtrl.text,
                                              BodyConst.password: passwordCtrl.text,
                                              BodyConst.name: nameCtrl.text,
                                              BodyConst.country: countryController.text,
                                              BodyConst.state: stateController.text,
                                            };
                                            if (mounted) {
                                              context.read<SignUpBloc>().add(GetSignUp(body: body));
                                            }
                                          }
                                        }
                                      }
                                      printLog("SignUp btn");
                                    },
                                    borderRadius: 10,
                                    xPadding: 60,
                                    yPadding: 10,
                                  ),
                                );
                              },
                            ),
                          ),

                          ///Already have an account title
                          yHeight(screenHeight(context) * 0.05),
                          Center(
                            child: RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                  text: Strings.textAlreadyHaveAn,
                                  style: TextStyle(
                                    color: ColorRes.colorWhite,
                                    fontSize: FontSizes.font18,
                                    fontFamily: Fonts.regular,
                                  )),
                              TextSpan(
                                  text: " ${Strings.textLoginBtn}",
                                  style: const TextStyle(
                                    color: ColorRes.colorWhite,
                                    fontSize: FontSizes.font18,
                                    fontFamily: Fonts.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      pushReplacement(context, const LoginPage());
                                    })
                            ])),
                          ),

                          yHeight(20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
