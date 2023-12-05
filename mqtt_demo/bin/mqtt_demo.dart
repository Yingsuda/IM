import 'package:mqtt_demo/mqtt_demo.dart' as mqtt_demo;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:async';
import 'dart:io';

final client = MqttServerClient('broker-cn.emqx.io', '1883');

//Future ： ？什么意思
//async  ：  await  怎么用
Future main() async {
  print('Hello world: ${mqtt_demo.calculate()}!');

//Connect MQTT Server
  client.logging(on: false); //是否打印log
  client.keepAlivePeriod = 60;

  client.onDisconnected = disConnect;
  client.onConnected = connect;
  client.pongCallback = pong;

  //运行时常量
  final connMess = MqttConnectMessage()
      .withClientIdentifier('dart_client_123') //go_client_ID
      .withWillTopic('willtopic') //?
      .withWillMessage('willMessage') //？
      .startClean() //？
      .withWillQos(MqttQos.atLeastOnce); //QOS

  print('client connecting......');

  client.connectionMessage = connMess; //go_mqtthandle

  //how to use try？
  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    print('client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    print('socket exception - $e');
    client.disconnect();
  }

  //? 可以为null         ！是什么意思
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('client OK');
  } else {
    print(
        'client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  //订阅

  //发布

  //用户注册

  //send receive message and show in cli
  return 0;
}

void disConnect() {
  print('OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('OnDisconnected callback is solicited, this is correct');
  }
  exit(-1);
}

void connect() {
  print('Mqtt Client connection was sucessful');
}

void pong() {
  print('Ping response client callback invoked');
}
