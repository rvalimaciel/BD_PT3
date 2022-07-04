package main.java.br.usp.ssc0240.streamingserviceagregator.cli;

import main.java.br.usp.ssc0240.streamingserviceagregator.exceptions.UserAlreadyExistsException;
import main.java.br.usp.ssc0240.streamingserviceagregator.model.UserAccount;
import main.java.br.usp.ssc0240.streamingserviceagregator.usecase.UserOperations;

import java.util.InputMismatchException;
import java.util.Scanner;

import static main.java.br.usp.ssc0240.streamingserviceagregator.cli.InterfaceText.*;

public class Interface {

    private final Scanner scanner = new Scanner(System.in);
    private final UserOperations userOperations = new UserOperations();


    public void mainInterface() {
        int selectedOption = 0;
        while (selectedOption != 3) {
            System.out.println(mainMessage.getText());
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
        System.out.println(createUserMessage.getText());
        System.out.println(usernameMessage.getText());
        String username = scanner.next();
        System.out.println(passwordMessage.getText());
        String password = scanner.next();

        try {
            userOperations.createUser(username, password);
            System.out.println("Usuário " + username + " criado.");
        } catch (UserAlreadyExistsException e) {
            System.out.println("Nome de usuário já existe. Tente novamente com outro.");
        }
    }
    public void searchUserInterface(){
        System.out.println(searchUserMessage.getText());
        System.out.println(usernameMessage.getText());
        String username = scanner.next();

        UserAccount u = userOperations.readUser(username);
        if (u != null) {
            System.out.println(u);
        }

    }

}
