package main.java.br.usp.ssc0240.streamingserviceagregator.exceptions;

//  Exceção genérica de operações de usuário
public class UserAccountRepositoryException extends Exception {
    public UserAccountRepositoryException(final String msg, final Exception cause) {
        super(msg, cause);
    }
}

