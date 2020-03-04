/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async{
  final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
//  final AuthResult authResult = await _auth.signInWithCredential(credential);
//  final FirebaseUser user = authResult.user;
  final FirebaseUser user = await _auth.signInWithCredential(credential);

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser curentUser = await _auth.currentUser();
  assert(user.uid == curentUser.uid);

  return "signInWithGoogle succeeded: $user";
}

void signOutGoogle()async{
  await _googleSignIn.signOut();
  
  print("User Sign out");
}

Future<String> signInWithEmailPassword(String email, String password)async{
  return (await _auth.signInWithEmailAndPassword(email: email, password: password)).uid;
}*/
