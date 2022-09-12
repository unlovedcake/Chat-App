import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sure_keep/Chat/set-default-conversation.dart';
import 'package:sure_keep/Router/navigate-route.dart';

import '../../Provider/auth-provider.dart';

class AndroidSettingsScreen extends StatefulWidget {
  const AndroidSettingsScreen({Key? key}) : super(key: key);

  @override
  _AndroidSettingsScreenState createState() => _AndroidSettingsScreenState();
}

class _AndroidSettingsScreenState extends State<AndroidSettingsScreen> {
  bool useNotificationDotOnAppIcon = true;

  bool? _isBackGround;


  Future<bool?> isAppBackGround() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? _isAppBackGround = prefs.getBool('isBackGroundMode') ?? false;
    _isBackGround = _isAppBackGround;

    return  _isBackGround;
  }
  @override
  void initState() {

    isAppBackGround();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SettingsList(
        platform: DevicePlatform.android,
        sections: [
          SettingsSection(
            title: Text('Manage'),
            tiles: [
              SettingsTile(
                onPressed: (val) {
                  _showModalBottomSheet();
                },
                title: const Text('Encrypt Message'),
                description:
                    const Text('Set duration time for encrypted message'),
              ),
              SettingsTile(
                onPressed: (val){
                  NavigateRoute.gotoPage(context, const SetDefaultConversation());
                },
                title: Text('Set Default Conversation'),
                description: Text('Person you want to show your conversation'),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Conservation'),
            tiles: [
              SettingsTile(
                title: Text('Conservations'),
                description: Text('No priority conservations'),
              ),
              SettingsTile(
                title: Text('Bubbles'),
                description: Text(
                  'On / Conservations can appear as floating icons',
                ),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Privacy'),
            tiles: [
              SettingsTile(
                title: Text('Device & app notifications'),
                description: Text(
                  'Control which apps and devices can read notifications',
                ),
              ),
              SettingsTile(
                title: Text('Notifications on lock screen'),
                description: Text('Show conversations, default, and silent'),
              ),
            ],
          ),
          SettingsSection(
            title: Text('General'),
            tiles: [
              SettingsTile(
                title: Text('Do Not Disturb'),
                description: Text('Off / 1 schedule can turn on automatically'),
              ),
              SettingsTile(
                title: Text('Wireless emergency alerts'),
              ),
              SettingsTile.switchTile(
                initialValue: false,
                onToggle: (_) {},
                title: Text('Hide silent notifications in status bar'),
              ),
              SettingsTile.switchTile(
                initialValue: false,
                onToggle: (_) {},
                title: Text('Allow notification snoozing'),
              ),
              SettingsTile.switchTile(
                initialValue: useNotificationDotOnAppIcon,
                onToggle: (value) {
                  setState(() {
                    useNotificationDotOnAppIcon = value;
                    print(useNotificationDotOnAppIcon);
                  });
                },
                title: Text('Notification dot on app icon'),
              ),
              SettingsTile(
                onPressed: (val) {
                  AuthProvider.logout(context);
                },
                trailing: Icon(Icons.logout),
                title: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<int> getDuration() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? duration = prefs.getInt('duration') ?? 30;
    return  duration;
}



  _showModalBottomSheet() async{
    int duration =  await getDuration();



    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: 300,
            child: Column(
              children: [
                SwitchListTile(
                    title: Text('Encrypt Message'),
                    value: _isBackGround ?? false,
                    //value: context.watch<AuthProvider>().getBackGroundMode,
                    onChanged: (bool value) async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      setState(() {
                        //context.read<AuthProvider>().setBackGroundMode(value);
                        isAppBackGround();
                        prefs.setBool('isBackGroundMode', value);
                        //prefs.setInt('duration', 0);

                      });
                      prefs.getBool('isBackGroundMode') == false ? prefs.setInt('duration', 0) : prefs.setInt('duration', 30);
                      print(value);
                    }),
                Column(
                  children: [
                    RadioListTile(
                      title: const Text("30 seconds"),
                      value: 30,
                      groupValue: duration,
                      onChanged: (value) async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        setState((){
                          duration = int.parse(value.toString());

                          prefs.setInt('duration', duration);


                          print(duration);
                        });
                      },
                    ),

                    RadioListTile(
                      title: Text("1 minute"),
                      value: 60,
                      groupValue: duration,
                      onChanged: (value) async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        setState((){
                          duration = int.parse(value.toString());

                          prefs.setInt('duration', duration);


                          print(duration);
                        });
                      },
                    ),
                    RadioListTile(
                        title: Text("3 minutes"),
                        value: 180,
                        groupValue: duration,
                        onChanged: (value) async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState(() {
                            duration = int.parse(value.toString());


                            prefs.setInt('duration', duration);


                            print(duration);
                          });
                        }),
                    RadioListTile(
                      title: Text("5 minutes"),
                      value: 300,
                      groupValue: duration,
                      onChanged: (value) async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        setState(() {
                          duration = int.parse(value.toString());

                          prefs.setInt('duration', duration);


                          print(duration);
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
      },
    );
  }
}
