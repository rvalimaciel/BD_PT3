package main.java.br.usp.ssc0240.streamingserviceagregator.cli;

public enum InterfaceText {
    mainMessage("""
            DIGITE O NÚMERO DA OPERAÇÃO DESEJADA:\s
               1.) CRIAR USUÁRIO
               2.) BUSCAR USUÁRIO
               3.) SAIR
            """),

    createUserMessage("CRIAR USUÁRIO \n"),
    searchUserMessage("BUSCAR USUÁRIO \n"),
    usernameMessage("DIGITE O NOME DE USUÁRIO: \n"),
    passwordMessage("DIGITE A SENHA DO USUÁRIO: \n");

    private final String text;

    InterfaceText(String s) {
        text = s;
    }

    public String getText() {
        return text;
    }
}
