import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  final _brokerURL = "0b8b0cbaf5474895b80986d6ea80a567.s2.eu.hivemq.cloud";
  final _brokerPort = 8883;
  final _clientIdentifier = "flutter_application";
  final _username = "application";
  final _password = "qamwog-hykfar-1maNci";

  late MqttServerClient client;

  MQTTService() {
    client =
        MqttServerClient.withPort(_brokerURL, _clientIdentifier, _brokerPort);
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  Future<void> connect() async {
    try {
      print('Client is connecting.');
      await client.connect(_username, _password);
    } on Exception catch (e) {
      print('ERROR: Exception while connecting: $e');
      client.disconnect();
    }
  }

  bool subscribe(String topicName, Function(String) callback) {
    if (!_isConnected()) {
      print('Client is not connected, cannot subscribe.');
      return false;
    }
    print('Subscribing to the $topicName topic.');
    client.subscribe(topicName, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final message = c[0].payload as MqttPublishMessage;
      final content =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      callback(content);
    });
    return true;
  }

  bool publish(String topicName, String message) {
    if (!_isConnected()) {
      print('Client is not connected, cannot subscribe.');
      return false;
    }
    print('Publishing message "$message" to topic $topicName.');
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topicName, MqttQos.atLeastOnce, builder.payload!);
    return true;
  }

  bool _isConnected() {
    return client.connectionStatus!.state == MqttConnectionState.connected;
  }

  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic.');
  }

  void _onDisconnected() {
    print('Client disconnected gracefully.');
  }

  void _onConnected() {
    print('Client connection was sucessful.');
  }
}
