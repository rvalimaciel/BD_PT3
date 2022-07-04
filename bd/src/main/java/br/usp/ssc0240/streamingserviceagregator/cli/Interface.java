package main.java.br.usp.ssc0240.streamingserviceagregator.cli;

import main.java.br.usp.ssc0240.streamingserviceagregator.config.DBConfig;
import main.java.br.usp.ssc0240.streamingserviceagregator.exceptions.UserAlreadyExistsException;
import main.java.br.usp.ssc0240.streamingserviceagregator.repositories.UserAccountRepository;
import main.java.br.usp.ssc0240.streamingserviceagregator.usecase.UserOperations;

import java.util.InputMismatchException;
import java.util.Scanner;

public class Interface {
    private String mainMessage = """

            DIGITE O NÚMERO DA OPERAÇÃO DESEJADA:\s
               1.) CRIAR USUÁRIO
               2.) BUSCAR USUÁRIO
               3.) SAIR
            """;
    private String createUserMessage = "CRIAR USUÁRIO \n";
    private String usernameMessage = "DIGITE O NOME DE USUÁRIO: \n";
    private String passwordMessage = "DIGITE A SENHA DO USUÁRIO: \n";

    private Scanner scanner = new Scanner(System.in);
    private UserOperations userOperations = new UserOperations();


    public void mainInterface() {
        Integer selectedOption = 0;
        while (selectedOption != 3) {
            System.out.println(mainMessage);
            selectedOption = readNumberInput();
            switch (selectedOption) {
                case 1:
                    createUserInterface();
                    break;
                case 2:
                    searchUserInterface();
                    break;
                case 3:
                    break;
                default:
                    System.out.println("Número digitado inválido!");
            }
        }
    }

    private int readNumberInput() {
        try {
            return scanner.nextInt();
        } catch(InputMismatchException e) {
            scanner.next();
            System.out.println("Por favor, digite um número.");
            return  0;
        }
    }


    public void createUserInterface(){
        System.out.println(createUserMessage);
        System.out.println(usernameMessage);
        String username = scanner.next();
        System.out.println(passwordMessage);
        String password = scanner.next();

        try {
            userOperations.createUser(username, password);
            System.out.println("Usuário " + username + " criado.");
        } catch (UserAlreadyExistsException e) {
            System.out.println("Nome de usuário já existe. Tente novamente com outro.");
        }
    }
    public static void searchUserInterface(){}

}
