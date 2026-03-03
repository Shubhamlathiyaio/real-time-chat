// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:real_time_chat/app/controllers/app_controller.dart' as _i475;
import 'package:real_time_chat/app/controllers/auth_controller.dart' as _i719;
import 'package:real_time_chat/app/services/auth_service.dart' as _i146;
import 'package:real_time_chat/app/utils/helpers/injectable/module.dart'
    as _i1070;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final externalModule = _$ExternalModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => externalModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i475.AppController>(() => _i475.AppController());
    gh.lazySingleton<_i719.AuthController>(() => _i719.AuthController());
    gh.lazySingleton<_i146.AuthService>(() => _i146.AuthService());
    return this;
  }
}

class _$ExternalModule extends _i1070.ExternalModule {}
