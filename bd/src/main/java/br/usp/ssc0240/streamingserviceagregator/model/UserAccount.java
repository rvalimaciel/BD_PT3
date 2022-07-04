package main.java.br.usp.ssc0240.streamingserviceagregator.model;

public record UserAccount(String username, String passwordHash, boolean active) {
    @Override
    public String toString() {
        if (active) {
            return "Usuário: " + username + "\n" + "Senha hasheada: " + passwordHash + "\n" + "Situação: Ativa";
        }
        return "Usuário: " + username + "\n" + "Senha hasheada: " + passwordHash + "\n" + "Situação: Inativa";
    }
}
