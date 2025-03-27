import 'dart:convert';
import 'dart:io';
import 'dart:developer' as log;
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hana_sdk/errors/error_handler_new.dart';
import 'package:hana_sdk/network/api_result_handler.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Either<ApiFailure, User?>> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      return Right(user);
    } on SocketException {
      log.log("SocketException===>${e.toString()}");
      return Left(DataSource.RECIEVE_TIMEOUT.getFailure());
    } on FormatException {
      log.log("FormatException===>${e.toString()}");
      return Left(DataSource.RECIEVE_TIMEOUT.getFailure());
    } on DioException catch (error) {
      log.log("DioException===>${e.toString()}");
      return Left(ErrorHandler.handle(error).failure);
    } on FirebaseAuthException catch (error) {
      log.log("FirebaseAuthException===>${e.toString()}");
      return Left(ErrorHandler.handle(error).failure);
    } catch (e) {
      log.log("google Sign In error===>${e.toString()}");
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      log.log(e.toString());
    }
  }
  

// //need an apple account
//   Future<Either<ApiFailure, User?>> signInWithApple() async {
//     try {
//       /// You have to put your service id here which you can find in previous steps
//       /// or in the following link: https://developer.apple.com/account/resources/identifiers/list/serviceId
//       String clientID = 'com.mathiue.flypool-service';

//       /// Now you have to put the redirectURL which you received from Glitch Server
//       /// make sure you only copy the part till "https://<GLITCH PROVIDED UNIQUE NAME>.glitch.me/"
//       /// and append the following part to it "callbacks/sign_in_with_apple"
//       ///
//       /// It will look something like this
//       /// https://<GLITCH PROVIDED UNIQUE NAME>.glitch.me/callbacks/sign_in_with_apple
//       String redirectURL =
//           'https://invented-calm-tile.glitch.me/callbacks/sign_in_with_apple'; 

//       /// Generates a Random String from 1-9 and A-Z characters.
//       final rawNonce = generateNonce();

//       /// We are convering that rawNonce into SHA256 for security purposes
//       /// In our login.
//       final nonce = sha256ofString(rawNonce);

//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//         /// Scopes are the values that you are requiring from
//         /// Apple Server.
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//           AppleIDAuthorizationScopes.values[0],
//         ],
//         nonce: Platform.isIOS ? nonce : null,

//         /// We are providing Web Authentication for Android Login,
//         /// Android uses web browser based login for Apple.
//         webAuthenticationOptions: Platform.isIOS
//             ? null
//             : WebAuthenticationOptions(
//                 clientId: clientID,
//                 redirectUri: Uri.parse(redirectURL),
//               ),
//       );

//       final AuthCredential appleAuthCredential =
//           OAuthProvider('apple.com').credential(
//         idToken: appleCredential.identityToken,
//         rawNonce: Platform.isIOS ? rawNonce : null,
//         accessToken: Platform.isIOS ? null : appleCredential.authorizationCode,
//       );

//       /// Once you are successful in generating Apple Credentials,
//       /// We pass them into the Firebase function to finally sign in.
//       /* UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(appleAuthCredential);
//       return userCredential.user;*/

//       final UserCredential userCredential =
//           await _auth.signInWithCredential(appleAuthCredential);
//       final User? user = userCredential.user;

//       return Right(user);
//     } on SocketException {
//       log.log("SocketException===>${e.toString()}");
//       return Left(DataSource.RECIEVE_TIMEOUT.getFailure());
//     } on FormatException {
//       log.log("FormatException===>${e.toString()}");
//       return Left(DataSource.RECIEVE_TIMEOUT.getFailure());
//     } on DioException catch (error) {
//       log.log("DioException===>${e.toString()}");
//       return Left(ErrorHandler.handle(error).failure);
//     } on FirebaseAuthException catch (error) {
//       log.log("FirebaseAuthException===>${e.toString()}");
//       return Left(ErrorHandler.handle(error).failure);
//     } catch (e) {
//       log.log("google Sign In error===>${e.toString()}");
//       return Left(ErrorHandler.handle(e).failure);
//     }
//   }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
