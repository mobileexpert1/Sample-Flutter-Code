import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:player_league/screens/login_screen/bloc/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:player_league/screens/login_screen/ui/login_screen.dart';
import 'package:player_league/utils/assets_paths.dart';
import 'package:player_league/utils/color_res.dart';
import 'package:player_league/utils/common_ui.dart';
import 'package:player_league/utils/font_sizes.dart';
import 'package:player_league/utils/fonts.dart';
import 'package:player_league/utils/services/constents.dart';
import 'package:player_league/utils/services/helpers.dart';
import 'package:player_league/utils/services/validations.dart';
import 'package:player_league/utils/strings.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: primary,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        yHeight(screenHeight(context) * 0.055),
                        const Center(
                          child: Text(
                            Strings.textForgotPasswordHeader,
                            style: TextStyle(
                              color: ColorRes.colorWhite,
                              fontFamily: Fonts.bold,
                              fontSize: FontSizes.font24,
                            ),
                          ),
                        ),

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

                        yHeight(screenHeight(context) * 0.25),
                        BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                          listener: (context, state) {
                            if (state is ForgotPasswordLoaded) {
                              pushReplacementAll(context, const LoginPage());
                              toast(msg: "Your password has been sent to you registered email address", isError: false);
                            }
                            if (state is ForgotPasswordFailed) {
                              toast(msg: state.error);
                            }
                          },
                          builder: (context, state) {
                            return Center(
                              child: GeneralBtn(
                                fontFamily: Fonts.semiBold,
                                title: Strings.textRecoverPassword,
                                fontSize: FontSizes.font18,
                                color: ColorRes.colorBlueLight,
                                loading: state is ForgotPasswordLoading ? true : false,
                                onTap: () async {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    Map<String, dynamic> body = {BodyConst.email: emailCtrl.text.trim()};
                                    if (mounted) {
                                      context.read<ForgotPasswordBloc>().add(ForgotPasswordRequest(body: body));
                                    }
                                  }
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  printLog("RecoverPassword btn");
                                },
                                borderRadius: 10,
                                xPadding: 10,
                                yPadding: 10,
                              ),
                            );
                          },
                        ),
                        yHeight(20),
                      ],
                    )),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
