// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'bus_locations_model.dart';

class BusLocationsModelMapper extends ClassMapperBase<BusLocationsModel> {
  BusLocationsModelMapper._();

  static BusLocationsModelMapper? _instance;
  static BusLocationsModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BusLocationsModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BusLocationsModel';

  static String? _$id(BusLocationsModel v) => v.id;
  static const Field<BusLocationsModel, String> _f$id = Field('id', _$id);
  static String _$busId(BusLocationsModel v) => v.busId;
  static const Field<BusLocationsModel, String> _f$busId =
      Field('busId', _$busId, key: r'bus_id');
  static String _$latitude(BusLocationsModel v) => v.latitude;
  static const Field<BusLocationsModel, String> _f$latitude =
      Field('latitude', _$latitude);
  static String _$longitude(BusLocationsModel v) => v.longitude;
  static const Field<BusLocationsModel, String> _f$longitude =
      Field('longitude', _$longitude);
  static DateTime? _$timestamp(BusLocationsModel v) => v.timestamp;
  static const Field<BusLocationsModel, DateTime> _f$timestamp =
      Field('timestamp', _$timestamp);

  @override
  final MappableFields<BusLocationsModel> fields = const {
    #id: _f$id,
    #busId: _f$busId,
    #latitude: _f$latitude,
    #longitude: _f$longitude,
    #timestamp: _f$timestamp,
  };

  static BusLocationsModel _instantiate(DecodingData data) {
    return BusLocationsModel(
        id: data.dec(_f$id),
        busId: data.dec(_f$busId),
        latitude: data.dec(_f$latitude),
        longitude: data.dec(_f$longitude),
        timestamp: data.dec(_f$timestamp));
  }

  @override
  final Function instantiate = _instantiate;

  static BusLocationsModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BusLocationsModel>(map);
  }

  static BusLocationsModel fromJson(String json) {
    return ensureInitialized().decodeJson<BusLocationsModel>(json);
  }
}

mixin BusLocationsModelMappable {
  String toJson() {
    return BusLocationsModelMapper.ensureInitialized()
        .encodeJson<BusLocationsModel>(this as BusLocationsModel);
  }

  Map<String, dynamic> toMap() {
    return BusLocationsModelMapper.ensureInitialized()
        .encodeMap<BusLocationsModel>(this as BusLocationsModel);
  }

  BusLocationsModelCopyWith<BusLocationsModel, BusLocationsModel,
          BusLocationsModel>
      get copyWith =>
          _BusLocationsModelCopyWithImpl<BusLocationsModel, BusLocationsModel>(
              this as BusLocationsModel, $identity, $identity);
  @override
  String toString() {
    return BusLocationsModelMapper.ensureInitialized()
        .stringifyValue(this as BusLocationsModel);
  }

  @override
  bool operator ==(Object other) {
    return BusLocationsModelMapper.ensureInitialized()
        .equalsValue(this as BusLocationsModel, other);
  }

  @override
  int get hashCode {
    return BusLocationsModelMapper.ensureInitialized()
        .hashValue(this as BusLocationsModel);
  }
}

extension BusLocationsModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BusLocationsModel, $Out> {
  BusLocationsModelCopyWith<$R, BusLocationsModel, $Out>
      get $asBusLocationsModel => $base
          .as((v, t, t2) => _BusLocationsModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BusLocationsModelCopyWith<$R, $In extends BusLocationsModel,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? busId,
      String? latitude,
      String? longitude,
      DateTime? timestamp});
  BusLocationsModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _BusLocationsModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BusLocationsModel, $Out>
    implements BusLocationsModelCopyWith<$R, BusLocationsModel, $Out> {
  _BusLocationsModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BusLocationsModel> $mapper =
      BusLocationsModelMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          String? busId,
          String? latitude,
          String? longitude,
          Object? timestamp = $none}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (busId != null) #busId: busId,
        if (latitude != null) #latitude: latitude,
        if (longitude != null) #longitude: longitude,
        if (timestamp != $none) #timestamp: timestamp
      }));
  @override
  BusLocationsModel $make(CopyWithData data) => BusLocationsModel(
      id: data.get(#id, or: $value.id),
      busId: data.get(#busId, or: $value.busId),
      latitude: data.get(#latitude, or: $value.latitude),
      longitude: data.get(#longitude, or: $value.longitude),
      timestamp: data.get(#timestamp, or: $value.timestamp));

  @override
  BusLocationsModelCopyWith<$R2, BusLocationsModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _BusLocationsModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
