import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = new GoogleSignIn();

Future<FirebaseUser> signInWithGoogle() async{
try{
  GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
  final FirebaseUser user = await _auth.signInWithCredential(credential);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  return user;
}catch(e){
  print('error ${e}');
}
}

void signOutGoogle()async{
  await googleSignIn.signOut();
  print("User Sign out");
}
//clears Firebase Cache data
Future <void> clearCache() async{
 var appDir = (await getTemporaryDirectory()).path;
 new Directory(appDir).delete(recursive: true);
}
