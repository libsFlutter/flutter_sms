#ifndef FLUTTER_PLUGIN_FLUTTER_SMS_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_SMS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_sms {

class FlutterSmsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterSmsPlugin();

  virtual ~FlutterSmsPlugin();

  // Disallow copy and assign.
  FlutterSmsPlugin(const FlutterSmsPlugin&) = delete;
  FlutterSmsPlugin& operator=(const FlutterSmsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_sms

#endif  // FLUTTER_PLUGIN_FLUTTER_SMS_PLUGIN_H_
