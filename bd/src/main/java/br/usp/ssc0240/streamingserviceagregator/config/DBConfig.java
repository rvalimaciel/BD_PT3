package br.usp.ssc0240.streamingserviceagregator.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConfig{
    // Fix to work in your machine or create bd with same name and a new user with this config
    private final String url = "jdbc:postgresql://localhost:5432/streaming_service_agregator?currentSchema=streaming_service_agregator";
    private final String user = "app";
    private final String password = "dev";

    public Connection connect() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Success.");
        } catch (SQLException e) {
            System.out.println(e.getMessage()); // add better error management later
        }
        return conn;
    }
}
