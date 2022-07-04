package main.java.br.usp.ssc0240.streamingserviceagregator.exceptions;

public class UserNotFoundException extends Exception {
    public UserNotFoundException(String username) {
        super(username);
    }
}