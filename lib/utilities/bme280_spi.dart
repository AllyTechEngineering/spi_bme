import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef GetBme280IdNative = Int32 Function(Pointer<Utf8> spiDevice, Pointer<Uint8> chipId);
typedef GetBme280IdDart = int Function(Pointer<Utf8> spiDevice, Pointer<Uint8> chipId);

class Bme280Spi {
  late DynamicLibrary _lib;
  late GetBme280IdDart _getBme280Id;

  Bme280Spi() {
    _lib = DynamicLibrary.open('libbme280_spi.so');
    _getBme280Id = _lib
        .lookup<NativeFunction<GetBme280IdNative>>('get_bme280_id')
        .asFunction();
  }

  int getBme280Id(String spiDevice) {
    final spiDevicePtr = spiDevice.toNativeUtf8();
    final chipIdPtr = calloc<Uint8>();

    final result = _getBme280Id(spiDevicePtr, chipIdPtr);
    final chipId = chipIdPtr.value;

    calloc.free(spiDevicePtr);
    calloc.free(chipIdPtr);

    if (result < 0) {
      throw Exception('Failed to get BME280 ID');
    }

    return chipId;
  }
}