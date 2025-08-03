// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'trip_stop_model.dart';

class TripStopModelMapper extends ClassMapperBase<TripStopModel> {
  TripStopModelMapper._();

  static TripStopModelMapper? _instance;
  static TripStopModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TripStopModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TripStopModel';

  static int _$stopOrder(TripStopModel v) => v.stopOrder;
  static const Field<TripStopModel, int> _f$stopOrder =
      Field('stopOrder', _$stopOrder, key: r'stop_order');
  static String _$tripId(TripStopModel v) => v.tripId;
  static const Field<TripStopModel, String> _f$tripId =
      Field('tripId', _$tripId, key: r'trip_id');
  static String? _$id(TripStopModel v) => v.id;
  static const Field<TripStopModel, String> _f$id =
      Field('id', _$id, opt: true);
  static String _$studentId(TripStopModel v) => v.studentId;
  static const Field<TripStopModel, String> _f$studentId =
      Field('studentId', _$studentId, key: r'student_id');
  static String? _$stopType(TripStopModel v) => v.stopType;
  static const Field<TripStopModel, String> _f$stopType =
      Field('stopType', _$stopType, key: r'stop_type');
  static double? _$longitude(TripStopModel v) => v.longitude;
  static const Field<TripStopModel, double> _f$longitude =
      Field('longitude', _$longitude);
  static double _$latitude(TripStopModel v) => v.latitude;
  static const Field<TripStopModel, double> _f$latitude =
      Field('latitude', _$latitude);
  static String? _$addressDescription(TripStopModel v) => v.addressDescription;
  static const Field<TripStopModel, String> _f$addressDescription = Field(
      'addressDescription', _$addressDescription,
      key: r'address_description');

  @override
  final MappableFields<TripStopModel> fields = const {
    #stopOrder: _f$stopOrder,
    #tripId: _f$tripId,
    #id: _f$id,
    #studentId: _f$studentId,
    #stopType: _f$stopType,
    #longitude: _f$longitude,
    #latitude: _f$latitude,
    #addressDescription: _f$addressDescription,
  };

  static TripStopModel _instantiate(DecodingData data) {
    return TripStopModel(
        stopOrder: data.dec(_f$stopOrder),
        tripId: data.dec(_f$tripId),
        id: data.dec(_f$id),
        studentId: data.dec(_f$studentId),
        stopType: data.dec(_f$stopType),
        longitude: data.dec(_f$longitude),
        latitude: data.dec(_f$latitude),
        addressDescription: data.dec(_f$addressDescription));
  }

  @override
  final Function instantiate = _instantiate;

  static TripStopModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TripStopModel>(map);
  }

  static TripStopModel fromJson(String json) {
    return ensureInitialized().decodeJson<TripStopModel>(json);
  }
}

mixin TripStopModelMappable {
  String toJson() {
    return TripStopModelMapper.ensureInitialized()
        .encodeJson<TripStopModel>(this as TripStopModel);
  }

  Map<String, dynamic> toMap() {
    return TripStopModelMapper.ensureInitialized()
        .encodeMap<TripStopModel>(this as TripStopModel);
  }

  TripStopModelCopyWith<TripStopModel, TripStopModel, TripStopModel>
      get copyWith => _TripStopModelCopyWithImpl<TripStopModel, TripStopModel>(
          this as TripStopModel, $identity, $identity);
  @override
  String toString() {
    return TripStopModelMapper.ensureInitialized()
        .stringifyValue(this as TripStopModel);
  }

  @override
  bool operator ==(Object other) {
    return TripStopModelMapper.ensureInitialized()
        .equalsValue(this as TripStopModel, other);
  }

  @override
  int get hashCode {
    return TripStopModelMapper.ensureInitialized()
        .hashValue(this as TripStopModel);
  }
}

extension TripStopModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TripStopModel, $Out> {
  TripStopModelCopyWith<$R, TripStopModel, $Out> get $asTripStopModel =>
      $base.as((v, t, t2) => _TripStopModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TripStopModelCopyWith<$R, $In extends TripStopModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? stopOrder,
      String? tripId,
      String? id,
      String? studentId,
      String? stopType,
      double? longitude,
      double? latitude,
      String? addressDescription});
  TripStopModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TripStopModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TripStopModel, $Out>
    implements TripStopModelCopyWith<$R, TripStopModel, $Out> {
  _TripStopModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TripStopModel> $mapper =
      TripStopModelMapper.ensureInitialized();
  @override
  $R call(
          {int? stopOrder,
          String? tripId,
          Object? id = $none,
          String? studentId,
          Object? stopType = $none,
          Object? longitude = $none,
          double? latitude,
          Object? addressDescription = $none}) =>
      $apply(FieldCopyWithData({
        if (stopOrder != null) #stopOrder: stopOrder,
        if (tripId != null) #tripId: tripId,
        if (id != $none) #id: id,
        if (studentId != null) #studentId: studentId,
        if (stopType != $none) #stopType: stopType,
        if (longitude != $none) #longitude: longitude,
        if (latitude != null) #latitude: latitude,
        if (addressDescription != $none) #addressDescription: addressDescription
      }));
  @override
  TripStopModel $make(CopyWithData data) => TripStopModel(
      stopOrder: data.get(#stopOrder, or: $value.stopOrder),
      tripId: data.get(#tripId, or: $value.tripId),
      id: data.get(#id, or: $value.id),
      studentId: data.get(#studentId, or: $value.studentId),
      stopType: data.get(#stopType, or: $value.stopType),
      longitude: data.get(#longitude, or: $value.longitude),
      latitude: data.get(#latitude, or: $value.latitude),
      addressDescription:
          data.get(#addressDescription, or: $value.addressDescription));

  @override
  TripStopModelCopyWith<$R2, TripStopModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TripStopModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
