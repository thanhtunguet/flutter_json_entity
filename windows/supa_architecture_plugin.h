#ifndef FLUTTER_PLUGIN_SUPA_ARCHITECTURE_PLUGIN_H_
#define FLUTTER_PLUGIN_SUPA_ARCHITECTURE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace supa_architecture {

class SupaArchitecturePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SupaArchitecturePlugin();

  virtual ~SupaArchitecturePlugin();

  // Disallow copy and assign.
  SupaArchitecturePlugin(const SupaArchitecturePlugin&) = delete;
  SupaArchitecturePlugin& operator=(const SupaArchitecturePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace supa_architecture

#endif  // FLUTTER_PLUGIN_SUPA_ARCHITECTURE_PLUGIN_H_
