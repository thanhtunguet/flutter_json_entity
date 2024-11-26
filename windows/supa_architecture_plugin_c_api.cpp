#include "include/supa_architecture/supa_architecture_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "supa_architecture_plugin.h"

void SupaArchitecturePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  supa_architecture::SupaArchitecturePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
