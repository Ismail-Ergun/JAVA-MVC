package com.ecommerce.dao;

import com.ecommerce.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> getAllProducts(boolean includeInactive) {
        List<Product> list = new ArrayList<>();
        String query = "SELECT p.id, p.category_id, c.name AS category_name, p.name, p.description, p.price, p.stock, p.image_url, p.is_active, p.created_at " +
                       "FROM products p " +
                       "JOIN categories c ON p.category_id = c.id ";
        if (!includeInactive) {
            query += "WHERE p.is_active = TRUE AND c.is_active = TRUE ";
        }
        query += "ORDER BY p.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Product p = new Product(
                    rs.getInt("id"),
                    rs.getInt("category_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("stock"),
                    rs.getString("image_url"),
                    rs.getBoolean("is_active"),
                    rs.getTimestamp("created_at")
                );
                p.setCategoryName(rs.getString("category_name"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getActiveProductsByCategoryId(int categoryId) {
        List<Product> list = new ArrayList<>();
        String query = "SELECT p.id, p.category_id, c.name AS category_name, p.name, p.description, p.price, p.stock, p.image_url, p.is_active, p.created_at " +
                       "FROM products p " +
                       "JOIN categories c ON p.category_id = c.id " +
                       "WHERE p.is_active = TRUE AND c.is_active = TRUE AND p.category_id = ? " +
                       "ORDER BY p.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getString("image_url"),
                        rs.getBoolean("is_active"),
                        rs.getTimestamp("created_at")
                    );
                    p.setCategoryName(rs.getString("category_name"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> searchProducts(String keyword) {
        List<Product> list = new ArrayList<>();
        String query = "SELECT p.id, p.category_id, c.name AS category_name, p.name, p.description, p.price, p.stock, p.image_url, p.is_active, p.created_at " +
                       "FROM products p " +
                       "JOIN categories c ON p.category_id = c.id " +
                       "WHERE p.is_active = TRUE AND c.is_active = TRUE AND (LOWER(p.name) LIKE ? OR LOWER(p.description) LIKE ?) " +
                       "ORDER BY p.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            String searchPattern = "%" + keyword.toLowerCase() + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getString("image_url"),
                        rs.getBoolean("is_active"),
                        rs.getTimestamp("created_at")
                    );
                    p.setCategoryName(rs.getString("category_name"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int id) {
        String query = "SELECT p.id, p.category_id, c.name AS category_name, p.name, p.description, p.price, p.stock, p.image_url, p.is_active, p.created_at " +
                       "FROM products p " +
                       "JOIN categories c ON p.category_id = c.id " +
                       "WHERE p.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getString("image_url"),
                        rs.getBoolean("is_active"),
                        rs.getTimestamp("created_at")
                    );
                    p.setCategoryName(rs.getString("category_name"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addProduct(Product product) {
        String query = "INSERT INTO products (category_id, name, description, price, stock, image_url, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, product.getCategoryId());
            stmt.setString(2, product.getName());
            stmt.setString(3, product.getDescription());
            stmt.setDouble(4, product.getPrice());
            stmt.setInt(5, product.getStock());
            stmt.setString(6, product.getImageUrl());
            stmt.setBoolean(7, product.isActive());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProduct(Product product) {
        String query = "UPDATE products SET category_id = ?, name = ?, description = ?, price = ?, stock = ?, image_url = ?, is_active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, product.getCategoryId());
            stmt.setString(2, product.getName());
            stmt.setString(3, product.getDescription());
            stmt.setDouble(4, product.getPrice());
            stmt.setInt(5, product.getStock());
            stmt.setString(6, product.getImageUrl());
            stmt.setBoolean(7, product.isActive());
            stmt.setInt(8, product.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteProduct(int id) {
        // Check if there are order items referencing this product
        String checkQuery = "SELECT COUNT(*) FROM order_items WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
            
            checkStmt.setInt(1, id);
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Soft delete: set inactive to preserve order history integrity
                    String deactivateQuery = "UPDATE products SET is_active = FALSE WHERE id = ?";
                    try (PreparedStatement deactStmt = conn.prepareStatement(deactivateQuery)) {
                        deactStmt.setInt(1, id);
                        return deactStmt.executeUpdate() > 0;
                    }
                }
            }
            
            // Hard delete if never ordered
            String deleteQuery = "DELETE FROM products WHERE id = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery)) {
                deleteStmt.setInt(1, id);
                return deleteStmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStock(int id, int newStock) {
        String query = "UPDATE products SET stock = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, newStock);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
