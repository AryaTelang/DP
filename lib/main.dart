import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bachat_cards/bindings/bindings.dart';
import 'package:bachat_cards/firebase_options.dart';
import 'package:bachat_cards/screens/auth_screens/is_new_user_screen.dart';
import 'package:bachat_cards/screens/onboarding_screens/screen1.dart';
import 'package:bachat_cards/screens/post_login_screen.dart';
import 'package:bachat_cards/sevrices/notifications_api.dart';
import 'package:bachat_cards/sevrices/remote_config_service.dart';
import 'package:bachat_cards/sevrices/shared_prefs.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';

import 'Constants/constants.dart';
// import 'amplifyconfiguration.dart';
import 'models/settings.dart';

const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "ap-south-1_ikAg1NHq5",
                        "AppClientId": "186t1d8bcrskhpgobnl1hfjlsf",
                        "Region": "ap-south-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "CUSTOM_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [
                            "PHONE_NUMBER"
                        ],
                        "signupAttributes": [
                            "PHONE_NUMBER"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": [
                                "REQUIRES_LOWERCASE",
                                "REQUIRES_UPPERCASE",
                                "REQUIRES_NUMBERS"
                            ]
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [],
                        "verificationMechanisms": []
                    }
                }
            }
        }
    }
}''';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPrefs.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  NotificationsApi().notificationPermission();
  NotificationsApi.init();
  NotificationsApi().createChannel();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  await FirebaseMessaging.instance.subscribeToTopic('general');
  if (Platform.isAndroid) {
    FirebaseMessaging.onMessage.listen((event) {
      NotificationsApi.showNotification(
        title: event.notification!.title,
        body: event.notification!.body,
      );
    });
  }
  runApp(const MyApp());
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late RemoteConfigService service;
  bool forceUpdate = false;
  List<Settings> settings = [];

  @override
  void initState() {
    super.initState();
    getAppSettings();
    service = RemoteConfigService.getInstance();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  void getAppSettings() async {
    try {
      final response = await Dio().get('${Constants.url}/mbc/v1/settings');
      if (response.data['result'].isNotEmpty) {
        for (int i = 0; i < response.data['result'].length; i++) {
          Settings s = Settings.fromJson(response.data['result'][i]);
          if (s.key == 'forceUpdate' && s.value == 'true') {
            setState(() {
              forceUpdate = true;
            });
          }
          settings.add(s);
        }
      }
    } on DioError catch (e) {
      debugPrint('settings error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBindigs(),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: defaultColorScheme,
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black))),
      home: UpgradeAlert(
        upgrader: Upgrader(
            showIgnore: !forceUpdate,
            showLater: !forceUpdate,
            dialogStyle: Platform.isAndroid
                ? UpgradeDialogStyle.material
                : UpgradeDialogStyle.cupertino),
        child: SharedPrefs.getIsFirstInstalled()
            ? const OnboardingScreen1()
            : SharedPrefs.getToken() != ''
                ? const PostLoginScreen()
                : const IsNewUserScreen(),
      ),
      routes: {
        PostLoginScreen.routeName: (_) => const PostLoginScreen(),
      },
    );
  }
}
