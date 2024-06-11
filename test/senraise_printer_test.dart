import 'dart:ffi';

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:senraise_printer/senraise_printer.dart';
import 'package:senraise_printer/senraise_printer_platform_interface.dart';
import 'package:senraise_printer/senraise_printer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSenraisePrinterPlatform
    with MockPlatformInterfaceMixin
    implements SenraisePrinterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getServiceVersion() {
    // TODO: implement getServiceVersion
    throw UnimplementedError();
  }

  @override
  Future<Void?> nextLine(int line) {
    // TODO: implement nextLine
    throw UnimplementedError();
  }

  @override
  Future<Void?> printBarCode(String data, int symbology, int height, int width) {
    // TODO: implement printBarCode
    throw UnimplementedError();
  }

  @override
  Future<Void?> printEpson(Uint8List bytes) {
    // TODO: implement printEpson
    throw UnimplementedError();
  }

  @override
  Future<Void?> printPic(Uint8List pic) {
    // TODO: implement printPic
    throw UnimplementedError();
  }

  @override
  Future<Void?> printQRCode(String data, int modulesize, int errorlevel) {
    // TODO: implement printQRCode
    throw UnimplementedError();
  }

  @override
  Future<Void?> printText(String text) {
    // TODO: implement printText
    throw UnimplementedError();
  }

  @override
  Future<Void?> setAlignment(int alignment) {
    // TODO: implement setAlignment
    throw UnimplementedError();
  }

  @override
  Future<Void?> setCode(String code) {
    // TODO: implement setCode
    throw UnimplementedError();
  }

  @override
  Future<Void?> setDark(int value) {
    // TODO: implement setDark
    throw UnimplementedError();
  }

  @override
  Future<Void?> setLineHeight(double lineHeight) {
    // TODO: implement setLineHeight
    throw UnimplementedError();
  }

  @override
  Future<Void?> setTextBold(bool bold) {
    // TODO: implement setTextBold
    throw UnimplementedError();
  }

  @override
  Future<Void?> setTextDoubleHeight(bool enable) {
    // TODO: implement setTextDoubleHeight
    throw UnimplementedError();
  }

  @override
  Future<Void?> setTextDoubleWidth(bool enable) {
    // TODO: implement setTextDoubleWidth
    throw UnimplementedError();
  }

  @override
  Future<Void?> setTextSize(double textSize) {
    // TODO: implement setTextSize
    throw UnimplementedError();
  }
}

void main() {
  final SenraisePrinterPlatform initialPlatform = SenraisePrinterPlatform.instance;

  test('$MethodChannelSenraisePrinter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSenraisePrinter>());
  });

  test('getPlatformVersion', () async {
    SenraisePrinter senraisePrinterPlugin = SenraisePrinter();
    MockSenraisePrinterPlatform fakePlatform = MockSenraisePrinterPlatform();
    SenraisePrinterPlatform.instance = fakePlatform;

    expect(await senraisePrinterPlugin.getPlatformVersion(), '42');
  });
}
