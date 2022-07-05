package main.java.br.usp.ssc0240.streamingserviceagregator.exceptions;

//  Exceção jogada quando o usuário não é encontrado
public class UserNotFoundException extends Exception {
    public UserNotFoundException(String username) {
        super(username);
    }
}