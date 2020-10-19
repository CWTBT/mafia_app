import 'package:flutter_test/flutter_test.dart';
import 'package:text_messenger/Data.dart';

void main(){
  test('Test Add Friend', () {
    User me = new User("Me", "127.0.0.1");
    Data data = new Data();
    data.addUser(me);
    expect(me.ipAddr, data.playerIPs.last);
    expect(me.name, data.connectedPlayers.last);
  });
  test('Test Send Message', () async{
    User me = new User("Me", "127.0.0.1");
    Data data = new Data();
    data.addUser(me);
    var socketOutcome = data.send(Message("Sending message", me), me.ipAddr);
    expect(socketOutcome, SocketOutcome);
  });
  test('Test Receive Message', () async{
    User me = new User("Me", "127.0.0.1");
    Data data = new Data();
    data.addUser(me);
    data.send(Message("Sending message", me), me.ipAddr);
    expect(data.messageHistory.last.contents, "Sending message");
  });
  test('Test Add Player on Receiving Message', () async{
    User me = new User("Me", "192.168.0.12");
    Data meData = new Data();
    User you = new User("you", "192.168.0.11");
    Data youData = new Data();
    meData.send(Message("Sending message", you), you.ipAddr);
    expect(youData.connectedPlayers.last, me.name);
    expect(youData.playerIPs.last, me.ipAddr);
  });
  test('Test Add Player Another User has Added', () async{
    User me = new User("Me", "192.168.0.12");
    Data meData = new Data();
    meData.addUser(User("anon", "98.22.46.80"));
    meData.addUser(User("anon1", "108.175.240.65"));
    User you = new User("you", "192.168.0.11");
    Data youData = new Data();
    meData.addUser(you);
    meData.send(Message("sending playerList", me), you.ipAddr);
    expect(youData.connectedPlayers.length, meData.connectedPlayers.length);
    expect(youData.playerIPs.length, meData.playerIPs.length);
  });
  /*test('Test 8 Players', () async{

  });
   */
}