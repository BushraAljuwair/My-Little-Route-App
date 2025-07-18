// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'students_models.dart';

class StudentsModelsMapper extends ClassMapperBase<StudentsModels> {
  StudentsModelsMapper._();

  static StudentsModelsMapper? _instance;
  static StudentsModelsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StudentsModelsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'StudentsModels';

  static String? _$id(StudentsModels v) => v.id;
  static const Field<StudentsModels, String> _f$id = Field('id', _$id);
  static String _$name(StudentsModels v) => v.name;
  static const Field<StudentsModels, String> _f$name = Field('name', _$name);
  static String _$parentId(StudentsModels v) => v.parentId;
  static const Field<StudentsModels, String> _f$parentId =
      Field('parentId', _$parentId, key: r'parent_id');
  static bool _$status(StudentsModels v) => v.status;
  static const Field<StudentsModels, bool> _f$status =
      Field('status', _$status);
  static DateTime? _$createdAt(StudentsModels v) => v.createdAt;
  static const Field<StudentsModels, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at', opt: true);

  @override
  final MappableFields<StudentsModels> fields = const {
    #id: _f$id,
    #name: _f$name,
    #parentId: _f$parentId,
    #status: _f$status,
    #createdAt: _f$createdAt,
  };

  static StudentsModels _instantiate(DecodingData data) {
    return StudentsModels(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        parentId: data.dec(_f$parentId),
        status: data.dec(_f$status),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static StudentsModels fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StudentsModels>(map);
  }

  static StudentsModels fromJson(String json) {
    return ensureInitialized().decodeJson<StudentsModels>(json);
  }
}

mixin StudentsModelsMappable {
  String toJson() {
    return StudentsModelsMapper.ensureInitialized()
        .encodeJson<StudentsModels>(this as StudentsModels);
  }

  Map<String, dynamic> toMap() {
    return StudentsModelsMapper.ensureInitialized()
        .encodeMap<StudentsModels>(this as StudentsModels);
  }

  StudentsModelsCopyWith<StudentsModels, StudentsModels, StudentsModels>
      get copyWith =>
          _StudentsModelsCopyWithImpl<StudentsModels, StudentsModels>(
              this as StudentsModels, $identity, $identity);
  @override
  String toString() {
    return StudentsModelsMapper.ensureInitialized()
        .stringifyValue(this as StudentsModels);
  }

  @override
  bool operator ==(Object other) {
    return StudentsModelsMapper.ensureInitialized()
        .equalsValue(this as StudentsModels, other);
  }

  @override
  int get hashCode {
    return StudentsModelsMapper.ensureInitialized()
        .hashValue(this as StudentsModels);
  }
}

extension StudentsModelsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, StudentsModels, $Out> {
  StudentsModelsCopyWith<$R, StudentsModels, $Out> get $asStudentsModels =>
      $base.as((v, t, t2) => _StudentsModelsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StudentsModelsCopyWith<$R, $In extends StudentsModels, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? name,
      String? parentId,
      bool? status,
      DateTime? createdAt});
  StudentsModelsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _StudentsModelsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StudentsModels, $Out>
    implements StudentsModelsCopyWith<$R, StudentsModels, $Out> {
  _StudentsModelsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StudentsModels> $mapper =
      StudentsModelsMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          String? name,
          String? parentId,
          bool? status,
          Object? createdAt = $none}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (name != null) #name: name,
        if (parentId != null) #parentId: parentId,
        if (status != null) #status: status,
        if (createdAt != $none) #createdAt: createdAt
      }));
  @override
  StudentsModels $make(CopyWithData data) => StudentsModels(
      id: data.get(#id, or: $value.id),
      name: data.get(#name, or: $value.name),
      parentId: data.get(#parentId, or: $value.parentId),
      status: data.get(#status, or: $value.status),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  StudentsModelsCopyWith<$R2, StudentsModels, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _StudentsModelsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
