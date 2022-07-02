package main.java.br.usp.ssc0240.streamingserviceagregator;

import main.java.br.usp.ssc0240.streamingserviceagregator.config.DBConfig;
import main.java.br.usp.ssc0240.streamingserviceagregator.repositories.UserAccountRepository;

public class Main {
    public static void main(String[] args) {
        var db = new DBConfig();
        var repo = new UserAccountRepository(db.connect());
//        repo.insertUser("abbe", "bb");
    }
}
