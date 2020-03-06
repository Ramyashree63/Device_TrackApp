import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//final FirebaseAuth _auth = FirebaseAuth.instance;
//final GoogleSignIn googleSignIn = new GoogleSignIn();
//
//Future<FirebaseUser> signInWithGoogle() async{
//
//  GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//  GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//
//  final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
//  final FirebaseUser user = await _auth.signInWithCredential(credential);
//
//
//  final FirebaseUser currentUser = await _auth.currentUser();
//  assert(user.uid == currentUser.uid);
//
//  print("UserName: ${user.displayName}");
//  print("Email: ${user.email}");
//  return user;
//}
////
////void signOutGoogle()async{
////  await googleSignIn.signOut();
////  print("User Sign out");
////}
////
////Future<String> signInWithEmailPassword(String email, String password)async{
////  return (await _auth.signInWithEmailAndPassword(email: email, password: password)).uid;
////}

//class AuthProvider{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> signInWithEmail(String email, String password) async{
return (await _auth.signInWithEmailAndPassword(email: "ramyshree.s@dreamorbit.com", password: "Eikon@8892")).uid;

  }

//}

//AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
//
//FirebaseUser user = result.user;