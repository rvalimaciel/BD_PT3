package br.usp.ssc0240.streamingserviceagregator.repositories;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

import br.usp.ssc0240.streamingserviceagregator.config.DBConfig;
import br.usp.ssc0240.streamingserviceagregator.exceptions.UserAccountRepositoryException;
import br.usp.ssc0240.streamingserviceagregator.model.UserAccount;

class UserAccountRepositoryIT {

	private final UserAccountRepository repository;

	UserAccountRepositoryIT() {

		final var dbConfig = new DBConfig();

		repository = new UserAccountRepository(dbConfig.connect());
	}

	@Test
	void should_Return_UserAccount_When_FindById_Called_Given_Existent_Username()
		throws UserAccountRepositoryException {

		final UserAccount user = repository.findById("dmdemoura");

		assertNotNull(user);
		assertEquals("dmdemoura", user.username());
		assertEquals("todo-use-real-hash", user.passwordHash());
	}

	@Test
	void should_Return_Null_When_FindById_Called_Given_Non_Existent_Username()
		throws UserAccountRepositoryException {

		final UserAccount user = repository.findById("bacon");

		assertNull(user);
	}
}
