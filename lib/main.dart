import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_admin_client/core/router/app_router.dart';
import 'package:socket_io_admin_client/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:socket_io_admin_client/features/auth/data/repository/auth_repository_impl.dart';
import 'package:socket_io_admin_client/features/auth/domain/usecases/forget_password_usecase.dart';
import 'package:socket_io_admin_client/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:socket_io_admin_client/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:socket_io_admin_client/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:socket_io_admin_client/features/auth/presentation/providers/auth_email_provider.dart';
import 'package:socket_io_admin_client/features/chat/data/datasources/Firestore_chat_datasource.dart';
import 'package:socket_io_admin_client/features/chat/data/repository/chat_repository_impl.dart';
import 'package:socket_io_admin_client/features/chat/domain/usecases/read_chat_usecase.dart';
import 'package:socket_io_admin_client/features/chat/domain/usecases/send_chat_usecase.dart';
import 'package:socket_io_admin_client/features/chat/presentation/providers/add_chat_provider.dart';
import 'package:socket_io_admin_client/features/role/data/datasources/firebase_user_role_datasources.dart';
import 'package:socket_io_admin_client/features/role/data/repository/user_role_repository_impl.dart';
import 'package:socket_io_admin_client/features/role/domain/usecases/user_role_usecases.dart';
import 'package:socket_io_admin_client/features/role/presentation/providers/user_role_drop_down_provider.dart';
import 'package:socket_io_admin_client/features/role/presentation/providers/user_role_provider.dart';
import 'package:socket_io_admin_client/features/user/data/datasources/firestore_user_client_datasource.dart';
import 'package:socket_io_admin_client/features/user/data/repository/user_client_repository_impl.dart';
import 'package:socket_io_admin_client/features/user/domain/usecases/read_users_use_case.dart';
import 'package:socket_io_admin_client/features/user/domain/usecases/update_client_fields_use_case.dart';
import 'package:socket_io_admin_client/features/user/presentation/providers/user_client_provider.dart';
import 'package:socket_io_admin_client/features/user/presentation/providers/uuid_generator_provider.dart';
import 'package:socket_io_admin_client/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // DataSources
    final firebaseAuthDataSource = FirebaseAuthDataSource();
    final firebaseUserRoleDataSource = FirebaseUserRoleDataSources();
    final firestoreChatDataSource = FirestoreChatDataSource();
    final firestoreUserClientDataSource = FirestoreUserClientDatasource();

    // Auth Repository
    final authRepository = AuthRepositoryImpl(firebaseAuthDataSource);
    final userRoleRepository = UserRoleRepositoryImpl(
      firebaseUserRoleDataSources: firebaseUserRoleDataSource,
    );
    final chatRepository = ChatRepositoryImpl(
      firestoreChatDataSource: firestoreChatDataSource,
    );
    final userClientRepository = UserClientRepositoryImpl(
      firestoreUserClientDatasource: firestoreUserClientDataSource,
    );

    // Use Cases
    final signInUseCase = SignInUseCase(authRepository: authRepository);
    final signUpUseCase = SignUpUseCase(authRepository: authRepository);
    final forgetPasswordUseCase = ForgetPasswordUseCase(
      authRepository: authRepository,
    );
    final signOutUseCase = SignOutUseCase(authRepository: authRepository);
    final userRoleUseCase = UserRoleUseCase(
      userRoleRepository: userRoleRepository,
    );
    final readChatUseCase = ReadChatUseCase(chatRepository: chatRepository);
    final sendChatUseCase = SendChatUseCase(chatRepository: chatRepository);
    final updateClientFieldsUseCase = UpdateClientFieldsUseCase(
      userClientRepository: userClientRepository,
    );
    final readAllUserDataUseCase = ReadUsersUseCase(
      userClientRepository: userClientRepository,
    );

    return MultiProvider(
      providers: [
        // Auth Provider
        ChangeNotifierProvider(
          create: (context) => AuthEmailProvider(
            signInUseCase: signInUseCase,
            signUpUseCase: signUpUseCase,
            forgetPasswordUseCase: forgetPasswordUseCase,
            signOutUseCase: signOutUseCase,
          ),
        ),

        // User Role DropDown Provider
        ChangeNotifierProvider(create: (context) => UserRoleDropDownProvider()),

        // User Role Provider
        ChangeNotifierProvider(
          create: (context) =>
              UserRoleProvider(userRoleUseCase: userRoleUseCase),
        ),

        // Add Chat Provider
        ChangeNotifierProvider(
          create: (context) => ChatProvider(
            sendChatUseCase: sendChatUseCase,
            readChatUseCase: readChatUseCase,
          ),
        ),

        // User Client Provider
        ChangeNotifierProvider(
          create: (context) => UserClientProvider(
            updateClientFieldsUseCase: updateClientFieldsUseCase,
            readUsersUseCase: readAllUserDataUseCase,
          ),
        ),

        // UUID Generator Provider
        ChangeNotifierProvider(create: (context) => UUIDGeneratorProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Web Socket Client & User',
        // Router
        routerConfig: appRouter,
      ),
    );
  }
}
