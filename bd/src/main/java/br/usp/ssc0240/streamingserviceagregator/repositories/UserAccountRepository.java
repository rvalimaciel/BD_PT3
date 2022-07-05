package main.java.br.usp.ssc0240.streamingserviceagregator.repositories;

import main.java.br.usp.ssc0240.streamingserviceagregator.exceptions.UserAccountRepositoryException;
import main.java.br.usp.ssc0240.streamingserviceagregator.exceptions.UserAlreadyExistsException;
import main.java.br.usp.ssc0240.streamingserviceagregator.exceptions.UserNotFoundException;
import main.java.br.usp.ssc0240.streamingserviceagregator.model.UserAccount;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Base64;
import java.util.Objects;

//  Classe que de fato executa as consultas SQL
public class UserAccountRepository {

    private final Connection connection;

    public UserAccountRepository(final Connection connection) {
        this.connection = connection;
    }

    //  Função que busca um usuário. Pode gerar duas exceções, uma genérica e uma caso ele não for encontrado
    public UserAccount findById(final String username) throws UserAccountRepositoryException, UserNotFoundException {

        final String query = """
                SELECT u.username, u.password_hash, u.active
                FROM user_account u
                WHERE u.username = ?
                """;

        try (final PreparedStatement statement = prepareStatement(query)) {

            statement.setString(1, username);

            try (final ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return new UserAccount(resultSet.getString(1), resultSet.getString(2), resultSet.getBoolean(3));
                } else {
                    throw new UserNotFoundException(username);
                }
            }
        } catch (final SQLException e) {
            throw new UserAccountRepositoryException("Failed to find by id", e);
        }
    }

    //  Função que insere um usuário.
    public void insertUser(final String username, final String password) throws UserAccountRepositoryException {
        final String query = """
                INSERT INTO user_account
                VALUES (?, ?);
                """;

        try {
            final PreparedStatement statement = prepareStatement(query);
            statement.setString(1, username);
            statement.setString(2, encodePassword(password));

            statement.executeUpdate();
        } catch (final SQLException e) {
            if (Objects.equals(e.getSQLState(), "23505")) {
                throw new UserAlreadyExistsException("Error! User " + username + " already exists! ", e);
            } else {
                throw new UserAccountRepositoryException("Failed to create user " + username + ": ", e);
            }
        }
    }

    // Função que prepara a consulta paramétrica
    private PreparedStatement prepareStatement(final String query) throws SQLException {
        return connection.prepareStatement(query);
    }

    //  Aplica base64 na senha do usuário
    private String encodePassword(final String pw) {
        return Base64.getEncoder().encodeToString(pw.getBytes());
    }
}
