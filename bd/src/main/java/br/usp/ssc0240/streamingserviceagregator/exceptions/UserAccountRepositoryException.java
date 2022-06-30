package br.usp.ssc0240.streamingserviceagregator.exceptions;

public class UserAccountRepositoryException extends Exception {

	public UserAccountRepositoryException(final String msg, final Exception cause) {
		super(msg, cause);
	}
}
