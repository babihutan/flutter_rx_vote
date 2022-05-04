import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rx_vote/person_data.dart';
import 'package:flutter_rx_vote/poll.dart';
import 'package:flutter_rx_vote/vote.dart';
import 'package:rxdart/rxdart.dart';

var dbService = DatabaseService();

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();

  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal() {
    debugPrint('[db] ctor');
    _fetchPersons();
    _fetchPolls();
  }

  final _myPersonIdSubject = BehaviorSubject<String>();
  Stream<String> get myPersonId => _myPersonIdSubject.stream;

  final _personsSubject = BehaviorSubject<List<Person>>();
  Stream<List<Person>> get persons => _personsSubject.stream;

  final _personsMapSubject = BehaviorSubject.seeded(<String, Person>{});
  Stream<Map<String, Person>> get personsMap => _personsMapSubject.stream;

  final _pollsSubject = BehaviorSubject<List<Poll>>();
  Stream<List<Poll>> get polls => _pollsSubject.stream;

  final _pollsMapSubject = BehaviorSubject.seeded(<String, Poll>{});
  Stream<Map<String, Poll>> get pollsMap => _pollsMapSubject.stream;

  final _votesMapSubject = BehaviorSubject.seeded(<String, List<Vote>>{});
  Stream<Map<String, List<Vote>>> get votesMap => _votesMapSubject.stream;

  Stream<Person?> get me => Rx.combineLatest2(myPersonId, personsMap,
          (String myId, Map<String, Person> map) {
        return map[myId];
      });

  Stream<String> get xxx => me
      .map((Person? me) => me!.name.toUpperCase())
      .map((event) => event.toLowerCase());

  _fetchPersons() {
    FirebaseFirestore.instance
        .collection(Person.COLLECTION_NAME)
        .snapshots()
        .listen((QuerySnapshot qs) {
      debugPrint('There are ${qs.docs.length} persons');
      if (qs.docs.isEmpty) {
        if (qs.docs.isEmpty) {
          Person.initPersons();
          return;
        }
      }
      final List<Person> list = [];
      final v = _personsMapSubject.value;
      for (DocumentSnapshot ds in qs.docs) {
        final p = Person.fromSnapshot(ds);
        list.add(p);
        v[p.personId] = p;
      }
      list.sort();
      _personsSubject.sink.add(list);
      _personsMapSubject.sink.add(v);
    });
  }

  _fetchPolls() {
    FirebaseFirestore.instance
        .collection(Poll.COLLECTION_NAME)
        .snapshots()
        .listen((QuerySnapshot qs) {
      debugPrint('There are ${qs.docs.length} polls');
      if (qs.docs.isEmpty) {
        Poll.initPolls();
        return;
      }
      final List<Poll> list = [];
      final v = _pollsMapSubject.value;
      for (DocumentSnapshot ds in qs.docs) {
        final p = Poll.fromSnapshot(ds);
        list.add(p);
        v[p.pollId] = p;
      }
      list.sort();
      _pollsSubject.sink.add(list);
      _pollsMapSubject.sink.add(v);
    });
  }

  fetchVotes({required String pollId}) {
    if (_votesMapSubject.value.containsKey(pollId)) {
      return;
    }
    FirebaseFirestore.instance
        .collection(
            '${Poll.COLLECTION_NAME}/$pollId/${Vote.SUB_COLLECTION_NAME}')
        .snapshots()
        .listen((QuerySnapshot qs) {
      debugPrint('There are ${qs.docs.length} votes for poll $pollId');
      final List<Vote> list = [];
      for (DocumentSnapshot ds in qs.docs) {
        final vote = Vote.fromSnapshot(ds, pollId: pollId);
        list.add(vote);
      }
      final v = _votesMapSubject.value;
      v[pollId] = list;
      _votesMapSubject.sink.add(v);
    });
  }

  login(String email) async {
    final qs = await FirebaseFirestore.instance
        .collection(Person.COLLECTION_NAME)
        .where(Person.EMAIL, isEqualTo: email)
        .get();
    if (qs.docs.length > 1) {
      throw Exception('Email is not unique');
    } else if (qs.docs.length == 1) {
      _myPersonIdSubject.sink.add(qs.docs[0].id);
    } else {
      final personId = await Person.create(name: '?', email: email);
      _myPersonIdSubject.sink.add(personId);
    }
  }

  dispose() {
    _personsSubject.close();
    _pollsSubject.close();
    _personsMapSubject.close();
    _pollsMapSubject.close();
    _myPersonIdSubject.close();
    _votesMapSubject.close();
  }
}
