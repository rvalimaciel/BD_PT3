package main.java.br.usp.ssc0240.streamingserviceagregator;

import main.java.br.usp.ssc0240.streamingserviceagregator.cli.Interface;
import main.java.br.usp.ssc0240.streamingserviceagregator.config.DBConfig;
import main.java.br.usp.ssc0240.streamingserviceagregator.exceptions.UserAccountRepositoryException;
import main.java.br.usp.ssc0240.streamingserviceagregator.repositories.UserAccountRepository;

public class Main {
    public static void main(String[] args) {
        Interface mainInterface = new Interface();
        mainInterface.mainInterface();
    }
}
