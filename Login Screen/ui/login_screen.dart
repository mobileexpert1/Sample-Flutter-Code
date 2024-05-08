import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:player_league/screens/home_page_screens/my_profile/blocs/get_profile_detail_bloc/get_profile_detail_bloc.dart';
import 'package:player_league/screens/login_screen/bloc/login_bloc.dart';
import 'package:player_league/screens/login_screen/ui/forgot_password_screen.dart';
import 'package:player_league/screens/select_account_type_screen/ui/select_account_without_api.dart';
import 'package:player_league/screens/sign_up_screen/ui/sign_up_screen.dart';
import 'package:player_league/utils/fonts.dart';
import 'package:player_league/utils/assets_paths.dart';
import 'package:player_league/screens/common_widgets/dialog/dialogs.dart';
import 'package:player_league/utils/font_sizes.dart';
import 'package:player_league/utils/services/all_getter.dart';
import 'package:player_league/utils/services/constents.dart';
import 'package:player_league/utils/services/validations.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/color_res.dart';
import '../../../../utils/common_ui.dart';
import '../../../../utils/services/helpers.dart';
import '../../home_page_screens/dashBoard/ui/dashboard.dart';
import '../social/social_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  bool isChecked = false;
  final StreamController<bool> _checkBoxController = StreamController();
  Stream<bool> get checkBoxStream => _checkBoxController.stream;

  requestPermission(Permission permission) async {
    // Check the current status of the permission.
    var status = await permission.status;

    // If the permission is granted, return true.
    if (status.isGranted) {
      return true;
    }
    // If the permission is denied but can be requested again, request it and return the result.
    else if (status.isDenied) {
      if (permission == Permission.notification) {
        var result = await permission.request();
        return result;
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return StreamBuilder(
                stream: checkBoxStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text(
                      'Enable Location Services',
                      style: TextStyle(fontSize: 20),
                    ),
                    content: Column(
                      children: <Widget>[
                        const Center(
                            child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 60,
                        )),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "By enabling location services, you agree to share your location data with all users "
                          "of the app. Your location will be available to other users until you"
                          " choose to disable location services. This information helps enhance your"
                          " experience by allowing you to use features that depend on location accuracy.",
                          style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                                value: snapshot.data,
                                onChanged: (changedValue) {
                                  print('Value - ${changedValue}');
                                  _checkBoxController.sink.add(changedValue!);
                                }),
                            const SizedBox(
                              width: 0,
                            ),
                            const Expanded(
                                child: Text(
                              " I understand and agree to share my location.",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ))
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                          child: const Text(
                            "Enable Location Services",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                          onPressed: () async {
                            if (snapshot.data != true) {
                              toast(msg: 'Please fill the checkbox!', isError: true);
                            } else {
                              if (status.isDenied) {
                                var result = await permission.request().then((value) {
                                  if (value == PermissionStatus.permanentlyDenied) {
                                    openAppSettings().then((value) => Navigator.pop(context));
                                  } else {
                                    Navigator.pop(context);
                                  }
                                });
                              } else {
                                Navigator.pop(context);
                                openAppSettings();
                              }
                            }

                            // your code
                          }),
                      ElevatedButton(
                          child: const Text("Cancel", style: TextStyle(fontSize: 10, color: Colors.white)),
                          onPressed: () {
                            Navigator.pop(context);

                            // your code
                          }),
                    ],
                  );
                });
          },
        );
      }
    }
    else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission(Permission.notification).then((value) => requestPermission(Permission.location));
  }

  @override
  void dispose() {
    _checkBoxController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return await exitDialog(context);
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            backgroundColor: primary,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  internationalPlayersLeagueWidget(context: context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Login header
                          yHeight(screenHeight(context) * 0.055),
                          const Center(
                            child: Text(
                              Strings.textLoginHeader,
                              style: TextStyle(
                                color: ColorRes.colorWhite,
                                fontFamily: Fonts.bold,
                                fontSize: FontSizes.font24,
                              ),
                            ),
                          ),

                          ///App logo
                          yHeight(screenHeight(context) * 0.015),
                          Center(
                              child: Image.asset(CommonUi.setPngImage(AssetsPath.newAppLogo),
                                  height: screenHeight(context) * 0.155, width: screenWidth(context) * 0.735)),

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
                            obscureText: true,
                            controller: passwordCtrl,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: ColorRes.colorWhite,
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
                          yHeight(5),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                pushTo(context, const ForgotPasswordScreen());
                              },
                              child: const Text(
                                Strings.textForgotPassword,
                                style: TextStyle(
                                  color: ColorRes.colorWhite,
                                  fontFamily: Fonts.regular,
                                  fontSize: FontSizes.font16,
                                ),
                              ),
                            ),
                          ),
                          yHeight(10),

                          ///login Button
                          yHeight(screenHeight(context) * 0.02),
                          BlocConsumer<LoginBloc, LoginState>(
                            listener: (context, state) {
                              if (state is LoginSuccess) {
                                final loginDetail = state.loginModel.data;
                                final Map<String, dynamic> body = {
                                  BodyConst.email: loginDetail?.email ?? "",
                                };
                                context.read<GetProfileDetailBloc>().add(GetPlayerDetail(
                                      body: body,
                                      isLoginUser: true,
                                    ));

                                Future.delayed(const Duration(seconds: 1)).then((value) {
                                  toast(msg: "Login Successfully", isError: false);
                                  pushReplacementAll(context, const DashBoard());
                                });
                                // pushReplacementAll(context, const SelectAccountTypePage());
                              }
                              if (state is LoginFailed) {
                                toast(msg: state.error);
                              }
                            },
                            builder: (context, state) {
                              return Center(
                                child: GeneralBtn(
                                  colorLoading: white,
                                  fontFamily: Fonts.semiBold,
                                  title: Strings.textLoginBtn,
                                  fontSize: FontSizes.font18,
                                  loading: state is LoginLoading ? true : false,
                                  color: ColorRes.colorBlueLight,
                                  onTap: () async {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      final fcmToken = await getFcmToken();
                                      Map<String, dynamic> body = {
                                        BodyConst.email: emailCtrl.text,
                                        BodyConst.password: passwordCtrl.text,
                                        BodyConst.fcmToken: fcmToken,
                                      };

                                      if (mounted) {
                                        context.read<LoginBloc>().add(GetLogin(body: body));
                                      }
                                    }
                                  },
                                  borderRadius: 10,
                                  xPadding: 70,
                                  yPadding: 10,
                                ),
                              );
                            },
                          ),
                          yHeight(17),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SocialButton(
                                onTap: () async {
                                  final fcmToken = await getFcmToken();
                                  GoogleAuth.signInWithGoogle(context: context).then((value) {
                                    User? user;
                                    if (user != null) {
                                      /// Successfully signed in, use userData as needed
                                      printLog('User Data: $user');
                                      final Map<String, dynamic> userData = {
                                        'email': user.email,
                                        'socialId': user.providerData.first.uid,
                                        'name': user.displayName,
                                        'type': 3,
                                        'fcmToken': fcmToken,
                                        'profileImage': user.photoURL,
                                      };
                                      if (mounted) {
                                        /// Calling Social Login API HERE
                                        context.read<LoginBloc>().add(GetSocialLogin(body: userData));
                                      }
                                    } else {
                                      /// Error handling
                                      toast(msg: "Sign-in failed", isError: true);
                                      printLog('Sign-in failed');
                                    }
                                  });
                                },
                                imagePath: CommonUi.setPngImage(AssetsPath.googleLogo),
                              ),
                              xWidth(15),
                              SocialButton(
                                onTap: () async {
                                  final fcmToken = await getFcmToken();

                                  try {
                                    final LoginResult loginResult = await FacebookAuth.instance.login();

                                    if (loginResult.status == LoginStatus.success) {
                                      var dat = (await FacebookAuth.instance.getUserData());
                                      printLog("FACEBOOK TOKEN ------ > >>   >>  >${dat}");
                                      final String socialId = (await FacebookAuth.instance.getUserData())['id'] ?? '';
                                      final String name = (await FacebookAuth.instance.getUserData())['name'] ?? '';
                                      final String email =
                                          (await FacebookAuth.instance.getUserData(fields: 'email'))['email'] ?? '';
                                      final String profileImageUrl = 'https://graph.facebook.com/$socialId/picture';

                                      /// To print the email,id and name
                                      printLog('Email: $email');
                                      printLog('Social ID: $socialId');
                                      printLog('Name: $name');
                                      printLog('Profile Image URL: $profileImageUrl');

                                      final Map<String, dynamic> userData = {
                                        'email': email,
                                        'socialId': socialId,
                                        'name': name,
                                        'type': 4,
                                        'fcmToken': fcmToken,
                                        'profileImage': profileImageUrl,
                                      };

                                      if (mounted) {
                                        context.read<LoginBloc>().add(GetSocialLogin(body: userData));
                                      }

                                      /// Handle specific FB Sign-In errors here
                                    } else if (loginResult.status == LoginStatus.cancelled) {
                                      printLog('Facebook Login Canceled');
                                    } else {
                                      printLog('Facebook Login Failed: ${loginResult.message}');
                                    }
                                  } catch (error) {
                                    printLog('Error signing in with Facebook: $error');
                                  }
                                },
                                imagePath: CommonUi.setPngImage(AssetsPath.fbLogo),
                              ),
                              Platform.isIOS
                                  ? Row(
                                      children: [
                                        xWidth(15),
                                        SocialButton(
                                          onTap: () async {
                                            final fcmToken = await getFcmToken();
                                          },
                                          imagePath: CommonUi.setPngImage(AssetsPath.appleLogo),
                                        ),
                                      ],
                                    )
                                  : const SizedBox()
                            ],
                          ),

                          yHeight(screenHeight(context) * 0.02),
                          Center(
                            child: RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                  text: Strings.textDonHaveAn,
                                  style: TextStyle(
                                    color: ColorRes.colorWhite,
                                    fontSize: FontSizes.font18,
                                    fontFamily: Fonts.regular,
                                  )),
                              TextSpan(
                                  text: Strings.textSignUp,
                                  style: const TextStyle(
                                    color: ColorRes.colorWhite,
                                    fontSize: FontSizes.font18,
                                    fontFamily: Fonts.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      pushTo(context, const SignUpPage());
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

Widget internationalPlayersLeagueWidget({required BuildContext context, String? title, double? height}) {
  return Container(
    color: black,
    width: double.infinity,
    height: height ?? screenHeight(context) / 5,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title ?? "International\nPlayers\nLeague",
          style: TextStyle(fontSize: FontSizes.font24, color: white, fontFamily: Fonts.bold),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
