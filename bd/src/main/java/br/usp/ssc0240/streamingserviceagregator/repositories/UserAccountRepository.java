package br.usp.ssc0240.streamingserviceagregator.repositories;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import br.usp.ssc0240.streamingserviceagregator.model.UserAccount;
import br.usp.ssc0240.streamingserviceagregator.exceptions.UserAccountRepositoryException;

public class UserAccountRepository {

	private final Connection connection;

	public UserAccountRepository(final Connection connection) {
		this.connection = connection;
	}

	public UserAccount findById(final String username) throws UserAccountRepositoryException {

		final String query = """
			SELECT u.username, u.password_hash
			FROM user_account u
			WHERE u.username = ?
			""";

		try (final PreparedStatement statement = connection.prepareStatement(query)) {

			statement.setString(1, username);
			
			try (final ResultSet resultSet = statement.executeQuery()) {
				
				if (resultSet.next()) {
					return new UserAccount(resultSet.getString(1), resultSet.getString(2));
				}
				else {
					return null;
				}
			}
		}
		catch (final SQLException e) {
			throw new UserAccountRepositoryException("Failed to find by id", e);
		}
	}
}
