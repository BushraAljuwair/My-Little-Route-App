// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'trip_model.dart';

class TripModelMapper extends ClassMapperBase<TripModel> {
  TripModelMapper._();

  static TripModelMapper? _instance;
  static TripModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TripModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TripModel';

  static String? _$id(TripModel v) => v.id;
  static const Field<TripModel, String> _f$id = Field('id', _$id, opt: true);
  static String _$busId(TripModel v) => v.busId;
  static const Field<TripModel, String> _f$busId =
      Field('busId', _$busId, key: r'bus_id');
  static String _$driverId(TripModel v) => v.driverId;
  static const Field<TripModel, String> _f$driverId =
      Field('driverId', _$driverId, key: r'driver_id');
  static String? _$tripType(TripModel v) => v.tripType;
  static const Field<TripModel, String> _f$tripType =
      Field('tripType', _$tripType, key: r'trip_type');
  static DateTime? _$scheduledTime(TripModel v) => v.scheduledTime;
  static const Field<TripModel, DateTime> _f$scheduledTime =
      Field('scheduledTime', _$scheduledTime, key: r'scheduled_time');
  static String? _$status(TripModel v) => v.status;
  static const Field<TripModel, String> _f$status = Field('status', _$status);

  @override
  final MappableFields<TripModel> fields = const {
    #id: _f$id,
    #busId: _f$busId,
    #driverId: _f$driverId,
    #tripType: _f$tripType,
    #scheduledTime: _f$scheduledTime,
    #status: _f$status,
  };

  static TripModel _instantiate(DecodingData data) {
    return TripModel(
        id: data.dec(_f$id),
        busId: data.dec(_f$busId),
        driverId: data.dec(_f$driverId),
        tripType: data.dec(_f$tripType),
        scheduledTime: data.dec(_f$scheduledTime),
        status: data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static TripModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TripModel>(map);
  }

  static TripModel fromJson(String json) {
    return ensureInitialized().decodeJson<TripModel>(json);
  }
}

mixin TripModelMappable {
  String toJson() {
    return TripModelMapper.ensureInitialized()
        .encodeJson<TripModel>(this as TripModel);
  }

  Map<String, dynamic> toMap() {
    return TripModelMapper.ensureInitialized()
        .encodeMap<TripModel>(this as TripModel);
  }

  TripModelCopyWith<TripModel, TripModel, TripModel> get copyWith =>
      _TripModelCopyWithImpl<TripModel, TripModel>(
          this as TripModel, $identity, $identity);
  @override
  String toString() {
    return TripModelMapper.ensureInitialized()
        .stringifyValue(this as TripModel);
  }

  @override
  bool operator ==(Object other) {
    return TripModelMapper.ensureInitialized()
        .equalsValue(this as TripModel, other);
  }

  @override
  int get hashCode {
    return TripModelMapper.ensureInitialized().hashValue(this as TripModel);
  }
}

extension TripModelValueCopy<$R, $Out> on ObjectCopyWith<$R, TripModel, $Out> {
  TripModelCopyWith<$R, TripModel, $Out> get $asTripModel =>
      $base.as((v, t, t2) => _TripModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TripModelCopyWith<$R, $In extends TripModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? busId,
      String? driverId,
      String? tripType,
      DateTime? scheduledTime,
      String? status});
  TripModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TripModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TripModel, $Out>
    implements TripModelCopyWith<$R, TripModel, $Out> {
  _TripModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TripModel> $mapper =
      TripModelMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          String? busId,
          String? driverId,
          Object? tripType = $none,
          Object? scheduledTime = $none,
          Object? status = $none}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (busId != null) #busId: busId,
        if (driverId != null) #driverId: driverId,
        if (tripType != $none) #tripType: tripType,
        if (scheduledTime != $none) #scheduledTime: scheduledTime,
        if (status != $none) #status: status
      }));
  @override
  TripModel $make(CopyWithData data) => TripModel(
      id: data.get(#id, or: $value.id),
      busId: data.get(#busId, or: $value.busId),
      driverId: data.get(#driverId, or: $value.driverId),
      tripType: data.get(#tripType, or: $value.tripType),
      scheduledTime: data.get(#scheduledTime, or: $value.scheduledTime),
      status: data.get(#status, or: $value.status));

  @override
  TripModelCopyWith<$R2, TripModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TripModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
