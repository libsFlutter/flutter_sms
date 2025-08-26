#include "include/flutter_smsussd/flutter_smsussd_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_smsussd_plugin.h"

void FlutterSmsussdPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_smsussd::FlutterSmsussdPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
