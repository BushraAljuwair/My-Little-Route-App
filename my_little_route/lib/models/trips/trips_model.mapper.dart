// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'trips_model.dart';

class TripsModelMapper extends ClassMapperBase<TripsModel> {
  TripsModelMapper._();

  static TripsModelMapper? _instance;
  static TripsModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TripsModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TripsModel';

  static String? _$id(TripsModel v) => v.id;
  static const Field<TripsModel, String> _f$id = Field('id', _$id);
  static String _$busId(TripsModel v) => v.busId;
  static const Field<TripsModel, String> _f$busId =
      Field('busId', _$busId, key: r'bus_id');
  static String _$driverId(TripsModel v) => v.driverId;
  static const Field<TripsModel, String> _f$driverId =
      Field('driverId', _$driverId, key: r'driver_id');
  static bool _$tripType(TripsModel v) => v.tripType;
  static const Field<TripsModel, bool> _f$tripType =
      Field('tripType', _$tripType, key: r'trip_type');
  static DateTime? _$scheduledTime(TripsModel v) => v.scheduledTime;
  static const Field<TripsModel, DateTime> _f$scheduledTime =
      Field('scheduledTime', _$scheduledTime, key: r'scheduled_time');
  static String? _$status(TripsModel v) => v.status;
  static const Field<TripsModel, String> _f$status = Field('status', _$status);

  @override
  final MappableFields<TripsModel> fields = const {
    #id: _f$id,
    #busId: _f$busId,
    #driverId: _f$driverId,
    #tripType: _f$tripType,
    #scheduledTime: _f$scheduledTime,
    #status: _f$status,
  };

  static TripsModel _instantiate(DecodingData data) {
    return TripsModel(
        id: data.dec(_f$id),
        busId: data.dec(_f$busId),
        driverId: data.dec(_f$driverId),
        tripType: data.dec(_f$tripType),
        scheduledTime: data.dec(_f$scheduledTime),
        status: data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static TripsModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TripsModel>(map);
  }

  static TripsModel fromJson(String json) {
    return ensureInitialized().decodeJson<TripsModel>(json);
  }
}

mixin TripsModelMappable {
  String toJson() {
    return TripsModelMapper.ensureInitialized()
        .encodeJson<TripsModel>(this as TripsModel);
  }

  Map<String, dynamic> toMap() {
    return TripsModelMapper.ensureInitialized()
        .encodeMap<TripsModel>(this as TripsModel);
  }

  TripsModelCopyWith<TripsModel, TripsModel, TripsModel> get copyWith =>
      _TripsModelCopyWithImpl<TripsModel, TripsModel>(
          this as TripsModel, $identity, $identity);
  @override
  String toString() {
    return TripsModelMapper.ensureInitialized()
        .stringifyValue(this as TripsModel);
  }

  @override
  bool operator ==(Object other) {
    return TripsModelMapper.ensureInitialized()
        .equalsValue(this as TripsModel, other);
  }

  @override
  int get hashCode {
    return TripsModelMapper.ensureInitialized().hashValue(this as TripsModel);
  }
}

extension TripsModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TripsModel, $Out> {
  TripsModelCopyWith<$R, TripsModel, $Out> get $asTripsModel =>
      $base.as((v, t, t2) => _TripsModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TripsModelCopyWith<$R, $In extends TripsModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? busId,
      String? driverId,
      bool? tripType,
      DateTime? scheduledTime,
      String? status});
  TripsModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TripsModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TripsModel, $Out>
    implements TripsModelCopyWith<$R, TripsModel, $Out> {
  _TripsModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TripsModel> $mapper =
      TripsModelMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          String? busId,
          String? driverId,
          bool? tripType,
          Object? scheduledTime = $none,
          Object? status = $none}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (busId != null) #busId: busId,
        if (driverId != null) #driverId: driverId,
        if (tripType != null) #tripType: tripType,
        if (scheduledTime != $none) #scheduledTime: scheduledTime,
        if (status != $none) #status: status
      }));
  @override
  TripsModel $make(CopyWithData data) => TripsModel(
      id: data.get(#id, or: $value.id),
      busId: data.get(#busId, or: $value.busId),
      driverId: data.get(#driverId, or: $value.driverId),
      tripType: data.get(#tripType, or: $value.tripType),
      scheduledTime: data.get(#scheduledTime, or: $value.scheduledTime),
      status: data.get(#status, or: $value.status));

  @override
  TripsModelCopyWith<$R2, TripsModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TripsModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
