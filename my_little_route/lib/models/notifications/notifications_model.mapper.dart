// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'notifications_model.dart';

class NotificationsModelMapper extends ClassMapperBase<NotificationsModel> {
  NotificationsModelMapper._();

  static NotificationsModelMapper? _instance;
  static NotificationsModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationsModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'NotificationsModel';

  static String? _$id(NotificationsModel v) => v.id;
  static const Field<NotificationsModel, String> _f$id =
      Field('id', _$id, opt: true);
  static String _$userId(NotificationsModel v) => v.userId;
  static const Field<NotificationsModel, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static bool _$isRead(NotificationsModel v) => v.isRead;
  static const Field<NotificationsModel, bool> _f$isRead =
      Field('isRead', _$isRead, key: r'is_read');
  static String _$message(NotificationsModel v) => v.message;
  static const Field<NotificationsModel, String> _f$message =
      Field('message', _$message);
  static DateTime? _$createdAt(NotificationsModel v) => v.createdAt;
  static const Field<NotificationsModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at', opt: true);

  @override
  final MappableFields<NotificationsModel> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #isRead: _f$isRead,
    #message: _f$message,
    #createdAt: _f$createdAt,
  };

  static NotificationsModel _instantiate(DecodingData data) {
    return NotificationsModel(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        isRead: data.dec(_f$isRead),
        message: data.dec(_f$message),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static NotificationsModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotificationsModel>(map);
  }

  static NotificationsModel fromJson(String json) {
    return ensureInitialized().decodeJson<NotificationsModel>(json);
  }
}

mixin NotificationsModelMappable {
  String toJson() {
    return NotificationsModelMapper.ensureInitialized()
        .encodeJson<NotificationsModel>(this as NotificationsModel);
  }

  Map<String, dynamic> toMap() {
    return NotificationsModelMapper.ensureInitialized()
        .encodeMap<NotificationsModel>(this as NotificationsModel);
  }

  NotificationsModelCopyWith<NotificationsModel, NotificationsModel,
          NotificationsModel>
      get copyWith => _NotificationsModelCopyWithImpl<NotificationsModel,
          NotificationsModel>(this as NotificationsModel, $identity, $identity);
  @override
  String toString() {
    return NotificationsModelMapper.ensureInitialized()
        .stringifyValue(this as NotificationsModel);
  }

  @override
  bool operator ==(Object other) {
    return NotificationsModelMapper.ensureInitialized()
        .equalsValue(this as NotificationsModel, other);
  }

  @override
  int get hashCode {
    return NotificationsModelMapper.ensureInitialized()
        .hashValue(this as NotificationsModel);
  }
}

extension NotificationsModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotificationsModel, $Out> {
  NotificationsModelCopyWith<$R, NotificationsModel, $Out>
      get $asNotificationsModel => $base.as(
          (v, t, t2) => _NotificationsModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NotificationsModelCopyWith<$R, $In extends NotificationsModel,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? userId,
      bool? isRead,
      String? message,
      DateTime? createdAt});
  NotificationsModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _NotificationsModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotificationsModel, $Out>
    implements NotificationsModelCopyWith<$R, NotificationsModel, $Out> {
  _NotificationsModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotificationsModel> $mapper =
      NotificationsModelMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          String? userId,
          bool? isRead,
          String? message,
          Object? createdAt = $none}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (userId != null) #userId: userId,
        if (isRead != null) #isRead: isRead,
        if (message != null) #message: message,
        if (createdAt != $none) #createdAt: createdAt
      }));
  @override
  NotificationsModel $make(CopyWithData data) => NotificationsModel(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      isRead: data.get(#isRead, or: $value.isRead),
      message: data.get(#message, or: $value.message),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  NotificationsModelCopyWith<$R2, NotificationsModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _NotificationsModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
