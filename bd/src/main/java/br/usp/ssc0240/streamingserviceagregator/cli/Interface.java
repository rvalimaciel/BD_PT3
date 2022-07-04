package main.java.br.usp.ssc0240.streamingserviceagregator.cli;

import main.java.br.usp.ssc0240.streamingserviceagregator.exceptions.UserAlreadyExistsException;
import main.java.br.usp.ssc0240.streamingserviceagregator.usecase.UserOperations;

import java.util.InputMismatchException;
import java.util.Scanner;

public class Interface {

    private final Scanner scanner = new Scanner(System.in);
    private final UserOperations userOperations = new UserOperations();


    public void mainInterface() {
        int selectedOption = 0;
        while (selectedOption != 3) {
            String mainMessage = """

                    DIGITE O NÚMERO DA OPERAÇÃO DESEJADA:\s
                       1.) CRIAR USUÁRIO
                       2.) BUSCAR USUÁRIO
                       3.) SAIR
                    """;
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
        String createUserMessage = "CRIAR USUÁRIO \n";
        System.out.println(createUserMessage);
        String usernameMessage = "DIGITE O NOME DE USUÁRIO: \n";
        System.out.println(usernameMessage);
        String username = scanner.next();
        String passwordMessage = "DIGITE A SENHA DO USUÁRIO: \n";
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
