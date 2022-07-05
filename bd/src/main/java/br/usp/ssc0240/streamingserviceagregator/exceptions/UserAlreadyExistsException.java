package main.java.br.usp.ssc0240.streamingserviceagregator.exceptions;

//  Exceção de usuário já existe (PK violation na tabela user_account)
public class UserAlreadyExistsException extends UserAccountRepositoryException {
    public UserAlreadyExistsException(String msg, Exception cause) {
        super(msg, cause);
    }
}
