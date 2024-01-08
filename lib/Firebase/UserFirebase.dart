import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

import '../Custom Data/Users.dart';
import '../Enums/CreateAccount Status.dart';
import '../Enums/Sign In Status.dart';

User? user;

class UsersFirebase{
  Users users = Users(
      firstName: '',
      lastName: '',
      email: '',
      birthday: DateTime.now(),
      id: '',
      token: '',
      activeAccount: true,
      admin: false,
      phoneNumber: '',
      notificationsOn: true,
      version: 1.1,
      totalServingSize:0);


  Future<CreateAccountStatus>createUser(Users users, String password) async {

    try {
      //try creating user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: users.email, password: password);

      user = userCredential.user;

      users.id = user!.uid ?? '';


      //client.token = await PushNotifications().initNotifications();

      //create a reference to new client into 'clients' database. Storing with id 'user.id'
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .withConverter(
          fromFirestore: Users.fromFireStore,
          toFirestore: (Users users, options) => users.toFireStore())
          .doc(user!.uid);

      docRef.set(users);
    } on FirebaseException catch (e) {
      print(e);
      if(e.code == 'email-already-in-use'){
        return CreateAccountStatus.emailInUse;
      }else if(e.code == 'invalid-email'){
        return CreateAccountStatus.incorrectEmailFormat;
      }else if(e.code == 'operation-not-allowed'){
        return CreateAccountStatus.emailInUse;
      }else if(e.code=='weak-password'){
        return CreateAccountStatus.weakPassword;
      }else{
        return CreateAccountStatus.passwordNotLongEnough;
      }
    }


    return CreateAccountStatus.success;
  }

  Future<SignInStatus> signIn(String email, String password) async {
    print('email: $email');
    print("pass: $password");
    try {
      print('here');

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      print('here');
      user = userCredential.user;
    } on FirebaseException catch (e) {
      print("Error: ${e}");
      if (e.code == 'invalid-email') {
        return SignInStatus.invalidEmail;
      } else if (e.code == 'user-disabled') {
        return SignInStatus.disabled;
      } else if (e.code == 'user-not-found') {
        return SignInStatus.userNotFound;
      } else if (e.code == 'wrong-password') {
        return SignInStatus.wrongPassword;
      } else {
        return SignInStatus.invalidCred;
      }
    }

    return SignInStatus.success;
  }

  Future<Users> getUser() async {
    //if user is logged in
    if (FirebaseAuth.instance.currentUser != null) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .withConverter(
          fromFirestore: Users.fromFireStore,
          toFirestore: (Users users, options) => users.toFireStore());

      final docSnap = await docRef.get(); // get data

      return docSnap.data()!; //return data
    } else {
      //return empty client variable
      return Users(
          firstName: 'Not Signed In',
          lastName: "",
          email: '',
          birthday: DateTime.now(),
          id: '',
          token: '',
          activeAccount: false,
          admin: false,
          phoneNumber: '',
          notificationsOn: true,
          cartTotal: 0.00,
          version: 1.1,
          totalServingSize:0);
    }
  }


  signOutUser(){
    FirebaseAuth.instance.signOut();

  }

  ///Sign in with Google. If email exists in database, it will use email to obtain client object from firestore. If it does not exist, client object will be created and stored in firestore
  Future<Users> signInWithGoogle() async {


    //begin interactive process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();


    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);


    //search through database to see if client exists
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: gUser.email)
        .withConverter(
        fromFirestore: Users.fromFireStore,
        toFirestore: (Users users, options) => users.toFireStore());

    //reference document if we need to create a new client in database

    var docSnap = await docRef.get().then((value) async => {
      for (var docSnapshot in value.docs)
        {
          //if email already exists, assign client variable. If item does not exist, no client variable will be return and method continues on

          users = await getUserViaEmail(docSnapshot.data().email),
          //method created above
          print("User gotten: ${users.email}")
        }
    });

    print("Google User: ${gUser.email}, ${gUser.displayName}");
    print("Google User: ${users.email}, ${users.firstName}");

    await FirebaseAuth.instance
        .signInWithCredential(credential); //sign in user with google

    var uuid = Uuid();
    var uniqueID = uuid.v4();

    final createRef = FirebaseFirestore.instance
        .collection('users')
        .withConverter(
        fromFirestore: Users.fromFireStore,
        toFirestore: (Users users, options) => users.toFireStore())
        .doc(FirebaseAuth.instance.currentUser!.uid);

    if (users.email == '') {
      //if client is still empty, create client in database
      users.email = gUser.email;
      users.token = '';
      users.birthday = DateTime.now();
      users.activeAccount = true;
      users.admin = false;
      users.phoneNumber = '';
      users.notificationsOn = true;
      users.id = FirebaseAuth.instance.currentUser!.uid;
      users.version =  1.0;

      //split display name into first and last name client variables (google has it as a whole name)

      var name =
      gUser.displayName!.split(' '); //get first occurrence of a space
      String firstName = name[0].trim();

      String lastName = '';
      if (name.length > 1) {
        //to make sure we don't go beyond scope and cause app to crash
        lastName = name[1].trim();
      }

      //store names in client variable
      users.firstName = firstName;
      users.lastName = lastName;

      await createRef.set(users);
    }

    return users;
  }

  Future<Users> getUserViaEmail(String email) async {
    //if user is logged in

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .withConverter(
        fromFirestore: Users.fromFireStore,
        toFirestore: (Users users, options) => users.toFireStore())
        .get()
        .then((value) => {
      for (var snap in value.docs) {users = snap.data()}
    });

    return users; //return data
  }


  Future<Users> getUserViaId(String id) async {
    //if user is logged in


    print("User ID ${id}");


    final docRef = FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .withConverter(
        fromFirestore: Users.fromFireStore,
        toFirestore: (Users users, options) => users.toFireStore())
        .get()
        .then((value) async => {
      for (var snap in value.docs) {users = await snap.data(),
        print('In for loop ${users.firstName}')
      }
    });

    return users; //return data
  }


  Future toggleNotification(Users user) async{

    final createRef =
    FirebaseFirestore.instance.collection('users').doc(user.id);

    createRef.update({'notificationsOn': user.notificationsOn});
  }

  Future updateUser(Users users)async{

    final createRef =
    FirebaseFirestore.instance.collection('users').doc(users.id);

    createRef.update({'firstName': users.firstName});
    createRef.update({'lastName': users.lastName});
    createRef.update({'phoneNumber': users.phoneNumber});

  }


}