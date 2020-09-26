import 'package:WhatsAppClone/core/models/status.dart';
import 'package:WhatsAppClone/services/auth/user_service.dart';
import 'package:WhatsAppClone/services/locator.dart';
import 'package:WhatsAppClone/views/screens/status/status_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserServiceMock extends Mock implements UserService {}

void main() {
  group('StatusViewModel Test', () {
    // valid username
    var username = 'omergamliel';
    // construct mocked user service
    var userService = UserServiceMock();
    // setup locator
    locator.registerSingleton<UserService>(userService);
    // construct status viewmodel
    var model = StatusViewModel();

    test('initialise viewmodel and get user status stream', () async {
      // status stream getter returns empty stream
      when(userService.statusStream)
          .thenAnswer((realInvocation) => Stream<QuerySnapshot>.empty());
      // initalise model
      model.initalise();
      // verify status stream is called from user service
      verify(userService.statusStream);
      expect(await model.statusStream.isEmpty, true);
    });

    test('should allow delete', () {
      // mock allowDelete method
      when(userService.allowDelete(username))
          .thenAnswer((realInvocation) => true);
      expect(model.allowDelete(username), true);
      // verify service call
      verify(userService.allowDelete(username));
    });

    test('should not allow delete', () {
      // mock allowDelete method
      when(userService.allowDelete(username))
          .thenAnswer((realInvocation) => false);
      expect(model.allowDelete(username), false);
      // verify service call
      verify(userService.allowDelete(username));
    });

    test('should able to print username and status', () {
      var status = 'hello! this is a test status';
      // mock user service username getter
      when(userService.userName).thenAnswer((realInvocation) => username);
      expect(model.username, username);
      print(model.username);
      // verify service call
      verify(userService.userName);
      // mock user service user status getter
      when(userService.userStatus).thenAnswer((realInvocation) => status);
      expect(model.userStatus, status);
      print(model.userStatus);
      // verify service call
      verify(userService.userStatus);

      // mock user service user status getter
      when(userService.userStatus).thenAnswer((realInvocation) => null);
      expect(model.userStatus, null);
      print(model.userStatus);
      // verify service call
      verify(userService.userStatus);
    });

    test('handle delete status with success', () async {
      var status = Status(
          userName: 'username',
          content: 'test',
          timestamp: DateTime.now(),
          id: 'id');
      when(userService.deleteStatus(status))
          .thenAnswer((realInvocation) => Future.value(true));
      // call handle delete status
      await model.handleDeleteStatus(status);
      // verify deleteStatus and getUserStatus is called from user service
      verifyInOrder(
          [userService.deleteStatus(status), userService.getUserStatus()]);
    });

    test('fail to handle delete status', () async {
      var status = Status(
          userName: 'username',
          content: 'test',
          timestamp: DateTime.now(),
          id: 'id');
      when(userService.deleteStatus(status))
          .thenAnswer((realInvocation) => Future.value(false));
      // call handle delete status
      await model.handleDeleteStatus(status);
      // verify deleteStatus is called from user service
      verify(userService.deleteStatus(status));
      // verify never called getUserStatus if delete status is failed
      verifyNever(userService.getUserStatus());
    });
  });
}
