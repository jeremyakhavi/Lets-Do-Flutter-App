import 'package:permission_handler/permission_handler.dart';

checkPermission() async {
  //var cameraStatus = await Permission.camera.status;
  //var microphoneStatus = await Permission.microphone.status;
  // print("Camera status: $cameraStatus");
  // print("Mic status: $microphoneStatus");

  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
  ].request();
  print(statuses[Permission.camera]);
}
