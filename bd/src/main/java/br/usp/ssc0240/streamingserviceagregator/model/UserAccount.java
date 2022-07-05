package main.java.br.usp.ssc0240.streamingserviceagregator.model;

//  Classe que define o modelo da tabela user_account
public record UserAccount(String username, String passwordHash, boolean active) {
    //  Função usada para retornar a linha da tabela como um texto legível
    @Override
    public String toString() {
        if (active) {
            return "Usuário: " + username + "\n" + "Senha hasheada: " + passwordHash + "\n" + "Situação: Ativa";
        }
        return "Usuário: " + username + "\n" + "Senha hasheada: " + passwordHash + "\n" + "Situação: Inativa";
    }
}
