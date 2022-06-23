import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConfig{
    // Fix to work in your machine or create bd with same name and a new user with this config
    private final String url = "jdbc:postgresql://localhost:5432/bd_pt3";
    private final String user = "rodrigo";
    private final String password = "rodrigo";

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
