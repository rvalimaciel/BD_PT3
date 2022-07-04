package main.java.br.usp.ssc0240.streamingserviceagregator.model;

public record UserAccount(String username, String passwordHash, boolean active) {

}
