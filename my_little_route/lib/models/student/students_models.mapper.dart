// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'students_models.dart';

class StudentsModelMapper extends ClassMapperBase<StudentsModel> {
  StudentsModelMapper._();

  static StudentsModelMapper? _instance;
  static StudentsModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StudentsModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'StudentsModel';

  static String? _$id(StudentsModel v) => v.id;
  static const Field<StudentsModel, String> _f$id = Field('id', _$id);
  static String _$name(StudentsModel v) => v.name;
  static const Field<StudentsModel, String> _f$name = Field('name', _$name);
  static String _$parentId(StudentsModel v) => v.parentId;
  static const Field<StudentsModel, String> _f$parentId =
      Field('parentId', _$parentId, key: r'parent_id');
  static bool _$status(StudentsModel v) => v.status;
  static const Field<StudentsModel, bool> _f$status = Field('status', _$status);
  static DateTime? _$createdAt(StudentsModel v) => v.createdAt;
  static const Field<StudentsModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at', opt: true);
  static String _$driverId(StudentsModel v) => v.driverId;
  static const Field<StudentsModel, String> _f$driverId =
      Field('driverId', _$driverId, key: r'driver_id');
  static String? _$gender(StudentsModel v) => v.gender;
  static const Field<StudentsModel, String> _f$gender =
      Field('gender', _$gender, opt: true);

  @override
  final MappableFields<StudentsModel> fields = const {
    #id: _f$id,
    #name: _f$name,
    #parentId: _f$parentId,
    #status: _f$status,
    #createdAt: _f$createdAt,
    #driverId: _f$driverId,
    #gender: _f$gender,
  };

  static StudentsModel _instantiate(DecodingData data) {
    return StudentsModel(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        parentId: data.dec(_f$parentId),
        status: data.dec(_f$status),
        createdAt: data.dec(_f$createdAt),
        driverId: data.dec(_f$driverId),
        gender: data.dec(_f$gender));
  }

  @override
  final Function instantiate = _instantiate;

  static StudentsModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StudentsModel>(map);
  }

  static StudentsModel fromJson(String json) {
    return ensureInitialized().decodeJson<StudentsModel>(json);
  }
}

mixin StudentsModelMappable {
  String toJson() {
    return StudentsModelMapper.ensureInitialized()
        .encodeJson<StudentsModel>(this as StudentsModel);
  }

  Map<String, dynamic> toMap() {
    return StudentsModelMapper.ensureInitialized()
        .encodeMap<StudentsModel>(this as StudentsModel);
  }

  StudentsModelCopyWith<StudentsModel, StudentsModel, StudentsModel>
      get copyWith => _StudentsModelCopyWithImpl<StudentsModel, StudentsModel>(
          this as StudentsModel, $identity, $identity);
  @override
  String toString() {
    return StudentsModelMapper.ensureInitialized()
        .stringifyValue(this as StudentsModel);
  }

  @override
  bool operator ==(Object other) {
    return StudentsModelMapper.ensureInitialized()
        .equalsValue(this as StudentsModel, other);
  }

  @override
  int get hashCode {
    return StudentsModelMapper.ensureInitialized()
        .hashValue(this as StudentsModel);
  }
}

extension StudentsModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, StudentsModel, $Out> {
  StudentsModelCopyWith<$R, StudentsModel, $Out> get $asStudentsModel =>
      $base.as((v, t, t2) => _StudentsModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StudentsModelCopyWith<$R, $In extends StudentsModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? name,
      String? parentId,
      bool? status,
      DateTime? createdAt,
      String? driverId,
      String? gender});
  StudentsModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StudentsModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StudentsModel, $Out>
    implements StudentsModelCopyWith<$R, StudentsModel, $Out> {
  _StudentsModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StudentsModel> $mapper =
      StudentsModelMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          String? name,
          String? parentId,
          bool? status,
          Object? createdAt = $none,
          String? driverId,
          Object? gender = $none}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (name != null) #name: name,
        if (parentId != null) #parentId: parentId,
        if (status != null) #status: status,
        if (createdAt != $none) #createdAt: createdAt,
        if (driverId != null) #driverId: driverId,
        if (gender != $none) #gender: gender
      }));
  @override
  StudentsModel $make(CopyWithData data) => StudentsModel(
      id: data.get(#id, or: $value.id),
      name: data.get(#name, or: $value.name),
      parentId: data.get(#parentId, or: $value.parentId),
      status: data.get(#status, or: $value.status),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      driverId: data.get(#driverId, or: $value.driverId),
      gender: data.get(#gender, or: $value.gender));

  @override
  StudentsModelCopyWith<$R2, StudentsModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _StudentsModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
