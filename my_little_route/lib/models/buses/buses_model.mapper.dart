// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'buses_model.dart';

class BusesModelMapper extends ClassMapperBase<BusesModel> {
  BusesModelMapper._();

  static BusesModelMapper? _instance;
  static BusesModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BusesModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BusesModel';

  static String? _$id(BusesModel v) => v.id;
  static const Field<BusesModel, String> _f$id = Field('id', _$id);
  static String _$plateNumber(BusesModel v) => v.plateNumber;
  static const Field<BusesModel, String> _f$plateNumber =
      Field('plateNumber', _$plateNumber, key: r'plate_number');
  static int _$capacity(BusesModel v) => v.capacity;
  static const Field<BusesModel, int> _f$capacity =
      Field('capacity', _$capacity);
  static String _$driverId(BusesModel v) => v.driverId;
  static const Field<BusesModel, String> _f$driverId =
      Field('driverId', _$driverId, key: r'driver_id');

  @override
  final MappableFields<BusesModel> fields = const {
    #id: _f$id,
    #plateNumber: _f$plateNumber,
    #capacity: _f$capacity,
    #driverId: _f$driverId,
  };

  static BusesModel _instantiate(DecodingData data) {
    return BusesModel(
        id: data.dec(_f$id),
        plateNumber: data.dec(_f$plateNumber),
        capacity: data.dec(_f$capacity),
        driverId: data.dec(_f$driverId));
  }

  @override
  final Function instantiate = _instantiate;

  static BusesModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BusesModel>(map);
  }

  static BusesModel fromJson(String json) {
    return ensureInitialized().decodeJson<BusesModel>(json);
  }
}

mixin BusesModelMappable {
  String toJson() {
    return BusesModelMapper.ensureInitialized()
        .encodeJson<BusesModel>(this as BusesModel);
  }

  Map<String, dynamic> toMap() {
    return BusesModelMapper.ensureInitialized()
        .encodeMap<BusesModel>(this as BusesModel);
  }

  BusesModelCopyWith<BusesModel, BusesModel, BusesModel> get copyWith =>
      _BusesModelCopyWithImpl<BusesModel, BusesModel>(
          this as BusesModel, $identity, $identity);
  @override
  String toString() {
    return BusesModelMapper.ensureInitialized()
        .stringifyValue(this as BusesModel);
  }

  @override
  bool operator ==(Object other) {
    return BusesModelMapper.ensureInitialized()
        .equalsValue(this as BusesModel, other);
  }

  @override
  int get hashCode {
    return BusesModelMapper.ensureInitialized().hashValue(this as BusesModel);
  }
}

extension BusesModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BusesModel, $Out> {
  BusesModelCopyWith<$R, BusesModel, $Out> get $asBusesModel =>
      $base.as((v, t, t2) => _BusesModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BusesModelCopyWith<$R, $In extends BusesModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? plateNumber, int? capacity, String? driverId});
  BusesModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BusesModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BusesModel, $Out>
    implements BusesModelCopyWith<$R, BusesModel, $Out> {
  _BusesModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BusesModel> $mapper =
      BusesModelMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          String? plateNumber,
          int? capacity,
          String? driverId}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (plateNumber != null) #plateNumber: plateNumber,
        if (capacity != null) #capacity: capacity,
        if (driverId != null) #driverId: driverId
      }));
  @override
  BusesModel $make(CopyWithData data) => BusesModel(
      id: data.get(#id, or: $value.id),
      plateNumber: data.get(#plateNumber, or: $value.plateNumber),
      capacity: data.get(#capacity, or: $value.capacity),
      driverId: data.get(#driverId, or: $value.driverId));

  @override
  BusesModelCopyWith<$R2, BusesModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _BusesModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
