import 'package:permission_handler/permission_handler.dart';

/* 
-- USE PERMISSIONS AND USE THEM RESPONSIBLY
  - this requirement is fufilled in this file

this method is called when opening the camera, it checks camera permissions
and requests if necessary
*/

checkPermission() async {
  var cameraStatus = await Permission.camera.status;
  print("Camera status: $cameraStatus");

  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
  ].request();
  print(statuses[Permission.camera]);
}
