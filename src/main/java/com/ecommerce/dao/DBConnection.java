package com.ecommerce.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String DEFAULT_URL = "jdbc:postgresql://localhost:5432/ecommerce_db";
    private static final String DEFAULT_USER = "furkan";
    private static final String DEFAULT_PASS = "gizlisifre";

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("PostgreSQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        String url = System.getenv("DB_URL");
        if (url == null || url.trim().isEmpty()) {
            url = DEFAULT_URL;
        }
        
        String user = System.getenv("DB_USER");
        if (user == null || user.trim().isEmpty()) {
            user = DEFAULT_USER;
        }

        String pass = System.getenv("DB_PASS");
        if (pass == null || pass.trim().isEmpty()) {
            pass = DEFAULT_PASS;
        }

        return DriverManager.getConnection(url, user, pass);
    }
}
