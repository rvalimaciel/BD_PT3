package main.java.br.usp.ssc0240.streamingserviceagregator.usecase;

import main.java.br.usp.ssc0240.streamingserviceagregator.config.DBConfig;
import main.java.br.usp.ssc0240.streamingserviceagregator.exceptions.UserAccountRepositoryException;
import main.java.br.usp.ssc0240.streamingserviceagregator.exceptions.UserAlreadyExistsException;
import main.java.br.usp.ssc0240.streamingserviceagregator.exceptions.UserNotFoundException;
import main.java.br.usp.ssc0240.streamingserviceagregator.model.UserAccount;
import main.java.br.usp.ssc0240.streamingserviceagregator.repositories.UserAccountRepository;

public class UserOperations {
    private final DBConfig config = new DBConfig();
    private final UserAccountRepository user = new UserAccountRepository(config.connect());

    // Função que chama a criação de usuário
    public void createUser(String username, String password) throws UserAlreadyExistsException {
        try {
            user.insertUser(username, password);
        } catch (UserAlreadyExistsException e) {
            throw e;
        } catch (UserAccountRepositoryException e) {
            System.out.println("Erro desconhecido ao tentar criar usuário: \n" + e);
        }
    }

    // Função que chama a leitura de usuário
    public UserAccount readUser(String username) {
        try {
            return user.findById(username);
        } catch (UserAccountRepositoryException e) {
            System.out.println("Erro desconhecido ao tentar encontrar usuário: \n" + e);
        } catch (UserNotFoundException e) {
            System.out.println("Usuário " + e.getMessage() + " não encontrado!");
        }
        return null;
    }
}
