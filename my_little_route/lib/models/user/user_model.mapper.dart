// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_model.dart';

class UserModelMapper extends ClassMapperBase<UserModel> {
  UserModelMapper._();

  static UserModelMapper? _instance;
  static UserModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserModel';

  static String _$name(UserModel v) => v.name;
  static const Field<UserModel, String> _f$name = Field('name', _$name);
  static String _$email(UserModel v) => v.email;
  static const Field<UserModel, String> _f$email = Field('email', _$email);
  static String _$phone(UserModel v) => v.phone;
  static const Field<UserModel, String> _f$phone = Field('phone', _$phone);
  static String _$role(UserModel v) => v.role;
  static const Field<UserModel, String> _f$role = Field('role', _$role);
  static String? _$id(UserModel v) => v.id;
  static const Field<UserModel, String> _f$id = Field('id', _$id, opt: true);
  static DateTime? _$createdAt(UserModel v) => v.createdAt;
  static const Field<UserModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at', opt: true);
  static double? _$latitude(UserModel v) => v.latitude;
  static const Field<UserModel, double> _f$latitude =
      Field('latitude', _$latitude, opt: true);
  static double? _$longitude(UserModel v) => v.longitude;
  static const Field<UserModel, double> _f$longitude =
      Field('longitude', _$longitude, opt: true);

  @override
  final MappableFields<UserModel> fields = const {
    #name: _f$name,
    #email: _f$email,
    #phone: _f$phone,
    #role: _f$role,
    #id: _f$id,
    #createdAt: _f$createdAt,
    #latitude: _f$latitude,
    #longitude: _f$longitude,
  };

  static UserModel _instantiate(DecodingData data) {
    return UserModel(
        name: data.dec(_f$name),
        email: data.dec(_f$email),
        phone: data.dec(_f$phone),
        role: data.dec(_f$role),
        id: data.dec(_f$id),
        createdAt: data.dec(_f$createdAt),
        latitude: data.dec(_f$latitude),
        longitude: data.dec(_f$longitude));
  }

  @override
  final Function instantiate = _instantiate;

  static UserModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserModel>(map);
  }

  static UserModel fromJson(String json) {
    return ensureInitialized().decodeJson<UserModel>(json);
  }
}

mixin UserModelMappable {
  String toJson() {
    return UserModelMapper.ensureInitialized()
        .encodeJson<UserModel>(this as UserModel);
  }

  Map<String, dynamic> toMap() {
    return UserModelMapper.ensureInitialized()
        .encodeMap<UserModel>(this as UserModel);
  }

  UserModelCopyWith<UserModel, UserModel, UserModel> get copyWith =>
      _UserModelCopyWithImpl<UserModel, UserModel>(
          this as UserModel, $identity, $identity);
  @override
  String toString() {
    return UserModelMapper.ensureInitialized()
        .stringifyValue(this as UserModel);
  }

  @override
  bool operator ==(Object other) {
    return UserModelMapper.ensureInitialized()
        .equalsValue(this as UserModel, other);
  }

  @override
  int get hashCode {
    return UserModelMapper.ensureInitialized().hashValue(this as UserModel);
  }
}

extension UserModelValueCopy<$R, $Out> on ObjectCopyWith<$R, UserModel, $Out> {
  UserModelCopyWith<$R, UserModel, $Out> get $asUserModel =>
      $base.as((v, t, t2) => _UserModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserModelCopyWith<$R, $In extends UserModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? name,
      String? email,
      String? phone,
      String? role,
      String? id,
      DateTime? createdAt,
      double? latitude,
      double? longitude});
  UserModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserModel, $Out>
    implements UserModelCopyWith<$R, UserModel, $Out> {
  _UserModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserModel> $mapper =
      UserModelMapper.ensureInitialized();
  @override
  $R call(
          {String? name,
          String? email,
          String? phone,
          String? role,
          Object? id = $none,
          Object? createdAt = $none,
          Object? latitude = $none,
          Object? longitude = $none}) =>
      $apply(FieldCopyWithData({
        if (name != null) #name: name,
        if (email != null) #email: email,
        if (phone != null) #phone: phone,
        if (role != null) #role: role,
        if (id != $none) #id: id,
        if (createdAt != $none) #createdAt: createdAt,
        if (latitude != $none) #latitude: latitude,
        if (longitude != $none) #longitude: longitude
      }));
  @override
  UserModel $make(CopyWithData data) => UserModel(
      name: data.get(#name, or: $value.name),
      email: data.get(#email, or: $value.email),
      phone: data.get(#phone, or: $value.phone),
      role: data.get(#role, or: $value.role),
      id: data.get(#id, or: $value.id),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      latitude: data.get(#latitude, or: $value.latitude),
      longitude: data.get(#longitude, or: $value.longitude));

  @override
  UserModelCopyWith<$R2, UserModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
