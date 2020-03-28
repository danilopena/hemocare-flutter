import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseSocialAuth {
  Future<AuthResult> loginWithGoogle();
}

class SocialAuth implements BaseSocialAuth {
  @override
  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final AuthResult authResult =
        (await _auth.signInWithCredential(credential));
    print("AuthResult ${authResult.user}");
    return authResult;
  }
}
