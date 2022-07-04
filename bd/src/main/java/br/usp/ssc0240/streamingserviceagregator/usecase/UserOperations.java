package main.java.br.usp.ssc0240.streamingserviceagregator.usecase;

import main.java.br.usp.ssc0240.streamingserviceagregator.config.DBConfig;
import main.java.br.usp.ssc0240.streamingserviceagregator.exceptions.UserAccountRepositoryException;
import main.java.br.usp.ssc0240.streamingserviceagregator.exceptions.UserAlreadyExistsException;
import main.java.br.usp.ssc0240.streamingserviceagregator.repositories.UserAccountRepository;

public class UserOperations {
    private DBConfig config = new DBConfig();
    private UserAccountRepository user = new UserAccountRepository(config.connect());

    public void createUser(String username, String password) throws UserAlreadyExistsException {
        try {
            user.insertUser(username, password);
        } catch (UserAlreadyExistsException e) {
            throw e;
        } catch (UserAccountRepositoryException e) {
            System.out.println("Erro desconhecido ao tentar criar usuário: \n" + e);
        }
    }

//    public void readUser(String username) {
//        try {
//
//        } catch () {
//
//        }
//    }
}
