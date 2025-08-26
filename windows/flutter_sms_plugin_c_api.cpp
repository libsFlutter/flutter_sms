#include "include/flutter_sms/flutter_sms_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_sms_plugin.h"

void FlutterSmsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_sms::FlutterSmsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
