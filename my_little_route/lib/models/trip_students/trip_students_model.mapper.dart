// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'trip_students_model.dart';

class TripStudentsModelMapper extends ClassMapperBase<TripStudentsModel> {
  TripStudentsModelMapper._();

  static TripStudentsModelMapper? _instance;
  static TripStudentsModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TripStudentsModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TripStudentsModel';

  static String _$pickupStatus(TripStudentsModel v) => v.pickupStatus;
  static const Field<TripStudentsModel, String> _f$pickupStatus =
      Field('pickupStatus', _$pickupStatus, key: r'pickup_status');
  static String _$dropoffStatus(TripStudentsModel v) => v.dropoffStatus;
  static const Field<TripStudentsModel, String> _f$dropoffStatus =
      Field('dropoffStatus', _$dropoffStatus, key: r'dropoff_status');
  static String? _$id(TripStudentsModel v) => v.id;
  static const Field<TripStudentsModel, String> _f$id = Field('id', _$id);
  static String _$tripId(TripStudentsModel v) => v.tripId;
  static const Field<TripStudentsModel, String> _f$tripId =
      Field('tripId', _$tripId, key: r'trip_id');
  static String _$studentId(TripStudentsModel v) => v.studentId;
  static const Field<TripStudentsModel, String> _f$studentId =
      Field('studentId', _$studentId, key: r'student_id');
  static DateTime? _$dropoffTime(TripStudentsModel v) => v.dropoffTime;
  static const Field<TripStudentsModel, DateTime> _f$dropoffTime =
      Field('dropoffTime', _$dropoffTime, key: r'dropoff_time');
  static DateTime? _$pickupTime(TripStudentsModel v) => v.pickupTime;
  static const Field<TripStudentsModel, DateTime> _f$pickupTime =
      Field('pickupTime', _$pickupTime, key: r'pickup_time', opt: true);

  @override
  final MappableFields<TripStudentsModel> fields = const {
    #pickupStatus: _f$pickupStatus,
    #dropoffStatus: _f$dropoffStatus,
    #id: _f$id,
    #tripId: _f$tripId,
    #studentId: _f$studentId,
    #dropoffTime: _f$dropoffTime,
    #pickupTime: _f$pickupTime,
  };

  static TripStudentsModel _instantiate(DecodingData data) {
    return TripStudentsModel(
        pickupStatus: data.dec(_f$pickupStatus),
        dropoffStatus: data.dec(_f$dropoffStatus),
        id: data.dec(_f$id),
        tripId: data.dec(_f$tripId),
        studentId: data.dec(_f$studentId),
        dropoffTime: data.dec(_f$dropoffTime),
        pickupTime: data.dec(_f$pickupTime));
  }

  @override
  final Function instantiate = _instantiate;

  static TripStudentsModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TripStudentsModel>(map);
  }

  static TripStudentsModel fromJson(String json) {
    return ensureInitialized().decodeJson<TripStudentsModel>(json);
  }
}

mixin TripStudentsModelMappable {
  String toJson() {
    return TripStudentsModelMapper.ensureInitialized()
        .encodeJson<TripStudentsModel>(this as TripStudentsModel);
  }

  Map<String, dynamic> toMap() {
    return TripStudentsModelMapper.ensureInitialized()
        .encodeMap<TripStudentsModel>(this as TripStudentsModel);
  }

  TripStudentsModelCopyWith<TripStudentsModel, TripStudentsModel,
          TripStudentsModel>
      get copyWith =>
          _TripStudentsModelCopyWithImpl<TripStudentsModel, TripStudentsModel>(
              this as TripStudentsModel, $identity, $identity);
  @override
  String toString() {
    return TripStudentsModelMapper.ensureInitialized()
        .stringifyValue(this as TripStudentsModel);
  }

  @override
  bool operator ==(Object other) {
    return TripStudentsModelMapper.ensureInitialized()
        .equalsValue(this as TripStudentsModel, other);
  }

  @override
  int get hashCode {
    return TripStudentsModelMapper.ensureInitialized()
        .hashValue(this as TripStudentsModel);
  }
}

extension TripStudentsModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TripStudentsModel, $Out> {
  TripStudentsModelCopyWith<$R, TripStudentsModel, $Out>
      get $asTripStudentsModel => $base
          .as((v, t, t2) => _TripStudentsModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TripStudentsModelCopyWith<$R, $In extends TripStudentsModel,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? pickupStatus,
      String? dropoffStatus,
      String? id,
      String? tripId,
      String? studentId,
      DateTime? dropoffTime,
      DateTime? pickupTime});
  TripStudentsModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TripStudentsModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TripStudentsModel, $Out>
    implements TripStudentsModelCopyWith<$R, TripStudentsModel, $Out> {
  _TripStudentsModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TripStudentsModel> $mapper =
      TripStudentsModelMapper.ensureInitialized();
  @override
  $R call(
          {String? pickupStatus,
          String? dropoffStatus,
          Object? id = $none,
          String? tripId,
          String? studentId,
          Object? dropoffTime = $none,
          Object? pickupTime = $none}) =>
      $apply(FieldCopyWithData({
        if (pickupStatus != null) #pickupStatus: pickupStatus,
        if (dropoffStatus != null) #dropoffStatus: dropoffStatus,
        if (id != $none) #id: id,
        if (tripId != null) #tripId: tripId,
        if (studentId != null) #studentId: studentId,
        if (dropoffTime != $none) #dropoffTime: dropoffTime,
        if (pickupTime != $none) #pickupTime: pickupTime
      }));
  @override
  TripStudentsModel $make(CopyWithData data) => TripStudentsModel(
      pickupStatus: data.get(#pickupStatus, or: $value.pickupStatus),
      dropoffStatus: data.get(#dropoffStatus, or: $value.dropoffStatus),
      id: data.get(#id, or: $value.id),
      tripId: data.get(#tripId, or: $value.tripId),
      studentId: data.get(#studentId, or: $value.studentId),
      dropoffTime: data.get(#dropoffTime, or: $value.dropoffTime),
      pickupTime: data.get(#pickupTime, or: $value.pickupTime));

  @override
  TripStudentsModelCopyWith<$R2, TripStudentsModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TripStudentsModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
