package main.java.br.usp.ssc0240.streamingserviceagregator;

import main.java.br.usp.ssc0240.streamingserviceagregator.cli.Interface;

// Classe principal. Só chama a CLI.
public class Main {
    public static void main(String[] args) {
        Interface mainInterface = new Interface();
        mainInterface.mainInterface();
    }
}
