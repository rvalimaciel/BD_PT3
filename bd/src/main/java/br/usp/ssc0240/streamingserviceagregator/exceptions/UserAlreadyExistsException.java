package main.java.br.usp.ssc0240.streamingserviceagregator.exceptions;

public class UserAlreadyExistsException extends UserAccountRepositoryException {
    public UserAlreadyExistsException(String msg, Exception cause) {
        super(msg, cause);
    }
}
